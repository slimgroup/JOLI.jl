############################################################
## joLooseLinearFunctionInplace - overloaded Base functions

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
conj(A::joLooseLinearFunctionInplace{DDT,RDT}) where {DDT,RDT} =
    joLooseLinearFunctionInplace{DDT,RDT}("conj("*A.name*")",A.m,A.n,
        get(A.fop_C),
        A.fop_A,
        A.fop_T,
        A.fop,
        A.iop_C,
        A.iop_A,
        A.iop_T,
        A.iop
        )

# transpose(jo)
transpose(A::joLooseLinearFunctionInplace{DDT,RDT}) where {DDT,RDT} =
    joLooseLinearFunctionInplace{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
        get(A.fop_T),
        A.fop,
        A.fop_C,
        A.fop_A,
        A.iop_T,
        A.iop,
        A.iop_C,
        A.iop_A
        )

# adjoint(jo)
adjoint(A::joLooseLinearFunctionInplace{DDT,RDT}) where {DDT,RDT} =
    joLooseLinearFunctionInplace{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
        get(A.fop_A),
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
function mul!(y::AbstractVector{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.m == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end
function mul!(y::AbstractMatrix{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end

# A_mul_B!(...,jo,...)
function A_mul_B!(y::AbstractVector{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.m == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end
function A_mul_B!(y::AbstractMatrix{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end

# At_mul_B!(...,jo,...)
function At_mul_B!(y::AbstractVector{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.m == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    get(A.fop_T)(y,x)
    return y
end
function At_mul_B!(y::AbstractMatrix{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    get(A.fop_T)(y,x)
    return y
end

# Ac_mul_B!(...,jo,...)
function Ac_mul_B!(y::AbstractVector{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.m == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    get(A.fop_A)(y,x)
    return y
end
function Ac_mul_B!(y::AbstractMatrix{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    get(A.fop_A)(y,x)
    return y
end

# ldiv!(...,jo,...)
function ldiv!(y::AbstractVector{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    hasinverse(A) || throw(joLooseLinearFunctionInplaceException("\\(jo,Vector) not supplied"))
    A.n == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end
function ldiv!(y::AbstractMatrix{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    hasinverse(A) || throw(joLooseLinearFunctionInplaceException("\\(jo,Vector) not supplied"))
    size(y,2) == size(x,2) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end

# A_ldiv_B!(...,jo,...)
function A_ldiv_B!(y::AbstractVector{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    hasinverse(A) || throw(joLooseLinearFunctionInplaceException("\\(jo,Vector) not supplied"))
    A.n == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end
function A_ldiv_B!(y::AbstractMatrix{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    hasinverse(A) || throw(joLooseLinearFunctionInplaceException("\\(jo,Vector) not supplied"))
    size(y,2) == size(x,2) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end

# At_ldiv_B!(...,jo,...)
function At_ldiv_B!(y::AbstractVector{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    hasinverse(A) || throw(joLooseLinearFunctionInplaceException("\\(jo,Vector) not supplied"))
    A.n == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    get(A.iop_T)(y,x)
    return y
end
function At_ldiv_B!(y::AbstractMatrix{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    hasinverse(A) || throw(joLooseLinearFunctionInplaceException("\\(jo,Vector) not supplied"))
    size(y,2) == size(x,2) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    get(A.iop_T)(y,x)
    return y
end

# Ac_ldiv_B!(...,jo,...)
function Ac_ldiv_B!(y::AbstractVector{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    hasinverse(A) || throw(joLooseLinearFunctionInplaceException("\\(jo,Vector) not supplied"))
    A.n == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    get(A.iop_A)(y,x)
    return y
end
function Ac_ldiv_B!(y::AbstractMatrix{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    hasinverse(A) || throw(joLooseLinearFunctionInplaceException("\\(jo,Vector) not supplied"))
    size(y,2) == size(x,2) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    get(A.iop_A)(y,x)
    return y
end

