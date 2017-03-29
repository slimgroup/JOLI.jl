############################################################
## joMatrix - overloaded Base functions

# conj(jo)
conj{DDT,RDT}(A::joMatrix{DDT,RDT}) =
    joMatrix{DDT,RDT}("conj("*A.name*")",A.m,A.n,
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
transpose{DDT,RDT}(A::joMatrix{DDT,RDT}) =
    joMatrix{RDT,DDT}(""*A.name*".'",A.n,A.m,
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
ctranspose{DDT,RDT}(A::joMatrix{DDT,RDT}) =
    joMatrix{RDT,DDT}(""*A.name*"'",A.n,A.m,
        A.fop_CT,
        A.fop_C,
        A.fop,
        A.fop_T,
        A.iop_CT,
        A.iop_C,
        A.iop,
        A.iop_T
        )

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
function *{ARDT,BDDT,CDT}(A::joMatrix{CDT,ARDT},B::joMatrix{BDDT,CDT})
    A.n == B.m || throw(joMatrixException("shape mismatch"))
    return joMatrix{BDDT,ARDT}("("*A.name*"*"*B.name*")",A.m,B.n,
        v1->A.fop(B.fop(v1)),
        v2->B.fop_T(A.fop_T(v2)),
        v3->B.fop_CT(A.fop_CT(v3)),
        v4->A.fop_C(B.fop_C(v4)),
        @joNF, @joNF, @joNF, @joNF
        )
end

# *(jo,mvec)
function *{ADDT,ARDT,mvDT<:Number}(A::joMatrix{ADDT,ARDT},mv::AbstractMatrix{mvDT})
    A.n == size(mv,1) || throw(joMatrixException("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end

# *(jo,vec)
function *{ADDT,ARDT,vDT<:Number}(A::joMatrix{ADDT,ARDT},v::AbstractVector{vDT})
    A.n == size(v,1) || throw(joMatrixException("shape mismatch"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end

# *(num,jo)
function *{ADDT,ARDT}(a::Number,A::joMatrix{ADDT,ARDT})
    return joMatrix{ADDT,ARDT}("(N*"*A.name*")",A.m,A.n,
        v1->jo_convert(ARDT,a*A.fop(v1),false),
        v2->jo_convert(ADDT,a*A.fop_T(v2),false),
        v3->jo_convert(ADDT,conj(a)*A.fop_CT(v3),false),
        v4->jo_convert(ARDT,conj(a)*A.fop_C(v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
end
function *{ADDT,ARDT}(a::joNumber{ADDT,ARDT},A::joMatrix{ADDT,ARDT})
    return joMatrix{ADDT,ARDT}("(N*"*A.name*")",A.m,A.n,
        v1->jo_convert(ARDT,a.rdt*A.fop(v1),false),
        v2->jo_convert(ADDT,a.ddt*A.fop_T(v2),false),
        v3->jo_convert(ADDT,conj(a.ddt)*A.fop_CT(v3),false),
        v4->jo_convert(ARDT,conj(a.rdt)*A.fop_C(v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
end

# *(jo,num)
*{ADDT,ARDT}(A::joMatrix{ADDT,ARDT},a::Number) = a*A
*{ADDT,ARDT}(A::joMatrix{ADDT,ARDT},a::joNumber{ADDT,ARDT}) = a*A

############################################################
## overloaded Base \(...jo...)

# \(jo,mvec)
#function \{ADDT,ARDT,mvDT<:Number}(A::joMatrix{ADDT,ARDT},mv::AbstractMatrix{mvDT})
#    A.m == size(mv,1) || throw(joMatrixException("shape mismatch"))
#    return !isnull(A.iop) ? get(A.iop)(mv) : throw(joMatrixException("inverse not defined"))
#end

# \(jo,vec)
function \{ADDT,ARDT,vDT<:Number}(A::joMatrix{ADDT,ARDT},v::AbstractVector{vDT})
    isinvertible(A) || throw(joMatrixException("\(jo,Vector) not supplied"))
    A.m == size(v,1) || throw(joMatrixException("shape mismatch"))
    V=get(A.iop)(v)
    return V
end

############################################################
## overloaded Base +(...jo...)

# +(jo,jo)
function +{DDT,RDT}(A::joMatrix{DDT,RDT},B::joMatrix{DDT,RDT})
    size(A) == size(B) || throw(joMatrixException("shape mismatch"))
    return joMatrix{DDT,RDT}("("*A.name*"+"*B.name*")",A.m,B.n,
        v1->A.fop(v1)+B.fop(v1),
        v2->A.fop_T(v2)+B.fop_T(v2),
        v3->A.fop_CT(v3)+B.fop_CT(v3),
        v4->A.fop_C(v4)+B.fop_C(v4),
        @joNF, @joNF, @joNF, @joNF
        )
end

# +(jo,num)
function +{ADDT,ARDT}(A::joMatrix{ADDT,ARDT},b::Number)
    return joMatrix{ADDT,ARDT}("("*A.name*"+N)",A.m,A.n,
        v1->A.fop(v1)+joConstants(A.m,A.n,b;DDT=ADDT,RDT=ARDT)*v1,
        v2->A.fop_T(v2)+joConstants(A.n,A.m,b;DDT=ARDT,RDT=ADDT)*v2,
        v3->A.fop_CT(v3)+joConstants(A.n,A.m,conj(b);DDT=ARDT,RDT=ADDT)*v3,
        v4->A.fop_C(v4)+joConstants(A.m,A.n,conj(b);DDT=ADDT,RDT=ARDT)*v4,
        @joNF, @joNF, @joNF, @joNF
        )
end
function +{ADDT,ARDT}(A::joMatrix{ADDT,ARDT},b::joNumber{ADDT,ARDT})
    return joMatrix{ADDT,ARDT}("("*A.name*"+N)",A.m,A.n,
        v1->A.fop(v1)+joConstants(A.m,A.n,b.rdt;DDT=ADDT,RDT=ARDT)*v1,
        v2->A.fop_T(v2)+joConstants(A.n,A.m,b.ddt;DDT=ARDT,RDT=ADDT)*v2,
        v3->A.fop_CT(v3)+joConstants(A.n,A.m,conj(b.ddt);DDT=ARDT,RDT=ADDT)*v3,
        v4->A.fop_C(v4)+joConstants(A.m,A.n,conj(b.rdt);DDT=ADDT,RDT=ARDT)*v4,
        @joNF, @joNF, @joNF, @joNF
        )
end

# +(num,jo)
+{ADDT,ARDT}(b::Number,A::joMatrix{ADDT,ARDT}) = A+b
+{ADDT,ARDT}(b::joNumber{ADDT,ARDT},A::joMatrix{ADDT,ARDT}) = A+b

############################################################
## overloaded Base -(...jo...)

# -(jo)
-{DDT,RDT}(A::joMatrix{DDT,RDT}) =
    joMatrix{DDT,RDT}("(-"*A.name*")",A.m,A.n,
        v1->-A.fop(v1),
        v2->-A.fop_T(v2),
        v3->-A.fop_CT(v3),
        v4->-A.fop_C(v4),
        v5->-get(A.iop)(v5),
        v6->-get(A.iop_T)(v6),
        v7->-get(A.iop_CT)(v7),
        v8->-get(A.iop_C)(v8)
        )

############################################################
## overloaded Base .*(...jo...)

############################################################
## overloaded Base .\(...jo...)

############################################################
## overloaded Base .+(...jo...)

############################################################
## overloaded Base .-(...jo...)

############################################################
## overloaded Base hcat(...jo...)

############################################################
## overloaded Base vcat(...jo...)

############################################################
## overloaded Base hvcat(...jo...)

