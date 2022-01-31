# Example for building JOLI operator having functions
# defining action for forward and transpose mapping
#
# we will use plain matrix to fake the actions

using JOLI

# forward function
function fwd(A::AbstractMatrix,vin::AbstractVector,RDT::DataType)
    vout=A*vin
    return jo_convert(RDT,vout)
end

# transpose function
function fwdT(A::AbstractMatrix,vin::AbstractVector,RDT::DataType)
    vout=transpose(A)*vin
    return jo_convert(RDT,vout)
end

# define matrix for mapping functions
a=rand(ComplexF32,3,3)

# define JOLI operator with desired domain and range using
# using joLinearFunctionFwdT constructor
# note forced dropping imaginary part for transpose/adjoint operators
A=joLinearFunctionFwd_T(3,3,
    v->fwd(a,v,ComplexF64),v->fwdT(a,v,Float32),
    Float32,ComplexF64;name="my_A")
show(A)

# disable warining for implicit inacurate conversions - use only after debugging your code
jo_convert_warn_set(false)

# display elements of the operator
println("forward: A")
show(A); display(elements(A)); println()
println("transpose: transpose(A)")
show(transpose(A)); display(elements(transpose(A))); println()
println("adjoint: A'")
show(A'); display(elements(A')); println()
println("conjugate: conj(A)")
show(conj(A)); display(elements(conj(A))); println()

# multiply by vector
x=rand(Float32,3)
y=A*x
println("y: ",y)
xx=A'*y
println("xx: ",xx)
