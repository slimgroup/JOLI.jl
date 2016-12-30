############################################################
# joLinearFunction #########################################
############################################################

export joLinearFunction, joLinearFunctionAll, joLinearFunctionT, joLinearFunctionCT,
       joLinearFunctionFwdT, joLinearFunctionFwdCT, joLinearFunctionException

############################################################
## type definition

immutable joLinearFunction{ODT<:Number} <: joAbstractLinearOperator{ODT}
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

joLinearFunctionAll(ODT::DataType,m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
    iop::Function,iop_T::Function,iop_CT::Function,iop_C::Function,
    name::String="joLinearFunctionAll") =
        joLinearFunction{ODT}(name,m,n,
            fop,fop_T,fop_CT,fop_C,
            iop,iop_T,iop_CT,iop_C
            )
joLinearFunctionT(ODT::DataType,m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    name::String="joLinearFunctionT") =
        joLinearFunction{ODT}(name,m,n,
            fop,
            fop_T,
            v3->conj(fop_T(conj(v3))),
            v4->conj(fop(conj(v4))),
            iop,
            iop_T,
            v7->conj(iop_T(conj(v7))),
            v8->conj(iop(conj(v8)))
            )
joLinearFunctionCT(ODT::DataType,m::Integer,n::Integer,
    fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
    name::String="joLinearFunctionCT") =
        joLinearFunction{ODT}(name,m,n,
            fop,
            v2->conj(fop_CT(conj(v2))),
            fop_CT,
            v4->conj(fop(conj(v4))),
            iop,
            v6->conj(iop_CT(conj(v6))),
            iop_CT,
            v8->conj(iop(conj(v8)))
            )
joLinearFunctionFwdT(ODT::DataType,m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    name::String="joLinearFunctionFwdT") =
        joLinearFunction{ODT}(name,m,n,
            fop,
            fop_T,
            v3->conj(fop_T(conj(v3))),
            v4->conj(fop(conj(v4))),
            @NF, @NF, @NF, @NF
            )
joLinearFunctionFwdCT(ODT::DataType,m::Integer,n::Integer,
    fop::Function,fop_CT::Function,
    name::String="joLinearFunctionFwdCT") =
        joLinearFunction{ODT}(name,m,n,
            fop,
            v2->conj(fop_CT(conj(v2))),
            fop_CT,
            v4->conj(fop(conj(v4))),
            @NF, @NF, @NF, @NF
            )

############################################################
## overloaded Base functions

# conj(jo)
conj{ODT}(A::joLinearFunction{ODT}) =
    joLinearFunction{ODT}("conj("*A.name*")",A.m,A.n,
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
transpose{ODT}(A::joLinearFunction{ODT}) =
    joLinearFunction{ODT}(""*A.name*".'",A.n,A.m,
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
ctranspose{ODT}(A::joLinearFunction{ODT}) =
    joLinearFunction{ODT}(""*A.name*"'",A.n,A.m,
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
function *{AODT,BODT}(A::joLinearFunction{AODT},B::joLinearFunction{BODT})
    A.n == B.m || throw(joLinearFunctionException("shape mismatch"))
    nODT=promote_type(AODT,BODT)
    return joLinearFunction{nODT}("("*A.name*"*"*B.name*")",A.m,B.n,
        v1->A.fop(B.fop(v1)),
        v2->get(B.fop_T)(get(A.fop_T)(v2)),
        v3->get(B.fop_CT)(get(A.fop_CT)(v3)),
        v4->get(A.fop_C)(get(B.fop_C)(v4)),
        @NF, @NF, @NF, @NF
        )
end

# *(jo,mvec)
#function *{AODT,mvDT}(A::joLinearFunction{AODT},mv::AbstractMatrix{mvDT})
#    A.n == size(mv,1) || throw(joLinearFunctionException("shape mismatch"))
#    return A.fop(mv)
#end

# *(jo,vec)
function *{AODT,vDT<:Number}(A::joLinearFunction{AODT},v::AbstractVector{vDT})
    A.n == size(v,1) || throw(joLinearFunctionException("shape mismatch"))
    return A.fop(v)
end

# *(num,jo)
function *{aDT<:Number,AODT}(a::aDT,A::joLinearFunction{AODT})
    nODT=promote_type(aDT,AODT)
    return joLinearFunction{nODT}("(N*"*A.name*")",A.m,A.n,
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
#function \{AODT,mvDT<:Number}(A::joLinearFunction{AODT},mv::AbstractMatrix{mvDT})
#    A.m == size(mv,1) || throw(joLinearFunctionException("shape mismatch"))
#    return !isnull(A.iop) ? get(A.iop)(mv) : throw(joLinearFunctionException("inverse not defined"))
#end

# \(jo,vec)
function \{AODT,vDT<:Number}(A::joLinearFunction{AODT},v::AbstractVector{vDT})
    isinvertible(A) || throw(joLinearFunctionException("\(jo,Vector) not supplied"))
    A.m == size(v,1) || throw(joLinearFunctionException("shape mismatch"))
    return get(A.iop)(v)
end

############################################################
## overloaded Base +(...jo...)

# +(jo,jo)
function +{AODT,BODT}(A::joLinearFunction{AODT},B::joLinearFunction{BODT})
    size(A) == size(B) || throw(joLinearFunctionException("shape mismatch"))
    nODT=promote_type(AODT,BODT)
    return joLinearFunction{nODT}("("*A.name*"+"*B.name*")",A.m,B.n,
        v1->A.fop(v1)+B.fop(v1),
        v2->A.fop_T(v2)+B.fop_T(v2),
        v3->A.fop_CT(v3)+B.fop_CT(v3),
        v4->A.fop_C(v4)+B.fop_C(v4),
        @NF, @NF, @NF, @NF
        )
end

# +(jo,num)
function +{AODT,bDT<:Number}(A::joLinearFunction{AODT},b::bDT)
    nODT=promote_type(AODT,bDT)
    return joLinearFunction{nODT}("("*A.name*"+N)",A.m,A.n,
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
-{ODT}(A::joLinearFunction{ODT}) =
    joLinearFunction{ODT}("(-"*A.name*")",A.m,A.n,
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
## extra methods

