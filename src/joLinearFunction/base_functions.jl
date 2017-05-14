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

# *(jo,mvec)
function *{ADDT,ARDT,mvDT<:Number}(A::joLinearFunction{ADDT,ARDT},mv::AbstractMatrix{mvDT})
    A.n == size(mv,1) || throw(joLinearFunction("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV=zeros(ARDT,A.m,size(mv,2))
    for i=1:size(mv,2)
        V=A.fop(mv[:,i])
        i==1 && jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(V)]," / "))
        MV[:,i]=V
    end
    return MV
end

# *(jo,vec)
function *{ADDT,ARDT,vDT<:Number}(A::joLinearFunction{ADDT,ARDT},v::AbstractVector{vDT})
    A.n == size(v,1) || throw(joLinearFunctionException("shape mismatch"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end

# *(num,jo)

# *(jo,num)

############################################################
## overloaded Base \(...jo...)

# \(jo,mvec)
function \{ADDT,ARDT,mvDT<:Number}(A::joLinearFunction{ADDT,ARDT},mv::AbstractMatrix{mvDT})
    isinvertible(A) || throw(joLinearFunctionException("\(jo,MultiVector) not supplied"))
    A.m == size(mv,1) || throw(joLinearFunctionException("shape mismatch"))
    MV=zeros(ADDT,A.n,size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=get(A.iop)(mv[:,i])
    end
    return MV
end

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

# +(jo,num)

# +(num,jo)

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

############################################################
## overloaded Base hvcat(...jo...)

