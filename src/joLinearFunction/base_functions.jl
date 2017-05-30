############################################################
## joLinearFunction - overloaded Base functions
# un-implemented methods are defined in joLinearOperator/base_functions.jl

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
conj{DDT,RDT}(A::joLinearFunction{DDT,RDT}) =
    joLinearFunction{DDT,RDT}("conj("*A.name*")",A.m,A.n,
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
transpose{DDT,RDT}(A::joLinearFunction{DDT,RDT}) =
    joLinearFunction{RDT,DDT}(""*A.name*".'",A.n,A.m,
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
ctranspose{DDT,RDT}(A::joLinearFunction{DDT,RDT}) =
    joLinearFunction{RDT,DDT}(""*A.name*"'",A.n,A.m,
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
function *{ADDT,ARDT,mvDT<:Number}(A::joLinearFunction{ADDT,ARDT},mv::AbstractMatrix{mvDT})
    A.n == size(mv,1) || throw(joLinearFunction("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    if A.fMVok
        MV=A.fop(mv)
        jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    else
        MV=zeros(ARDT,A.m,size(mv,2))
        for i=1:size(mv,2)
            V=A.fop(mv[:,i])
            i==1 && jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(V)]," / "))
            MV[:,i]=V
        end
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
    if A.iMVok
        MV = get(A.iop)(mv)
    else
        MV=zeros(ADDT,A.n,size(mv,2))
        for i=1:size(mv,2)
            MV[:,i]=get(A.iop)(mv[:,i])
        end
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

# \(jo,num)

############################################################
## overloaded Base +(...jo...)

# +(jo)

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
        A.fMVok,
        v5->-get(A.iop)(v5),
        v6->-get(A.iop_T)(v6),
        v7->-get(A.iop_CT)(v7),
        v8->-get(A.iop_C)(v8),
        A.iMVok
        )

# -(jo,jo)

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

