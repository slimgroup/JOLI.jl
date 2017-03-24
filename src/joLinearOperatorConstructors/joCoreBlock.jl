############################################################
# joCoreBlock ##############################################
############################################################

##################
## type definition

export joCoreBlock, joCoreBlockException

immutable joCoreBlock{DDT,RDT} <: joAbstractLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    l::Integer
    ms::Vector{Integer}
    ns::Vector{Integer}
    mo::Vector{Integer}
    no::Vector{Integer}
    ws::Vector{Number}
    fop::Vector{joAbstractLinearOperator}
    fop_T::Vector{joAbstractLinearOperator}
    fop_CT::Vector{joAbstractLinearOperator}
    fop_C::Vector{joAbstractLinearOperator}
    iop::Vector{joAbstractLinearOperator}
    iop_T::Vector{joAbstractLinearOperator}
    iop_CT::Vector{joAbstractLinearOperator}
    iop_C::Vector{joAbstractLinearOperator}
end

############################################################
## type exceptions

type joCoreBlockException <: Exception
    msg :: String
end

############################################################
## outer constructors

"""
    joCoreBlock(ops::joAbstractLinearOperator...;moffsets::Vector{Integer},noffsets::Vector{Integer},weights::AbstractVector)

Universal (Core) block operator composed from different JOLI operators

# Example
    a=rand(Complex{Float64},4,5);
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
    b=rand(Complex{Float64},7,8);
    B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
    c=rand(Complex{Float64},6,8);
    C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64},name="C")
    moff=[0;5;13]
    noff=[0;6;15]
    BD=joCoreBlock(A,B,C;moffsets=moff,noffsets=noff) # sparse blocks
    BD=joCoreBlock(A,B,C) # basic diagonal-corners adjacent blocks
    w=rand(Complex{Float64},3)
    BD=joCoreBlock(A,B,C;weights=w) # weighted basic diagonal-corners adjacent blocks

# Notes
- all given operators must have same domain/range types
- the domain/range types of joCoreBlock are equal to domain/range types of the given operators

"""
function joCoreBlock(ops::joAbstractLinearOperator...;kwargs...)
           #moffsets::AbstractVector{MNDT}=zeros(Integer,0),noffsets::AbstractVector{MNDT}=zeros(Integer,0),weights::AbstractVector{WDT}=zeros(0))
    isempty(ops) && throw(joCoreBlockException("empty argument list"))
    mykws=Dict(kwargs[i][1]=>kwargs[i][2] for i in 1:length(kwargs))
    mo=Base.deepcopy(get(mykws, :moffsets, zeros(Int,0)))
    typeof(mo)<:AbstractVector || throw(joCoreBlockException("moffsets must be a vector"))
    eltype(mo)<:Integer || throw(joCoreBlockException("moffsets vector must have integer elements"))
    no=Base.deepcopy(get(mykws, :noffsets, zeros(Int,0)))
    typeof(no)<:AbstractVector || throw(joCoreBlockException("noffsets must be a vector"))
    eltype(no)<:Integer || throw(joCoreBlockException("noffsets vector must have integer elements"))
    ws=Base.deepcopy(get(mykws, :weights, zeros(0)))
    typeof(ws)<:AbstractVector || throw(joCoreBlockException("weights must be a vector"))
    l=length(ops)
    ms=Vector{Integer}(0)
    ns=Vector{Integer}(0)
    for i=1:l
        deltype(ops[i])==deltype(ops[1]) || throw(joCoreBlockException("domain type mismatch for $i operator"))
        reltype(ops[i])==reltype(ops[1]) || throw(joCoreBlockException("range type mismatch for $i operator"))
        push!(ms,ops[i].m)
        push!(ns,ops[i].n)
    end
    (length(mo)==l || length(mo)==0) || throw(joCoreBlockException("lenght of moffsets vector does not match number of operators"))
    (length(no)==l || length(no)==0) || throw(joCoreBlockException("lenght of noffsets vector does not match number of operators"))
    (length(ws)==l || length(ws)==0) || throw(joCoreBlockException("lenght of weights vector does not match number of operators"))
    if (length(mo)==0 && length(no)==0)
        m=sum(ms)
        n=sum(ns)
        mo=zeros(Integer,l)
        no=zeros(Integer,l)
        mo[1]=0
        no[1]=0
        for i=2:l
            mo[i]=mo[i-1]+ms[i-1]
            no[i]=no[i-1]+ns[i-1]
        end
    elseif (length(mo)==l && length(no)==0)
        m=max((mo+ms)...)
        n=max(ns...)
        no=zeros(Int,l)
    elseif (length(mo)==0 && length(no)==l)
        m=max(ms...)
        n=max((no+ns)...)
        mo=zeros(Int,l)
    else
        m=max((mo+ms)...)
        n=max((no+ns)...)
    end
    weighted=(length(ws)==l)
    fops=Vector{joAbstractLinearOperator}(0)
    fops_T=Vector{joAbstractLinearOperator}(0)
    fops_CT=Vector{joAbstractLinearOperator}(0)
    fops_C=Vector{joAbstractLinearOperator}(0)
    iops=Vector{joAbstractLinearOperator}(0)
    iops_T=Vector{joAbstractLinearOperator}(0)
    iops_CT=Vector{joAbstractLinearOperator}(0)
    iops_C=Vector{joAbstractLinearOperator}(0)
    for i=1:l
        if weighted
            push!(fops,ws[i]*ops[i])
            push!(fops_T,ws[i]*ops[i].')
            push!(fops_CT,conj(ws[i])*ops[i]')
            push!(fops_C,conj(ws[i])*conj(ops[i]))
        else
            push!(fops,ops[i])
            push!(fops_T,ops[i].')
            push!(fops_CT,ops[i]')
            push!(fops_C,conj(ops[i]))
        end
    end
    return joCoreBlock{deltype(fops[l]),reltype(fops[1])}("joCoreBlock($l)",m,n,l,ms,ns,mo,no,ws,
                      fops,fops_T,fops_CT,fops_C,iops,iops_T,iops_CT,iops_C)
end

############################
## overloaded Base functions

# showall(jo)
function showall(A::joCoreBlock)
    println("# joCoreBlock")
    println("-      name: ",A.name)
    println("-      type: ",typeof(A))
    println("-      size: ",size(A))
    println("-  # of ops: ",A.l)
    println("-   m-sizes: ",A.ms)
    println("-   n-sizes: ",A.ns)
    println("- m-offsets: ",A.mo)
    println("- n-offsets: ",A.no)
    println("-  weigthts: ",A.ws)
    for i=1:A.l
    println("*      op $i: ",(A.fop[i].name,typeof(A.fop[i]),A.fop[i].m,A.fop[i].n))
    end
end

# conj(jo)
conj{DDT,RDT}(A::joCoreBlock{DDT,RDT}) =
    joCoreBlock{DDT,RDT}("(conj("*A.name*"))",
        A.m,A.n,A.l,A.ms,A.ns,A.mo,A.no,A.ws,
        A.fop_C,A.fop_CT,A.fop_T,A.fop,
        A.iop_C,A.iop_CT,A.iop_T,A.iop)

# transpose(jo)
transpose{DDT,RDT}(A::joCoreBlock{DDT,RDT}) =
    joCoreBlock{RDT,DDT}("("*A.name*".')",
        A.n,A.m,A.l,A.ns,A.ms,A.no,A.mo,A.ws,
        A.fop_T,A.fop,A.fop_C,A.fop_CT,
        A.iop_T,A.iop,A.iop_C,A.iop_CT)

# ctranspose(jo)
ctranspose{DDT,RDT}(A::joCoreBlock{DDT,RDT}) =
    joCoreBlock{RDT,DDT}("("*A.name*"')",
        A.n,A.m,A.l,A.ns,A.ms,A.no,A.mo,A.ws,
        A.fop_CT,A.fop_C,A.fop,A.fop_T,
        A.iop_CT,A.iop_C,A.iop,A.iop_T)

############################################################
## overloaded Base *(...jo...)

# *(jo,vec)
function *{ADDT,ARDT}(A::joCoreBlock{ADDT,ARDT},v::AbstractVector{ADDT})
    size(A,2) == size(v,1) || throw(joCoreBlockException("shape mismatch"))
    V=zeros(ARDT,A.m)
    for i=1:1:A.l
        sm=A.mo[i]+1
        em=A.mo[i]+A.ms[i]
        sn=A.no[i]+1
        en=A.no[i]+A.ns[i]
        V[sm:em]+=A.fop[i]*v[sn:en]
    end
    return V
end

# *(jo,mvec)
#function *{AEDT,mvDT:<Number}(A::joCoreBlock{AEDT},mv::AbstractMatrix{mvDT})
    #size(A, 2) == size(mv, 1) || throw(joCoreBlockException("shape mismatch"))
    #MV=zeros(promote_type(AEDT,eltype(mv)),size(A,1),size(mv,2))
    #for i=1:size(mv,2)
        #MV[:,i]+=A*mv[:,i]
    #end
    #return MV
#end

