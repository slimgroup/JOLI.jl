############################################################
## joMatrix - overloaded Base functions

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
conj(A::joMatrix{DDT,RDT}) where {DDT,RDT} =
    joMatrix{DDT,RDT}("conj("*A.name*")",A.m,A.n,
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
transpose(A::joMatrix{DDT,RDT}) where {DDT,RDT} =
    joMatrix{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
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
adjoint(A::joMatrix{DDT,RDT}) where {DDT,RDT} =
    joMatrix{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
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
function *(A::joMatrix{ADDT,ARDT},mv::AbstractMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joMatrixException("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end

# *(mvec,jo)

# *(jo,vec)
function *(A::joMatrix{ADDT,ARDT},v::AbstractVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joMatrixException("shape mismatch"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end

# *(vec,jo)

# *(num,jo)

# *(jo,num)

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)

# \(jo,mvec)
function \(A::joMatrix{ADDT,ARDT},mv::AbstractMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.m == size(mv,1) || throw(joMatrixException("shape mismatch"))
    jo_check_type_match(ARDT,mvDT,join(["RDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    if hasinverse(A)
        MV=get(A.iop)(mv)
        jo_check_type_match(ADDT,eltype(MV),join(["DDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    else
        throw(joMatrixException("\\(jo,Vector) not supplied"))
    end
    return MV
end

# \(mvec,jo)

# \(jo,vec)
function \(A::joMatrix{ADDT,ARDT},v::AbstractVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.m == size(v,1) || throw(joMatrixException("shape mismatch"))
    jo_check_type_match(ARDT,vDT,join(["RDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    if hasinverse(A)
        V=get(A.iop)(v)
        jo_check_type_match(ADDT,eltype(V),join(["DDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    else
        throw(joMatrixException("\\(jo,Vector) not supplied"))
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
-(A::joMatrix{DDT,RDT}) where {DDT,RDT} =
    joMatrix{DDT,RDT}("(-"*A.name*")",A.m,A.n,
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
## overloaded Base.LinAlg functions

# A_mul_B!(...,jo,...)

# At_mul_B!(...,jo,...)

# Ac_mul_B!(...,jo,...)

# A_ldiv_B!(...,jo,...)

# At_ldiv_B!(...,jo,...)

# Ac_ldiv_B!(...,jo,...)

