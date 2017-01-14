############################################################
# joKron ###################################################
############################################################

##################
## type definition

export joKron, joKronException

immutable joKron{ODT} <: joAbstractLinearOperator{ODT}
    name::String
    m::Integer
    n::Integer
    l::Integer
    ms::Array{Integer,1}
    ns::Array{Integer,1}
    fop::Array{joAbstractLinearOperator,1}
end
function joKron(ops::joAbstractLinearOperator...)
    isempty(ops) && throw(joKronException("empty argument list"))
    e=eltype(ops[1])
    m=1
    n=1
    l=length(ops)
    ms=Array{Integer}(0)
    ns=Array{Integer}(0)
    kops=Array{joAbstractLinearOperator}(0)
    for i=1:l
        e=promote_type(e,eltype(ops[i]))
        m*=ops[i].m
        push!(ms,ops[i].m)
        n*=ops[i].n
        push!(ns,ops[i].n)
        push!(kops,ops[i])
    end
    return joKron{e}("joKron",m,n,l,ms,ns,kops)
end

type joKronException <: Exception
    msg :: String
end

##########################
## overloaded Base methods

function transpose{ODT}(A::joKron{ODT})
    m=A.n
    n=A.m
    l=A.l
    ms=A.ns
    ns=A.ms
    kops=Array{joAbstractLinearOperator}(0)
    for i=1:l
        push!(kops,A.fop[i].')
    end
    return joKron{ODT}("("*A.name*".')",m,n,l,ms,ns,kops)
end
function ctranspose{ODT}(A::joKron{ODT})
    m=A.n
    n=A.m
    l=A.l
    ms=A.ns
    ns=A.ms
    kops=Array{joAbstractLinearOperator}(0)
    for i=1:l
        push!(kops,A.fop[i]')
    end
    return joKron{ODT}("("*A.name*"')",m,n,l,ms,ns,kops)
end
function conj{ODT}(A::joKron{ODT})
    m=A.m
    n=A.n
    l=A.l
    ms=A.ms
    ns=A.ns
    kops=Array{joAbstractLinearOperator}(0)
    for i=1:l
        push!(kops,conj(A.fop[i]))
    end
    return joKron{ODT}("(conj("*A.name*"))",m,n,l,ms,ns,kops)
end

function *{AODT,vDT<:Number}(A::joKron{AODT},v::AbstractVector{vDT})
    size(A, 2) == size(v, 1) || throw(joKronException("shape mismatch"))
    ksz=reverse(A.ns)
    V=reshape(v,ksz...)
    p=[x for x in 1:A.l]
    p=circshift(p,-1)
    for i=A.l:-1:1
        V=reshape(V,[ksz[1],prod(ksz[2:length(ksz)])]...)
        V=A.fop[i]*V
        ksz[1]=A.fop[i].m
        V=reshape(V,ksz...)
        V=permutedims(V,p)
        ksz=circshift(ksz,-1)
    end
    return vec(V)
end
#function *{AODT,mvDT:<Number}(A::joKron{AODT},mv::AbstractMatrix{mvDT})
    #size(A, 2) == size(mv, 1) || throw(joKronException("shape mismatch"))
    #MV=zeros(promote_type(AODT,eltype(mv)),size(A,1),size(mv,2))
    #for i=1:size(mv,2)
        #MV[:,i]=A*mv[:,i]
    #end
    #return MV
#end

