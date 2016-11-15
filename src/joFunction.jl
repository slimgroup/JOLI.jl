############################################################
# joFunction ###############################################
############################################################

##################
## type definition

export joFunction, joFunctionAll, joFunctionT, joFunctionCT,
       joFunctionFwdT, joFunctionFwdCT, joFunctionException

immutable joFunction{T} <: joOperator{T}
    name::String
    m::Integer
    n::Integer
    fop::Function                 # forward
    fop_T::Nullable{Function}     # transpose
    fop_CT::Nullable{Function}    # conj transpose
    fop_C::Nullable{Function}     # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_CT::Nullable{Function}
    iop_C::Nullable{Function}
end
joFunctionAll(T::DataType,m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
    iop::Function,iop_T::Function,iop_CT::Function,iop_C::Function,
    name::String="joFunctionAll")=
    joFunction{T}(name,m,n,fop,fop_T,fop_CT,fop_C,iop,iop_T,iop_CT,iop_C)
joFunctionT(T::DataType,m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    name::String="joFunctionT")=
    joFunction{T}(name,m,n,
        fop,fop_T,v3->conj(fop_T(conj(v3))),v4->conj(fop(conj(v4))),
        iop,iop_T,v7->conj(iop_T(conj(v7))),v8->conj(iop(conj(v8))))
joFunctionCT(T::DataType,m::Integer,n::Integer,
    fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
    name::String="joFunctionCT")=
    joFunction{T}(name,m,n,
        fop,v2->conj(fop_CT(conj(v2))),fop_CT,v4->conj(fop(conj(v4))),
        iop,v6->conj(iop_CT(conj(v6))),iop_CT,v8->conj(iop(conj(v8))))
joFunctionFwdT(T::DataType,m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    name::String="joFunctionFwdT")=
    joFunction{T}(name,m,n,
        fop,fop_T,v3->conj(fop_T(conj(v3))),v4->conj(fop(conj(v4))),
        @NF, @NF, @NF, @NF)
joFunctionFwdCT(T::DataType,m::Integer,n::Integer,
    fop::Function,fop_CT::Function,
    name::String="joFunctionFwdCT")=
    joFunction{T}(name,m,n,
        fop,v2->conj(fop_CT(conj(v2))),fop_CT,v4->conj(fop(conj(v4))),
        @NF, @NF, @NF, @NF)

type joFunctionException <: Exception
    msg :: String
end

##########################
## overloaded Base methods

transpose{T}(A::joFunction{T}) = joFunction{T}(""*A.name*".'",A.n,A.m,
    get(A.fop_T),A.fop,A.fop_C,A.fop_CT,
    A.iop_T,A.iop,A.iop_C,A.iop_CT)

ctranspose{T}(A::joFunction{T}) = joFunction{T}(""*A.name*"'",A.n,A.m,
    get(A.fop_CT),A.fop_C,A.fop,A.fop_T,
    A.iop_CT,A.iop_C,A.iop,A.iop_T)

conj{T}(A::joFunction{T}) = joFunction{T}("conj("*A.name*")",A.m,A.n,
    get(A.fop_C),A.fop_CT,A.fop_T,A.fop,
    A.iop_C,A.iop_CT,A.iop_T,A.iop)

function *(A::joFunction,B::joFunction)
    size(A,2) == size(B,1) || throw(joFunctionException("shape mismatch"))
    S=promote_type(eltype(A),eltype(B))
    return joFunction{S}("("*A.name*"*"*B.name*")",size(A,1),size(B,2),
    v1->A.fop(B.fop(v1)),v2->get(B.fop_T)(get(A.fop_T)(v2)),
    v3->get(B.fop_CT)(get(A.fop_CT)(v3)),v4->get(A.fop_C)(get(B.fop_C)(v4)),
    @NF, @NF, @NF, @NF)
end
function *(A::joFunction,v::AbstractVector)
    size(A, 2) == size(v, 1) || throw(joFunctionException("shape mismatch"))
    return A.fop(v)
end
#function *(A::joFunction,mv::AbstractMatrix)
#    size(A, 2) == size(mv, 1) || throw(joFunctionException("shape mismatch"))
#    return A.fop(mv)
#end
function *(a::Number,A::joFunction)
    S=promote_type(eltype(a),eltype(A))
    return joFunction{S}("(N*"*A.name*")",A.m,A.n,
    v1->a*A.fop(v1),v2->a*A.fop_T(v2),
    v3->conj(a)*A.fop_CT(v3),v4->conj(a)*B.fop_C(v4),
    @NF, @NF, @NF, @NF)
end

function \(A::joFunction,v::AbstractVector)
    size(A, 1) == size(v, 1) || throw(joFunctionException("shape mismatch"))
    return !isnull(A.iop) ? get(A.iop)(v) : throw(joFunctionException("inverse not defined"))
end
#function \(A::joFunction,mv::AbstractMatrix)
#    size(A, 1) == size(mv, 1) || throw(joFunctionException("shape mismatch"))
#    return !isnull(A.iop) ? get(A.iop)(mv) : throw(joFunctionException("inverse not defined"))
#end

function +(A::joFunction,B::joFunction)
    size(A) == size(B) || throw(joFunctionException("shape mismatch"))
    S=promote_type(eltype(A),eltype(B))
    return joFunction{S}("("*A.name*"+"*B.name*")",size(A,1),size(B,2),
    v1->A.fop(v1)+B.fop(v1),v2->B.fop_T(v2)+A.fop_T(v2),
    v3->B.fop_CT(v3)+A.fop_CT(v3),v4->A.fop_C(v4)+B.fop_C(v4),
    @NF, @NF, @NF, @NF)
end

-{T}(A::joFunction{T}) = joFunction{T}("(-"*A.name*")",A.m,A.n,
    v1->-A.fop(v1),     v2->-A.fop_T(v2),     v3->-A.fop_CT(v3),     v4->-A.fop_C(v4),
    v5->-get(A.iop)(v5),v6->-get(A.iop_T)(v6),v7->-get(A.iop_CT)(v7),v8->-get(A.iop_C)(v8))

################
## extra methods

