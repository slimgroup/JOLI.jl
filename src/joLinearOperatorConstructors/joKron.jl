############################################################
# joKron ###################################################
############################################################

##################
## type definition

export joKron, joKronException

immutable joKron{DDT,RDT} <: joAbstractLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    l::Integer
    ms::Array{Integer,1}
    ns::Array{Integer,1}
    fop::Array{joAbstractLinearOperator,1}
    fop_T::Array{joAbstractLinearOperator,1}
    fop_CT::Array{joAbstractLinearOperator,1}
    fop_C::Array{joAbstractLinearOperator,1}
    flip::Bool
end
function joKron(ops::joAbstractLinearOperator...)
    isempty(ops) && throw(joKronException("empty argument list"))
    e=eltype(ops[1])
    m=1
    n=1
    l=length(ops)
    ms=Array{Integer}(0)
    ns=Array{Integer}(0)
    fops=Array{joAbstractLinearOperator}(0)
    fops_T=Array{joAbstractLinearOperator}(0)
    fops_CT=Array{joAbstractLinearOperator}(0)
    fops_C=Array{joAbstractLinearOperator}(0)
    for i=1:l
        im1=max(i-1,1)
        reltype(ops[i])==deltype(ops[im1]) || throw(joKronException("domain/range mismatch for $i operator"))
        m*=ops[i].m
        push!(ms,ops[i].m)
        n*=ops[i].n
        push!(ns,ops[i].n)
        push!(fops,ops[i])
        push!(fops_T,ops[i].')
        push!(fops_CT,ops[i]')
        push!(fops_C,conj(ops[i]))
    end
    return joKron{deltype(fops[l]),reltype(fops[1])}("joKron($l)",m,n,l,ms,ns,fops,fops_T,fops_CT,fops_C,false)
end

type joKronException <: Exception
    msg :: String
end

##########################
## overloaded Base methods

transpose{DDT,RDT}(A::joKron{DDT,RDT}) =
    joKron{RDT,DDT}("("*A.name*".')",
        A.n,A.m,A.l,A.ns,A.ms,
        A.fop_T,A.fop,A.fop_C,A.fop_CT,!A.flip)

ctranspose{DDT,RDT}(A::joKron{DDT,RDT}) =
    joKron{RDT,DDT}("("*A.name*"')",
        A.n,A.m,A.l,A.ns,A.ms,
        A.fop_CT,A.fop_C,A.fop,A.fop_T,!A.flip)

conj{DDT,RDT}(A::joKron{DDT,RDT}) =
    joKron{DDT,RDT}("(conj("*A.name*"))",
        A.m,A.n,A.l,A.ms,A.ns,
        A.fop_C,A.fop_CT,A.fop_T,A.fop,A.flip)

function *{ADDT,ARDT}(A::joKron{ADDT,ARDT},v::AbstractVector{ADDT})
    size(A,2) == size(v,1) || throw(joKronException("shape mismatch"))
    ksz=reverse(A.ns)
    V=reshape(v,ksz...)
    p=[x for x in 1:A.l]
    if A.flip
        p=circshift(p,1)
        for i=1:1:A.l
            ksz=circshift(ksz,1)
            V=permutedims(V,p)
            V=reshape(V,[ksz[1],prod(ksz[2:length(ksz)])]...)
            V=A.fop[i]*V
            ksz[1]=A.fop[i].m
            V=reshape(V,ksz...)
        end
    else
        p=circshift(p,-1)
        for i=A.l:-1:1
            V=reshape(V,[ksz[1],prod(ksz[2:length(ksz)])]...)
            V=A.fop[i]*V
            ksz[1]=A.fop[i].m
            V=reshape(V,ksz...)
            V=permutedims(V,p)
            ksz=circshift(ksz,-1)
        end
    end
    return vec(V)
end

#function *{AEDT,mvDT:<Number}(A::joKron{AEDT},mv::AbstractMatrix{mvDT})
    #size(A, 2) == size(mv, 1) || throw(joKronException("shape mismatch"))
    #MV=zeros(promote_type(AEDT,eltype(mv)),size(A,1),size(mv,2))
    #for i=1:size(mv,2)
        #MV[:,i]=A*mv[:,i]
    #end
    #return MV
#end

