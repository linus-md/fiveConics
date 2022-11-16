R = QQ[a1, a2, a3, a4, a5, a6, u1, u2, u3, u4, u5, u6, x, y]

A = a1*x^2 + a2*x*y + a3*y^2 +a4*x + a5*y + a6
U = u1*x^2 + u2*x*y + u3*y^2 +u4*x + u5*y + u6
T = diff(x, A) * diff(y, U) - diff(y, A) * diff(x, U)

I = ideal(A, U, T)
eliminate(y, eliminate(x, I))
