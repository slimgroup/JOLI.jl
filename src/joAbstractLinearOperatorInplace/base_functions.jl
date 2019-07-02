############################################################
## joAbstractLinearOperatorInPlace - overloaded Base functions

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
conj(A::joMatrixInplace{DDT,RDT}) where {DDT,RDT} =
    joMatrixInplace{DDT,RDT}("conj("*A.name*")",A.m,A.n,
        A.fop_C, A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop
        )
conj(A::joLooseMatrixInplace{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrixInplace{DDT,RDT}("conj("*A.name*")",A.m,A.n,
        A.fop_C, A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop
        )
conj(A::joLinearFunctionInplace{DDT,RDT}) where {DDT,RDT} =
    joLinearFunctionInplace{DDT,RDT}("conj("*A.name*")",A.m,A.n,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop
        )
conj(A::joLooseLinearFunctionInplace{DDT,RDT}) where {DDT,RDT} =
    joLooseLinearFunctionInplace{DDT,RDT}("conj("*A.name*")",A.m,A.n,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop
        )

# transpose(jo)
transpose(A::joMatrixInplace{DDT,RDT}) where {DDT,RDT} =
    joMatrixInplace{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
        A.fop_T, A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A
        )
transpose(A::joLooseMatrixInplace{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrixInplace{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
        A.fop_T, A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A
        )
transpose(A::joLinearFunctionInplace{DDT,RDT}) where {DDT,RDT} =
    joLinearFunctionInplace{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A
        )
transpose(A::joLooseLinearFunctionInplace{DDT,RDT}) where {DDT,RDT} =
    joLooseLinearFunctionInplace{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A
        )

# adjoint(jo)
adjoint(A::joMatrixInplace{DDT,RDT}) where {DDT,RDT} =
    joMatrixInplace{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
        A.fop_A, A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T
        )
adjoint(A::joLooseMatrixInplace{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrixInplace{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
        A.fop_A, A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T
        )
adjoint(A::joLinearFunctionInplace{DDT,RDT}) where {DDT,RDT} =
    joLinearFunctionInplace{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T
        )
adjoint(A::joLooseLinearFunctionInplace{DDT,RDT}) where {DDT,RDT} =
    joLooseLinearFunctionInplace{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T
        )

# isreal(jo)

# issymmetric(jo)

# ishermitian(jo)

# getindex(jo,...)

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

# .*(num,jo)

# .*(jo,num)

############################################################
## overloaded Base .\(...jo...)

############################################################
## overloaded Base .+(...jo...)

# .+(jo,num)

# .+(num,jo)

############################################################
## overloaded Base .-(...jo...)

# .-(jo,num)

# .-(num,jo)

############################################################
## overloaded Base block methods

# hcat(...jo...)

# vcat(...jo...)

# hvcat(...jo...)

############################################################
## overloaded LinearAlgebra functions

# mul!(...,jo,...)
function mul!(y::LocalVector{RDT},A::joMatrixInplace{DDT,RDT},x::LocalVector{DDT}) where {DDT,RDT}
    A.m == size(y,1) || throw(joMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joMatrixInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end
function mul!(y::LocalMatrix{RDT},A::joMatrixInplace{DDT,RDT},x::LocalMatrix{DDT}) where {DDT,RDT}
    size(y,2) == size(x,2) || throw(joMatrixInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joMatrixInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joMatrixInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end
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
function mul!(y::LocalVector{RDT},A::joLinearFunctionInplace{DDT,RDT},x::LocalVector{DDT}) where {DDT,RDT}
    A.m == size(y,1) || throw(joLinearFunctionInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLinearFunctionInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end
function mul!(y::LocalMatrix{RDT},A::joLinearFunctionInplace{DDT,RDT},x::LocalMatrix{DDT}) where {DDT,RDT}
    size(y,2) == size(x,2) || throw(joLinearFunctionInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joLinearFunctionInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLinearFunctionInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end
function mul!(y::LocalVector{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::LocalVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    A.m == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end
function mul!(y::LocalMatrix{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::LocalMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    size(y,2) == size(x,2) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.fop(y,x)
    return y
end

# ldiv!(...,jo,...)
function ldiv!(y::LocalVector{DDT},A::joMatrixInplace{DDT,RDT},x::LocalVector{DDT}) where {DDT,RDT}
    A.n == size(y,1) || throw(joMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joMatrixInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end
function ldiv!(y::LocalMatrix{DDT},A::joMatrixInplace{DDT,RDT},x::LocalMatrix{DDT}) where {DDT,RDT}
    size(y,2) == size(x,2) || throw(joMatrixInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joMatrixInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joMatrixInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end
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
function ldiv!(y::LocalVector{DDT},A::joLinearFunctionInplace{DDT,RDT},x::LocalVector{DDT}) where {DDT,RDT}
    hasinverse(A) || throw(joLinearFunctionInplaceException("\\(jo,Vector) not supplied"))
    A.n == size(y,1) || throw(joLinearFunctionInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLinearFunctionInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end
function ldiv!(y::LocalMatrix{DDT},A::joLinearFunctionInplace{DDT,RDT},x::LocalMatrix{DDT}) where {DDT,RDT}
    hasinverse(A) || throw(joLinearFunctionInplaceException("\\(jo,Vector) not supplied"))
    size(y,2) == size(x,2) || throw(joLinearFunctionInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joLinearFunctionInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLinearFunctionInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end
function ldiv!(y::LocalVector{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::LocalVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    hasinverse(A) || throw(joLooseLinearFunctionInplaceException("\\(jo,Vector) not supplied"))
    A.n == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end
function ldiv!(y::LocalMatrix{YDT},A::joLooseLinearFunctionInplace{DDT,RDT},x::LocalMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number}
    hasinverse(A) || throw(joLooseLinearFunctionInplaceException("\\(jo,Vector) not supplied"))
    size(y,2) == size(x,2) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.n == size(y,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    A.m == size(x,1) || throw(joLooseLinearFunctionInplaceException("shape mismatch"))
    get(A.iop)(y,x)
    return y
end

