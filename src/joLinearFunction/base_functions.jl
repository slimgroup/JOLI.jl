############################################################
## joLinearFunction - overloaded Base functions

# conj(jo)
conj{DDT,RDT}(A::joLinearFunction{DDT,RDT}) =
    joLinearFunction{DDT,RDT}("conj("*A.name*")",A.m,A.n,
        get(A.fop_C),
        A.fop_CT,
        A.fop_T,
        A.fop,
        A.iop_C,
        A.iop_CT,
        A.iop_T,
        A.iop
        )

# transpose(jo)
transpose{DDT,RDT}(A::joLinearFunction{DDT,RDT}) =
    joLinearFunction{RDT,DDT}(""*A.name*".'",A.n,A.m,
        get(A.fop_T),
        A.fop,
        A.fop_C,
        A.fop_CT,
        A.iop_T,
        A.iop,
        A.iop_C,
        A.iop_CT
        )

# ctranspose(jo)
ctranspose{DDT,RDT}(A::joLinearFunction{DDT,RDT}) =
    joLinearFunction{RDT,DDT}(""*A.name*"'",A.n,A.m,
        get(A.fop_CT),
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
function *{ARDT,BDDT,CDT}(A::joLinearFunction{CDT,ARDT},B::joLinearFunction{BDDT,CDT})
    A.n == B.m || throw(joLinearFunctionException("shape mismatch"))
    return joLinearFunction{BDDT,ARDT}("("*A.name*"*"*B.name*")",A.m,B.n,
        v1->A.fop(B.fop(v1)),
        v2->get(B.fop_T)(get(A.fop_T)(v2)),
        v3->get(B.fop_CT)(get(A.fop_CT)(v3)),
        v4->get(A.fop_C)(get(B.fop_C)(v4)),
        @joNF, @joNF, @joNF, @joNF
        )
end

# *(jo,mvec)

# *(jo,vec)
function *{ADDT,ARDT,vDT<:Number}(A::joLinearFunction{ADDT,ARDT},v::AbstractVector{vDT})
    A.n == size(v,1) || throw(joLinearFunctionException("shape mismatch"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end

# *(num,jo)
function *{ADDT,ARDT}(a::Number,A::joLinearFunction{ADDT,ARDT})
    return joLinearFunction{ADDT,ARDT}("(N*"*A.name*")",A.m,A.n,
        v1->jo_convert(ARDT,a*A.fop(v1),false),
        v2->jo_convert(ADDT,a*A.fop_T(v2),false),
        v3->jo_convert(ADDT,conj(a)*A.fop_CT(v3),false),
        v4->jo_convert(ARDT,conj(a)*A.fop_C(v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
end

# *(jo,num)
*{ADDT,ARDT}(A::joLinearFunction{ADDT,ARDT},a::Number) = a*A

############################################################
## overloaded Base \(...jo...)

# \(jo,mvec)

# \(jo,vec)
function \{ADDT,ARDT,vDT<:Number}(A::joLinearFunction{ADDT,ARDT},v::AbstractVector{vDT})
    isinvertible(A) || throw(joLinearFunctionException("\(jo,Vector) not supplied"))
    A.m == size(v,1) || throw(joLinearFunctionException("shape mismatch"))
    V=get(A.iop)(v)
    return V
end

############################################################
## overloaded Base +(...jo...)

# +(jo,jo)
function +{DDT,RDT}(A::joLinearFunction{DDT,RDT},B::joLinearFunction{DDT,RDT})
    size(A) == size(B) || throw(joLinearFunctionException("shape mismatch"))
    return joLinearFunction{DDT,RDT}("("*A.name*"+"*B.name*")",A.m,B.n,
        v1->A.fop(v1)+B.fop(v1),
        v2->get(A.fop_T)(v2)+get(B.fop_T)(v2),
        v3->get(A.fop_CT)(v3)+get(B.fop_CT)(v3),
        v4->get(A.fop_C)(v4)+get(B.fop_C)(v4),
        @joNF, @joNF, @joNF, @joNF
        )
end

# +(jo,num)
function +{ADDT,ARDT}(A::joLinearFunction{ADDT,ARDT},b::Number)
    return joLinearFunction{ADDT,ARDT}("("*A.name*"+N)",A.m,A.n,
        v1->A.fop(v1)+joConstants(A.m,A.n,b;DDT=ADDT,RDT=ARDT)*v1,
        v2->get(A.fop_T)(v2)+joConstants(A.n,A.m,b;DDT=ARDT,RDT=ADDT)*v2,
        v3->get(A.fop_CT)(v3)+joConstants(A.n,A.m,conj(b);DDT=ARDT,RDT=ADDT)*v3,
        v4->get(A.fop_C)(v4)+joConstants(A.m,A.n,conj(b);DDT=ADDT,RDT=ARDT)*v4,
        @joNF, @joNF, @joNF, @joNF
        )
end

# +(num,jo)
+{ADDT,ARDT}(b::Number,A::joLinearFunction{ADDT,ARDT}) = A+b

############################################################
## overloaded Base -(...jo...)

# -(jo)
-{DDT,RDT}(A::joLinearFunction{DDT,RDT}) =
    joLinearFunction{DDT,RDT}("(-"*A.name*")",A.m,A.n,
        v1->-A.fop(v1),
        v2->-get(A.fop_T)(v2),
        v3->-get(A.fop_CT)(v3),
        v4->-get(A.fop_C)(v4),
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

