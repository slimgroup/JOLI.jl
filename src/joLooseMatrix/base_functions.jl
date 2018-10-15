############################################################
## joLooseMatrix - overloaded Base functions

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
conj(A::joLooseMatrix{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrix{DDT,RDT}("conj("*A.name*")",A.m,A.n,
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
transpose(A::joLooseMatrix{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrix{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
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
adjoint(A::joLooseMatrix{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrix{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
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
function *(A::joLooseMatrix{ADDT,ARDT},mv::AbstractMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joLooseMatrixException("shape mismatch"))
    MV = A.fop(mv)
    return MV
end

# *(mvec,jo)

# *(jo,vec)
function *(A::joLooseMatrix{ADDT,ARDT},v::AbstractVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joLooseMatrixException("shape mismatch"))
    V=A.fop(v)
    return V
end

# *(vec,jo)

# *(num,jo)

# *(jo,num)

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)

# \(jo,mvec)
function \(A::joLooseMatrix{ADDT,ARDT},mv::AbstractMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.m == size(mv,1) || throw(joLooseMatrixException("shape mismatch"))
    if hasinverse(A)
        MV=get(A.iop)(mv)
    else
        throw(joLooseMatrixException("\\(jo,Vector) not supplied"))
    end
    return MV
end

# \(mvec,jo)

# \(jo,vec)
function \(A::joLooseMatrix{ADDT,ARDT},v::AbstractVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.m == size(v,1) || throw(joLooseMatrixException("shape mismatch"))
    if hasinverse(A)
        V=get(A.iop)(v)
    else
        throw(joLooseMatrixException("\\(jo,Vector) not supplied"))
    end
    return V
end

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
-(A::joLooseMatrix{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrix{DDT,RDT}("(-"*A.name*")",A.m,A.n,
        v1->-A.fop(v1),
        v2->-A.fop_T(v2),
        v3->-A.fop_A(v3),
        v4->-A.fop_C(v4),
        v5->-get(A.iop)(v5),
        v6->-get(A.iop_T)(v6),
        v7->-get(A.iop_A)(v7),
        v8->-get(A.iop_C)(v8)
        )

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
mul!(y::AbstractVector{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:] = A * x
mul!(y::AbstractMatrix{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:,:] = A * x

# A_mul_B!(...,jo,...)
A_mul_B!(y::AbstractVector{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:] = A * x
A_mul_B!(y::AbstractMatrix{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:,:] = A * x

# At_mul_B!(...,jo,...)
At_mul_B!(y::AbstractVector{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:] = transpose(A) * x
At_mul_B!(y::AbstractMatrix{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:,:] = transpose(A) * x

# Ac_mul_B!(...,jo,...)
Ac_mul_B!(y::AbstractVector{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:] = adjoint(A) * x
Ac_mul_B!(y::AbstractMatrix{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:,:] = adjoint(A) * x

# ldiv!(...,jo,...)
ldiv!(y::AbstractVector{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:] = A \ x
ldiv!(y::AbstractMatrix{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:,:] = A \ x

# A_ldiv_B!(...,jo,...)
A_ldiv_B!(y::AbstractVector{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:] = A \ x
A_ldiv_B!(y::AbstractMatrix{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:,:] = A \ x

# At_ldiv_B!(...,jo,...)
At_ldiv_B!(y::AbstractVector{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:] = transpose(A) \ x
At_ldiv_B!(y::AbstractMatrix{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:,:] = transpose(A) \ x

# Ac_ldiv_B!(...,jo,...)
Ac_ldiv_B!(y::AbstractVector{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:] = adjoint(A) \ x
Ac_ldiv_B!(y::AbstractMatrix{YDT},A::joLooseMatrix{DDT,RDT},x::AbstractMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:,:] = adjoint(A) \ x

