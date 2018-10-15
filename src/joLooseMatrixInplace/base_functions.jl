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
function mul!(y::AbstractVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end
function mul!(y::AbstractMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end

# A_mul_B!(...,jo,...)
function A_mul_B!(y::AbstractVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end
function A_mul_B!(y::AbstractMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end

# At_mul_B!(...,jo,...)
function At_mul_B!(y::AbstractVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop_T(y,x)
    return y
end
function At_mul_B!(y::AbstractMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop_T(y,x)
    return y
end

# Ac_mul_B!(...,jo,...)
function Ac_mul_B!(y::AbstractVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop_A(y,x)
    return y
end
function Ac_mul_B!(y::AbstractMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop_A(y,x)
    return y
end

# ldiv!(...,jo,...)
function ldiv!(y::AbstractVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end
function ldiv!(y::AbstractMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end

# A_ldiv_B!(...,jo,...)
function A_ldiv_B!(y::AbstractVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end
function A_ldiv_B!(y::AbstractMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end

# At_ldiv_B!(...,jo,...)
function At_ldiv_B!(y::AbstractVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop_T)(y,x)
    return y
end
function At_ldiv_B!(y::AbstractMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop_T)(y,x)
    return y
end

# Ac_ldiv_B!(...,jo,...)
function Ac_ldiv_B!(y::AbstractVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop_A)(y,x)
    return y
end
function Ac_ldiv_B!(y::AbstractMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop_A)(y,x)
    return y
end

