############################################################
# joMatrix #################################################
############################################################

export joMatrix, joMatrixException

############################################################
## type definition

immutable joMatrix{T} <: joAbstractLinearOperator{T}
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

joMatrix{T}(array::AbstractMatrix{T},name::String="joMatrix") =
    joMatrix{T}(name,size(array,1),size(array,2),
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
conj{T}(A::joMatrix{T}) =
    joMatrix{T}("conj("*A.name*")",A.m,A.n,
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
transpose{T}(A::joMatrix{T}) =
    joMatrix{T}(""*A.name*".'",A.n,A.m,
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
ctranspose{T}(A::joMatrix{T}) =
    joMatrix{T}(""*A.name*"'",A.n,A.m,
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
function *(A::joMatrix,B::joMatrix)
    A.n == B.m || throw(joMatrixException("shape mismatch"))
    S=promote_type(eltype(A),eltype(B))
    return joMatrix{S}("("*A.name*"*"*B.name*")",A.m,B.n,
        v1->A.fop(B.fop(v1)),
        v2->B.fop_T(A.fop_T(v2)),
        v3->B.fop_CT(A.fop_CT(v3)),
        v4->A.fop_C(B.fop_C(v4)),
        @NF, @NF, @NF, @NF
        )
end

# *(jo,mvec)
function *(A::joMatrix,mv::AbstractMatrix)
    A.n == size(mv,1) || throw(joMatrixException("shape mismatch"))
    return A.fop(mv)
end

# *(jo,vec)
function *(A::joMatrix,v::AbstractVector)
    A.n == size(v,1) || throw(joMatrixException("shape mismatch"))
    return A.fop(v)
end

# *(num,jo)
function *(a::Number,A::joMatrix)
    S=promote_type(eltype(a),eltype(A))
    return joMatrix{S}("(N*"*A.name*")",A.m,A.n,
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
#function \(A::joMatrix,mv::AbstractMatrix)
#    A.m == size(mv,1) || throw(joMatrixException("shape mismatch"))
#    return !isnull(A.iop) ? get(A.iop)(mv) : throw(joMatrixException("inverse not defined"))
#end

# \(jo,vec)
function \(A::joMatrix,v::AbstractVector)
    isnull(A.iop) && throw(joMatrixException("\(jo,Vector) not supplied"))
    A.m == size(v,1) || throw(joMatrixException("shape mismatch"))
    return get(A.iop)(v)
end

############################################################
## overloaded Base +(...jo...)

# +(jo,jo)
function +(A::joMatrix,B::joMatrix)
    size(A) == size(B) || throw(joMatrixException("shape mismatch"))
    S=promote_type(eltype(A),eltype(B))
    return joMatrix{S}("("*A.name*"+"*B.name*")",A.m,B.n,
        v1->A.fop(v1)+B.fop(v1),
        v2->A.fop_T(v2)+B.fop_T(v2),
        v3->A.fop_CT(v3)+B.fop_CT(v3),
        v4->A.fop_C(v4)+B.fop_C(v4),
        @NF, @NF, @NF, @NF
        )
end

# +(jo,num)
function +(A::joMatrix,b::Number)
    S=promote_type(eltype(A),eltype(b))
    return joMatrix{S}("("*A.name*"+N)",A.m,A.n,
        v1->A.fop(v1)+b*joOnes(A.m,A.n)*v1,
        v2->A.fop_T(v2)+b*joOnes(A.m,A.n)*v2,
        v3->A.fop_CT(v3)+conj(b)*joOnes(A.m,A.n)*v3,
        v4->A.fop_C(v4)+conj(b)*joOnes(A.m,A.n)*v4,
        @NF, @NF, @NF, @NF
        )
end

############################################################
## overloaded Base -(...jo...)

# -(jo)
-{T}(A::joMatrix{T}) = joMatrix{T}("(-"*A.name*")",A.m,A.n,
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
double(A::joMatrix) = A*speye(A.n)

