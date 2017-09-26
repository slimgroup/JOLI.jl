############################################################
## joLooseLinearFunctionInplace - overloaded Base functions

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

# vecnorm(jo)

# real(jo)

# imag(jo)

# conj(jo)
conj{DDT,RDT}(A::joLooseLinearFunctionInplace{DDT,RDT}) =
    joLooseLinearFunctionInplace{DDT,RDT}("conj("*A.name*")",A.m,A.n,
        get(A.fop_C),
        A.fop_CT,
        A.fop_T,
        A.fop,
        A.fMVok,
        A.iop_C,
        A.iop_CT,
        A.iop_T,
        A.iop,
        A.iMVok
        )

# transpose(jo)
transpose{DDT,RDT}(A::joLooseLinearFunctionInplace{DDT,RDT}) =
    joLooseLinearFunctionInplace{RDT,DDT}(""*A.name*".'",A.n,A.m,
        get(A.fop_T),
        A.fop,
        A.fop_C,
        A.fop_CT,
        A.fMVok,
        A.iop_T,
        A.iop,
        A.iop_C,
        A.iop_CT,
        A.iMVok
        )

# ctranspose(jo)
ctranspose{DDT,RDT}(A::joLooseLinearFunctionInplace{DDT,RDT}) =
    joLooseLinearFunctionInplace{RDT,DDT}(""*A.name*"'",A.n,A.m,
        get(A.fop_CT),
        A.fop_C,
        A.fop,
        A.fop_T,
        A.fMVok,
        A.iop_CT,
        A.iop_C,
        A.iop,
        A.iop_T,
        A.iMVok
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
## overloaded Base.LinAlg functions

# A_mul_B!(...,jo,...)
A_mul_B!{DDT,RDT}(y::AbstractVector{Number},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractVector{Number}) = A.fop(y,x)
A_mul_B!{DDT,RDT}(y::AbstractMatrix{Number},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractMatrix{Number}) = A.fop(y,x)

# At_mul_B!(...,jo,...)
At_mul_B!{DDT,RDT}(y::AbstractVector{Number},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractVector{Number}) = A.fop_T(y,x)
At_mul_B!{DDT,RDT}(y::AbstractMatrix{Number},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractMatrix{Number}) = A.fop_T(y,x)

# Ac_mul_B!(...,jo,...)
Ac_mul_B!{DDT,RDT}(y::AbstractVector{Number},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractVector{Number}) = A.fop_CT(y,x)
Ac_mul_B!{DDT,RDT}(y::AbstractMatrix{Number},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractMatrix{Number}) = A.fop_CT(y,x)

# A_ldiv_B!(...,jo,...)
A_ldiv_B!{DDT,RDT}(y::AbstractVector{Number},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractVector{Number}) = A.iop(y,x)
A_ldiv_B!{DDT,RDT}(y::AbstractMatrix{Number},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractMatrix{Number}) = A.iop(y,x)

# At_ldiv_B!(...,jo,...)
At_ldiv_B!{DDT,RDT}(y::AbstractVector{Number},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractVector{Number}) = A.iop_T(y,x)
At_ldiv_B!{DDT,RDT}(y::AbstractMatrix{Number},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractMatrix{Number}) = A.iop_T(y,x)

# Ac_ldiv_B!(...,jo,...)
Ac_ldiv_B!{DDT,RDT}(y::AbstractVector{Number},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractVector{Number}) = A.iop_CT(y,x)
Ac_ldiv_B!{DDT,RDT}(y::AbstractMatrix{Number},A::joLooseLinearFunctionInplace{DDT,RDT},x::AbstractMatrix{Number}) = A.iop_CT(y,x)

