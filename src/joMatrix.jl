############################################################
# joMatrix #################################################
############################################################

##################
## type definition

export joMatrix, joMatrixException

immutable joMatrix{T} <: joOperator{T}
    name::String
    m::Integer
    n::Integer
    fop::Function       # forward
    fop_T::Function     # transpose
    fop_CT::Function    # conj transpose
    fop_C::Function     # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_CT::Nullable{Function}
    iop_C::Nullable{Function}
end
joMatrix{T}(array::AbstractMatrix{T},name::String="joMatrix")=
    joMatrix{T}(name,size(array,1),size(array,2),
    v1->array*v1,v2->array.'*v2,v3->array'*v3,v4->conj(array)*v4,
    v5->array\v5,v6->array.'\v6,v7->array'\v7,v8->conj(array)\v8)

type joMatrixException <: Exception
    msg :: String
end

##########################
## overloaded Base methods

transpose{T}(A::joMatrix{T}) = joMatrix{T}(""*A.name*".'",A.n,A.m,
    A.fop_T,A.fop,A.fop_C,A.fop_CT,
    A.iop_T,A.iop,A.iop_C,A.iop_CT)

ctranspose{T}(A::joMatrix{T}) = joMatrix{T}(""*A.name*"'",A.n,A.m,
    A.fop_CT,A.fop_C,A.fop,A.fop_T,
    A.iop_CT,A.iop_C,A.iop,A.iop_T)

conj{T}(A::joMatrix{T}) = joMatrix{T}("conj("*A.name*")",A.m,A.n,
    A.fop_C,A.fop_CT,A.fop_T,A.fop,
    A.iop_C,A.iop_CT,A.iop_T,A.iop)

function *(A::joMatrix,B::joMatrix)
    size(A,2) == size(B,1) || throw(joMatrixException("shape mismatch"))
    S=promote_type(eltype(A),eltype(B))
    return joMatrix{S}("("*A.name*"*"*B.name*")",size(A,1),size(B,2),
    v1->A.fop(B.fop(v1)),v2->B.fop_T(A.fop_T(v2)),
    v3->B.fop_CT(A.fop_CT(v3)),v4->A.fop_C(B.fop_C(v4)),
    @NF, @NF, @NF, @NF)
end
function *(A::joMatrix,v::AbstractVector)
    size(A, 2) == size(v, 1) || throw(joMatrixException("shape mismatch"))
    return A.fop(v)
end
#function *(A::joMatrix,mv::AbstractMatrix)
#    size(A, 2) == size(mv, 1) || throw(joMatrixException("shape mismatch"))
#    return A.fop(mv)
#end
function *(a::Number,A::joMatrix)
    S=promote_type(eltype(a),eltype(A))
    return joMatrix{S}("(N*"*A.name*")",A.m,A.n,
    v1->a*A.fop(v1),v2->a*A.fop_T(v2),
    v3->conj(a)*A.fop_CT(v3),v4->conj(a)*B.fop_C(v4),
    @NF, @NF, @NF, @NF)
end

function \(A::joMatrix,v::AbstractVector)
    size(A, 1) == size(v, 1) || throw(joMatrixException("shape mismatch"))
    return !isnull(A.iop) ? get(A.iop)(v) : throw(joMatrixException("inverse not defined"))
end
#function \(A::joMatrix,mv::AbstractMatrix)
#    size(A, 1) == size(mv, 1) || throw(joMatrixException("shape mismatch"))
#    return !isnull(A.iop) ? get(A.iop)(mv) : throw(joMatrixException("inverse not defined"))
#end

function +(A::joMatrix,B::joMatrix)
    size(A) == size(B) || throw(joMatrixException("shape mismatch"))
    S=promote_type(eltype(A),eltype(B))
    return joMatrix{S}("("*A.name*"+"*B.name*")",size(A,1),size(B,2),
    v1->A.fop(v1)+B.fop(v1),v2->B.fop_T(v2)+A.fop_T(v2),
    v3->B.fop_CT(v3)+A.fop_CT(v3),v4->A.fop_C(v4)+B.fop_C(v4),
    @NF, @NF, @NF, @NF)
end

-{T}(A::joMatrix{T}) = joMatrix{T}("(-"*A.name*")",A.m,A.n,
    v1->-A.fop(v1),     v2->-A.fop_T(v2),     v3->-A.fop_CT(v3),     v4->-A.fop_C(v4),
    v5->-get(A.iop)(v5),v6->-get(A.iop_T)(v6),v7->-get(A.iop_CT)(v7),v8->-get(A.iop_C)(v8))

################
## extra methods

