############################################################
## joLooseMatrix - overloaded Base functions

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
conj{DDT,RDT}(A::joLooseMatrix{DDT,RDT}) =
    joLooseMatrix{DDT,RDT}("conj("*A.name*")",A.m,A.n,
        A.fop_C,
        A.fop_CT,
        A.fop_T,
        A.fop,
        A.iop_C,
        A.iop_CT,
        A.iop_T,
        A.iop
        )

# transpose(jo)
transpose{DDT,RDT}(A::joLooseMatrix{DDT,RDT}) =
    joLooseMatrix{RDT,DDT}(""*A.name*".'",A.n,A.m,
        A.fop_T,
        A.fop,
        A.fop_C,
        A.fop_CT,
        A.iop_T,
        A.iop,
        A.iop_C,
        A.iop_CT
        )

# ctranspose(jo)
ctranspose{DDT,RDT}(A::joLooseMatrix{DDT,RDT}) =
    joLooseMatrix{RDT,DDT}(""*A.name*"'",A.n,A.m,
        A.fop_CT,
        A.fop_C,
        A.fop,
        A.fop_T,
        A.iop_CT,
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
function *{ADDT,ARDT,mvDT<:Number}(A::joLooseMatrix{ADDT,ARDT},mv::AbstractMatrix{mvDT})
    A.n == size(mv,1) || throw(joLooseMatrixException("shape mismatch"))
    MV = A.fop(mv)
    return MV
end

# *(mvec,jo)

# *(jo,vec)
function *{ADDT,ARDT,vDT<:Number}(A::joLooseMatrix{ADDT,ARDT},v::AbstractVector{vDT})
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
function \{ADDT,ARDT,mvDT<:Number}(A::joLooseMatrix{ADDT,ARDT},mv::AbstractMatrix{mvDT})
    A.m == size(mv,1) || throw(joLooseMatrixException("shape mismatch"))
    if hasinverse(A)
        MV=get(A.iop)(mv)
    else
        throw(joLooseMatrixException("\(jo,Vector) not supplied"))
    end
    return MV
end

# \(mvec,jo)

# \(jo,vec)
function \{ADDT,ARDT,vDT<:Number}(A::joLooseMatrix{ADDT,ARDT},v::AbstractVector{vDT})
    A.m == size(v,1) || throw(joLooseMatrixException("shape mismatch"))
    if hasinverse(A)
        V=get(A.iop)(v)
    else
        throw(joLooseMatrixException("\(jo,Vector) not supplied"))
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
-{DDT,RDT}(A::joLooseMatrix{DDT,RDT}) =
    joLooseMatrix{DDT,RDT}("(-"*A.name*")",A.m,A.n,
        v1->-A.fop(v1),
        v2->-A.fop_T(v2),
        v3->-A.fop_CT(v3),
        v4->-A.fop_C(v4),
        v5->-get(A.iop)(v5),
        v6->-get(A.iop_T)(v6),
        v7->-get(A.iop_CT)(v7),
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
## overloaded Base.LinAlg functions

# A_mul_B!(...,jo,...)

# At_mul_B!(...,jo,...)

# Ac_mul_B!(...,jo,...)

# A_ldiv_B!(...,jo,...)

# At_ldiv_B!(...,jo,...)

# Ac_ldiv_B!(...,jo,...)

