############################################################
# joLinearFunction #########################################
############################################################

export joLinearFunction, joLinearFunctionAll, joLinearFunctionT, joLinearFunctionCT,
       joLinearFunctionFwdT, joLinearFunctionFwdCT, joLinearFunctionException

############################################################
## type definition

immutable joLinearFunction{T} <: joAbstractLinearOperator{T}
    name::String
    m::Integer
    n::Integer
    fop::Function              # forward
    fop_T::Nullable{Function}  # transpose
    fop_CT::Nullable{Function} # conj transpose
    fop_C::Nullable{Function}  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_CT::Nullable{Function}
    iop_C::Nullable{Function}
end

type joLinearFunctionException <: Exception
    msg :: String
end

############################################################
## outer constructors

joLinearFunctionAll(T::DataType,m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
    iop::Function,iop_T::Function,iop_CT::Function,iop_C::Function,
    name::String="joLinearFunctionAll")=
        joLinearFunction{T}(name,m,n,
            fop,fop_T,fop_CT,fop_C,iop,iop_T,iop_CT,iop_C)
joLinearFunctionT(T::DataType,m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    name::String="joLinearFunctionT")=
        joLinearFunction{T}(name,m,n,
            fop,fop_T,v3->conj(fop_T(conj(v3))),v4->conj(fop(conj(v4))),
            iop,iop_T,v7->conj(iop_T(conj(v7))),v8->conj(iop(conj(v8))))
joLinearFunctionCT(T::DataType,m::Integer,n::Integer,
    fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
    name::String="joLinearFunctionCT")=
        joLinearFunction{T}(name,m,n,
            fop,v2->conj(fop_CT(conj(v2))),fop_CT,v4->conj(fop(conj(v4))),
            iop,v6->conj(iop_CT(conj(v6))),iop_CT,v8->conj(iop(conj(v8))))
joLinearFunctionFwdT(T::DataType,m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    name::String="joLinearFunctionFwdT")=
        joLinearFunction{T}(name,m,n,
            fop,fop_T,v3->conj(fop_T(conj(v3))),v4->conj(fop(conj(v4))),
            @NF, @NF, @NF, @NF)
joLinearFunctionFwdCT(T::DataType,m::Integer,n::Integer,
    fop::Function,fop_CT::Function,
    name::String="joLinearFunctionFwdCT")=
        joLinearFunction{T}(name,m,n,
            fop,v2->conj(fop_CT(conj(v2))),fop_CT,v4->conj(fop(conj(v4))),
            @NF, @NF, @NF, @NF)

############################################################
## overloaded Base functions

# transpose(jo)
transpose{T}(A::joLinearFunction{T}) = joLinearFunction{T}(""*A.name*".'",A.n,A.m,
    get(A.fop_T),@NF(A.fop),A.fop_C,A.fop_CT,
    A.iop_T,A.iop,A.iop_C,A.iop_CT)

# ctranspose(jo)
ctranspose{T}(A::joLinearFunction{T}) = joLinearFunction{T}(""*A.name*"'",A.n,A.m,
    get(A.fop_CT),A.fop_C,@NF(A.fop),A.fop_T,
    A.iop_CT,A.iop_C,A.iop,A.iop_T)

# conj(jo)
conj{T}(A::joLinearFunction{T}) = joLinearFunction{T}("conj("*A.name*")",A.m,A.n,
    get(A.fop_C),A.fop_CT,A.fop_T,@NF(A.fop),
    A.iop_C,A.iop_CT,A.iop_T,A.iop)

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
function *(A::joLinearFunction,B::joLinearFunction)
    A.n == B.m || throw(joLinearFunctionException("shape mismatch"))
    S=promote_type(eltype(A),eltype(B))
    return joLinearFunction{S}("("*A.name*"*"*B.name*")",A.m,B.n,
    v1->A.fop(B.fop(v1)),v2->get(B.fop_T)(get(A.fop_T)(v2)),
    v3->get(B.fop_CT)(get(A.fop_CT)(v3)),v4->get(A.fop_C)(get(B.fop_C)(v4)),
    @NF, @NF, @NF, @NF)
end

# *(jo,mvec)
#function *(A::joLinearFunction,mv::AbstractMatrix)
#    A.n == size(mv,1) || throw(joLinearFunctionException("shape mismatch"))
#    return A.fop(mv)
#end

# *(jo,vec)
function *(A::joLinearFunction,v::AbstractVector)
    A.n == size(v,1) || throw(joLinearFunctionException("shape mismatch"))
    return A.fop(v)
end

# *(num,jo)
function *(a::Number,A::joLinearFunction)
    S=promote_type(eltype(a),eltype(A))
    return joLinearFunction{S}("(N*"*A.name*")",A.m,A.n,
    v1->a*A.fop(v1),v2->a*A.fop_T(v2),
    v3->conj(a)*A.fop_CT(v3),v4->conj(a)*A.fop_C(v4),
    @NF, @NF, @NF, @NF)
end

############################################################
## overloaded Base \(...jo...)

# \(jo,mvec)
#function \(A::joLinearFunction,mv::AbstractMatrix)
#    A.m == size(mv,1) || throw(joLinearFunctionException("shape mismatch"))
#    return !isnull(A.iop) ? get(A.iop)(mv) : throw(joLinearFunctionException("inverse not defined"))
#end

# \(jo,vec)
function \(A::joLinearFunction,v::AbstractVector)
    isnull(A.iop) && throw(joLinearFunctionException("\(jo,Vector) not supplied"))
    A.m == size(v,1) || throw(joLinearFunctionException("shape mismatch"))
    return get(A.iop)(v)
end

############################################################
## overloaded Base +(...jo...)

# +(jo,jo)
function +(A::joLinearFunction,B::joLinearFunction)
    size(A) == size(B) || throw(joLinearFunctionException("shape mismatch"))
    S=promote_type(eltype(A),eltype(B))
    return joLinearFunction{S}("("*A.name*"+"*B.name*")",A.m,B.n,
    v1->A.fop(v1)+B.fop(v1),v2->A.fop_T(v2)+B.fop_T(v2),
    v3->A.fop_CT(v3)+B.fop_CT(v3),v4->A.fop_C(v4)+B.fop_C(v4),
    @NF, @NF, @NF, @NF)
end

############################################################
## overloaded Base -(...jo...)

# -(jo)
-{T}(A::joLinearFunction{T}) = joLinearFunction{T}("(-"*A.name*")",A.m,A.n,
    v1->-A.fop(v1),     v2->-A.fop_T(v2),     v3->-A.fop_CT(v3),     v4->-A.fop_C(v4),
    v5->-get(A.iop)(v5),v6->-get(A.iop_T)(v6),v7->-get(A.iop_CT)(v7),v8->-get(A.iop_C)(v8))

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

