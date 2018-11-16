############################################################
## joLooseMatrixInplace - overloaded Base functions

# eltype(jo)

# deltype(jo)

# reltype(jo)

# show(jo)

# display(jo)

# size(jo)

# size(jo,1/2)

# length(jo)

# jo_full(jo)

# norm(jo)

# real(jo)

# imag(jo)

# conj(jo)
conj(A::joLooseMatrixInplace{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrixInplace{DDT,RDT}("conj("*A.name*")",A.m,A.n,
        A.fop_C,
        A.fop_A,
        A.fop_T,
        A.fop,
        A.iop_C,
        A.iop_A,
        A.iop_T,
        A.iop
        )

# transpose(jo)
transpose(A::joLooseMatrixInplace{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrixInplace{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
        A.fop_T,
        A.fop,
        A.fop_C,
        A.fop_A,
        A.iop_T,
        A.iop,
        A.iop_C,
        A.iop_A
        )

# adjoint(jo)
adjoint(A::joLooseMatrixInplace{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrixInplace{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
        A.fop_A,
        A.fop_C,
        A.fop,
        A.fop_T,
        A.iop_A,
        A.iop_C,
        A.iop,
        A.iop_T
        )

# isreal(jo)

# issymmetric(jo)

# ishermitian(jo)

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)

# *(jo,mvec)

# *(mvec,jo)

# *(jo,vec)

# *(vec,jo)

# *(num,jo)

# *(jo,num)

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)

# \(jo,mvec)

# \(mvec,jo)

# \(jo,vec)

# \(vec,jo)

# \(num,jo)

# \(jo,num)

############################################################
## overloaded Base +(...jo...)

# +(jo)

# +(jo,jo)

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)

# +(num,jo)

############################################################
## overloaded Base -(...jo...)

# -(jo)

# -(jo,jo)

# -(jo,mvec)

# -(mvec,jo)

# -(jo,vec)

# -(vec,jo)

# -(jo,num)

# -(num,jo)

############################################################
## overloaded Base .*(...jo...)

############################################################
## overloaded Base .\(...jo...)

############################################################
## overloaded Base .+(...jo...)

############################################################
## overloaded Base .-(...jo...)

############################################################
## overloaded Base block methods

# hcat(...jo...)

# vcat(...jo...)

# hvcat(...jo...)

############################################################
## overloaded LinearAlgebra functions

# mul!(...,jo,...)
function mul!(y::LocalVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::LocalVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end
function mul!(y::LocalMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::LocalMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end

# ldiv!(...,jo,...)
function ldiv!(y::LocalVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::LocalVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end
function ldiv!(y::LocalMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::LocalMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end

