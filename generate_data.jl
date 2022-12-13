using HomotopyContinuation
using LinearAlgebra
using DataFrames
using CSV

using Pkg
Pkg.add("BenchmarkTools")
using BenchmarkTools

function generate_data(n)
    function F()
        @var u[1:5] # generic conic
        @var x[1:5], y[1:5] # points (5)
        @var a[1:5], b[1:5], c[1:5], d[1:5], e[1:5] # five conics

        f1 = a[1]*x[1]^2 + a[2]*x[1]*y[1] + a[3]*y[1]^2 + a[4]*x[1] + a[5]*y[1] + 1 
        f2 = b[1]*x[2]^2 + b[2]*x[2]*y[2] + b[3]*y[2]^2 + b[4]*x[2] + b[5]*y[2] + 1 
        f3 = c[1]*x[3]^2 + c[2]*x[3]*y[3] + c[3]*y[3]^2 + c[4]*x[3] + c[5]*y[3] + 1 
        f4 = d[1]*x[4]^2 + d[2]*x[4]*y[4] + d[3]*y[4]^2 + d[4]*x[4] + d[5]*y[4] + 1 
        f5 = e[1]*x[5]^2 + e[2]*x[5]*y[5] + e[3]*y[5]^2 + e[4]*x[5] + e[5]*y[5] + 1 

        f6 = u[1]*x[1]^2 + u[2]*x[1]*y[1] + u[3]*y[1]^2 + u[4]*x[1] + u[5]*y[1] + 1
        f7 = u[1]*x[2]^2 + u[2]*x[2]*y[2] + u[3]*y[2]^2 + u[4]*x[2] + u[5]*y[2] + 1 
        f8 = u[1]*x[3]^2 + u[2]*x[3]*y[3] + u[3]*y[3]^2 + u[4]*x[3] + u[5]*y[3] + 1 
        f9 = u[1]*x[4]^2 + u[2]*x[4]*y[4] + u[3]*y[4]^2 + u[4]*x[4] + u[5]*y[4] + 1 
        f10 = u[1]*x[5]^2 + u[2]*x[5]*y[5] + u[3]*y[5]^2 + u[4]*x[5] + u[5]*y[5] + 1 

        f11 = det([differentiate(f1, [x[1], y[1]]) differentiate(f6, [x[1], y[1]])]) 
        f12 = det([differentiate(f2, [x[2], y[2]]) differentiate(f7, [x[2], y[2]])]) 
        f13 = det([differentiate(f3, [x[3], y[3]]) differentiate(f8, [x[3], y[3]])]) 
        f14 = det([differentiate(f4, [x[4], y[4]]) differentiate(f9, [x[4], y[4]])]) 
        f15 = det([differentiate(f5, [x[5], y[5]]) differentiate(f10, [x[5], y[5]])]);

        paramVec = collect(Iterators.flatten([a,b,c,d,e]))
        F = System([f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15], 
            variables = [u[1], u[2], u[3], u[4], u[5], x[1], x[2], x[3], x[4], x[5], y[1], y[2], y[3], y[4], y[5]], 
            parameters = paramVec)
        return F
    end

    function gen(F, n)
        function run(F)
            p = randn(25)           
            S = solve(F, target_parameters = p, show_progress = false);                        
            return [p, length(real_solutions(S))]
        end

        df = DataFrame(A=Vector[], B=Int[])
        Threads.@threads for i in 1:n
            push!(df, run(F))
        end
        
        return df
    end

    F = F()
    CSV.write("data_five_random.csv", gen(F, n))
end

@btime generate_data(1)
