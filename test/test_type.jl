T=6
tsname="joLinearFunction Type-enforced forward, transpose, adjoint and conj"
@testset "$tsname" begin

# forward function
function fwd(A::AbstractMatrix,vin::AbstractVector,RDT::DataType)
    vout=A*vin
    return jo_convert(RDT,vout)
end

# adjoint function
function fwdCT(A::AbstractMatrix,vin::AbstractVector,RDT::DataType)
    vout=A'*vin
    return jo_convert(RDT,vout)
end

# transpose function
function fwdT(A::AbstractMatrix,vin::AbstractVector,RDT::DataType)
    vout=transpose(A)*vin
    return jo_convert(RDT,vout)
end

# define matrix for mapping functions
a=rand(ComplexF32,3,3)

# define JOLI operator with real domain and complex range
A1=joLinearFunctionFwd_A(3,3,
    v->fwd(a,v,ComplexF64),v->fwdCT(a,v,Float32),
    Float32,ComplexF64;name="my_A1")
A2=joLinearFunctionFwd_T(3,3,
    v->fwd(a,v,ComplexF64),v->fwdT(a,v,Float32),
    Float32,ComplexF64;name="my_A2")

# disable warining for implicit inacurate conversions - use only after debugging your code
jo_convert_warn_set(false)

x = rand(Float32, 3)
y1 = A1 * x
y2 = A2 * x
@test typeof(y1) == Vector{ComplexF64}
@test typeof(y2) == Vector{ComplexF64}

# note forced dropping imaginary part for transpose/adjoint operators
y = randn(ComplexF64, 3)
x1 = A1' * y
x2 = A2' * y
x3 = transpose(A1) * y
x4 = transpose(A2) * y
@test typeof(x1) == Vector{Float32}
@test typeof(x2) == Vector{Float32}
@test typeof(x3) == Vector{Float32}
@test typeof(x4) == Vector{Float32}

@test isadjoint(A1)[1]
@test isadjoint(A2)[1]

# test for mul!, x will drop the imaginary part because x is real
mul!(y, A1, x)
mul!(x, A1, x)
@test x == jo_convert(Float32, y)
mul!(x, A1', y)
mul!(y, A1', y)
@test x == y

end
