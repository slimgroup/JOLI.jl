############################################################
# joMatrix #################################################
############################################################

export joMatrix, joMatrixException

############################################################
## type definition

"""
joMatrix type

# FIELDS
- name::String : given name
- m::Integer : # of rows
- n::Integer : # of columns
- fop::Function : forward matrix
- fop_T::Function : transpose matrix
- fop_CT::Function : conj transpose matrix
- fop_C::Function : conj matrix
- iop::Nullable{Function} : inverse for fop
- iop_T::Nullable{Function} : inverse for fop_T
- iop_CT::Nullable{Function} : inverse for fop_CT
- iop_C::Nullable{Function} : inverse for fop_C

"""
immutable joMatrix{EDT<:Number,DDT<:Number,RDT<:Number} <: joAbstractLinearOperator{EDT,DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function    # forward
    fop_T::Function  # transpose
    fop_CT::Function # conj transpose
    fop_C::Function  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_CT::Nullable{Function}
    iop_C::Nullable{Function}
end

type joMatrixException <: Exception
    msg :: String
end

############################################################
## outer constructors

"""
joMatrix outer constructor

    joMatrix(array::AbstractMatrix,DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT);name::String="joMatrix")

# Example
- joMatrix(rand(4,3)) # implicit domain and range
- joMatrix(rand(4,3),Float32) # implicit range
- joMatrix(rand(4,3),Float32,Float64)
- joMatrix(rand(4,3);name="my matrix") # adding name

"""
joMatrix{EDT}(array::AbstractMatrix{EDT},DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT);name::String="joMatrix") =
    joMatrix{EDT,DDT,RDT}(name,size(array,1),size(array,2),
        v1->array*v1,
        v2->array.'*v2,
        v3->array'*v3,
        v4->conj(array)*v4,
        v5->array\v5,
        v6->array.'\v6,
        v7->array'\v7,
        v8->conj(array)\v8
        )

############################################################
## overloaded Base functions

# conj(jo)
conj{EDT,DDT,RDT}(A::joMatrix{EDT,DDT,RDT}) =
    joMatrix{EDT,DDT,RDT}("conj("*A.name*")",A.m,A.n,
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
transpose{EDT,DDT,RDT}(A::joMatrix{EDT,DDT,RDT}) =
    joMatrix{EDT,RDT,DDT}(""*A.name*".'",A.n,A.m,
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
ctranspose{EDT,DDT,RDT}(A::joMatrix{EDT,DDT,RDT}) =
    joMatrix{EDT,RDT,DDT}(""*A.name*"'",A.n,A.m,
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
function *{AEDT,ADDT,ARDT,BEDT,BDDT,BRDT}(A::joMatrix{AEDT,ADDT,ARDT},B::joMatrix{BEDT,BDDT,BRDT}) # fix,DDT,RDT
    A.n == B.m || throw(joMatrixException("shape mismatch"))
    nEDT=promote_type(AEDT,BEDT)
    return joMatrix{nEDT,BDDT,ARDT}("("*A.name*"*"*B.name*")",A.m,B.n,
        v1->A.fop(B.fop(v1)),
        v2->B.fop_T(A.fop_T(v2)),
        v3->B.fop_CT(A.fop_CT(v3)),
        v4->A.fop_C(B.fop_C(v4)),
        @NF, @NF, @NF, @NF
        )
end

# *(jo,mvec)
function *{AEDT,ADDT,ARDT,mvDT<:Number}(A::joMatrix{AEDT,ADDT,ARDT},mv::AbstractMatrix{mvDT}) #fix,DDT,RDT
    A.n == size(mv,1) || throw(joMatrixException("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end

# *(jo,vec)
function *{AEDT,ADDT,ARDT,vDT<:Number}(A::joMatrix{AEDT,ADDT,ARDT},v::AbstractVector{vDT}) # fix,DDT,RDT
    A.n == size(v,1) || throw(joMatrixException("shape mismatch"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end

# *(num,jo)
function *{aDT<:Number,AEDT,ADDT,ARDT}(a::aDT,A::joMatrix{AEDT,ADDT,ARDT}) # fix,DDT,RDT
    nEDT=promote_type(aDT,AEDT)
    return joMatrix{nEDT,ADDT,ARDT}("(N*"*A.name*")",A.m,A.n,
        v1->a*A.fop(v1),
        v2->a*A.fop_T(v2),
        v3->conj(a)*A.fop_CT(v3),
        v4->conj(a)*A.fop_C(v4),
        @NF, @NF, @NF, @NF
        )
end

############################################################
## overloaded Base \(...jo...)

# \(jo,mvec)
#function \{AEDT,ADDT,ARDT,mvDT<:Number}(A::joMatrix{AEDT,ADDT,ARDT},mv::AbstractMatrix{mvDT}) # fix,DDT,RDT
#    A.m == size(mv,1) || throw(joMatrixException("shape mismatch"))
#    return !isnull(A.iop) ? get(A.iop)(mv) : throw(joMatrixException("inverse not defined"))
#end

# \(jo,vec)
function \{AEDT,ADDT,ARDT,vDT<:Number}(A::joMatrix{AEDT,ADDT,ARDT},v::AbstractVector{vDT}) # fix,DDT,RDT
    isinvertible(A) || throw(joMatrixException("\(jo,Vector) not supplied"))
    A.m == size(v,1) || throw(joMatrixException("shape mismatch"))
    return get(A.iop)(v)
end

############################################################
## overloaded Base +(...jo...)

# +(jo,jo)
function +{AEDT,ADDT,ARDT,BEDT,BDDT,BRDT}(A::joMatrix{AEDT,ADDT,ARDT},B::joMatrix{BEDT,BDDT,BRDT}) # fix,DDT,RDT
    size(A) == size(B) || throw(joMatrixException("shape mismatch"))
    nEDT=promote_type(AEDT,BEDT)
    return joMatrix{nEDT,ADDT,ARDT}("("*A.name*"+"*B.name*")",A.m,B.n,
        v1->A.fop(v1)+B.fop(v1),
        v2->A.fop_T(v2)+B.fop_T(v2),
        v3->A.fop_CT(v3)+B.fop_CT(v3),
        v4->A.fop_C(v4)+B.fop_C(v4),
        @NF, @NF, @NF, @NF
        )
end

# +(jo,num)
function +{AEDT,ADDT,ARDT,bDT<:Number}(A::joMatrix{AEDT,ADDT,ARDT},b::bDT) # fix,DDT,RDT
    nEDT=promote_type(AEDT,bDT)
    return joMatrix{nEDT,ADDT,ARDT}("("*A.name*"+N)",A.m,A.n,
        v1->A.fop(v1)+b*joOnes(A.m,A.n,nEDT,ADDT)*v1,
        v2->A.fop_T(v2)+b*joOnes(A.n,A.m,nEDT,ARDT)*v2,
        v3->A.fop_CT(v3)+conj(b)*joOnes(A.n,A.m,nEDT,ARDT)*v3,
        v4->A.fop_C(v4)+conj(b)*joOnes(A.m,A.n,nEDT,ADDT)*v4,
        @NF, @NF, @NF, @NF
        )
end

############################################################
## overloaded Base -(...jo...)

# -(jo)
-{EDT,DDT,RDT}(A::joMatrix{EDT,DDT,RDT}) =
    joMatrix{EDT,DDT,RDT}("(-"*A.name*")",A.m,A.n,
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
## extra methods

# double(jo)
double{EDT,DDT,RDT}(A::joMatrix{EDT,DDT,RDT}) = A*speye(DDT,A.n)

