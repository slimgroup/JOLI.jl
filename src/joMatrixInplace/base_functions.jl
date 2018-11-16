############################################################
## joMatrixInplace - overloaded Base functions

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
transpose(A::joMatrixInplace{DDT,RDT}) where {DDT,RDT} =
    joMatrixInplace{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
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
adjoint(A::joMatrixInplace{DDT,RDT}) where {DDT,RDT} =
    joMatrixInplace{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
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

