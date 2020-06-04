
using JOLI

M=7;N=9
for UT in (Float64,ComplexF64), VT in (Float64,ComplexF64)
    U=rand(UT,M,2)
    V=rand(VT,N,2)
    UV=U*adjoint(V)

    A=joOuterProd(U,V,DDT=promote_type(UT,VT))
    x=rand(deltype(A),N,2)
    y=rand(reltype(A),M,2)
    println((A.name,typeof(A),size(A)))
    println(("...",
        isapprox(UV*x,A*x),
        isapprox(transpose(UV)*y,transpose(A)*y),
        isapprox(adjoint(UV)*y,adjoint(A)*y),
        isapprox(conj(UV)*x,conj(A)*x))
        )
    println((".....",isadjoint(A)[1],islinear(A)[1]))

end

