############################################################
## joLooseMatrixInplace - overloaded Base functions

# eltype(jo)

# deltype(jo)

# reltype(jo)

# show(jo)

# showall(jo)

# display(jo)

# size(jo)

# size(jo,1/2)

# length(jo)

# full(jo)

# norm(jo)

# real(jo)

# imag(jo)

# conj(jo)

# transpose(jo)

# adjoint(jo)

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
## overloaded Base.LinAlg functions

# A_mul_B!(...,jo,...)
function A_mul_B!(y::AbstractVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop(y,x)
    return nothing
end
function A_mul_B!(y::AbstractMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop(y,x)
    return nothing
end

# At_mul_B!(...,jo,...)
function At_mul_B!(y::AbstractVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop_T(y,x)
    return nothing
end
function At_mul_B!(y::AbstractMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop_T(y,x)
    return nothing
end

# Ac_mul_B!(...,jo,...)
function Ac_mul_B!(y::AbstractVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop_A(y,x)
    return nothing
end
function Ac_mul_B!(y::AbstractMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.fop_A(y,x)
    return nothing
end

# A_ldiv_B!(...,jo,...)
function A_ldiv_B!(y::AbstractVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return nothing
end
function A_ldiv_B!(y::AbstractMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return nothing
end

# At_ldiv_B!(...,jo,...)
function At_ldiv_B!(y::AbstractVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop_T)(y,x)
    return nothing
end
function At_ldiv_B!(y::AbstractMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop_T)(y,x)
    return nothing
end

# Ac_ldiv_B!(...,jo,...)
function Ac_ldiv_B!(y::AbstractVector{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop_A)(y,x)
    return nothing
end
function Ac_ldiv_B!(y::AbstractMatrix{YDT},A::joLooseMatrixInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseMatrixInplaceException("shape mismatch"))
    get(A.iop_A)(y,x)
    return nothing
end

