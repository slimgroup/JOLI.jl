############################################################
# joCoreBlock ##############################################
############################################################

############################################################
## outer constructors

"""
Universal (Core) block operator composed from different JOLI operators

    joCoreBlock(ops::joAbstractLinearOperator...;
        moffsets::Vector{Integer},noffsets::Vector{Integer},weights::AbstractVector,name::String)

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
    BD=joCoreBlock(A,B,C;moffsets=moff,noffsets=noff,ME=5,NE=5) # sparse blocks with zero extansion of (ME,NE) size
    BD=joCoreBlock(A,B,C) # basic diagonal-corners adjacent blocks
    w=rand(Complex{Float64},3)
    BD=joCoreBlock(A,B,C;weights=w) # weighted basic diagonal-corners adjacent blocks

# Notes
- all given operators must have same domain/range types
- the domain/range types of joCoreBlock are equal to domain/range types of the given operators

"""
function joCoreBlock(ops::joAbstractLinearOperator...;kwargs...)
           #moffsets::AbstractVector{MNDT}=zeros(Int,0),noffsets::AbstractVector{MNDT}=zeros(Int,0),weights::AbstractVector{WDT}=zeros(0),name::String="joCoreBlock")
    isempty(ops) && throw(joCoreBlockException("empty argument list"))
    l=length(ops)
    for i=1:l
        deltype(ops[i])==deltype(ops[1]) || throw(joCoreBlockException("domain type mismatch for $i operator"))
        reltype(ops[i])==reltype(ops[1]) || throw(joCoreBlockException("range type mismatch for $i operator"))
    end
    mykws=Dict(kwargs[i][1]=>kwargs[i][2] for i in 1:length(kwargs))
    mo=Base.deepcopy(get(mykws, :moffsets, zeros(Int,0)))
    typeof(mo)<:AbstractVector || throw(joCoreBlockException("moffsets must be a vector"))
    eltype(mo)<:Integer || throw(joCoreBlockException("moffsets vector must have integer elements"))
    (length(mo)==l || length(mo)==0) || throw(joCoreBlockException("lenght of moffsets vector does not match number of operators"))
    no=Base.deepcopy(get(mykws, :noffsets, zeros(Int,0)))
    typeof(no)<:AbstractVector || throw(joCoreBlockException("noffsets must be a vector"))
    eltype(no)<:Integer || throw(joCoreBlockException("noffsets vector must have integer elements"))
    (length(no)==l || length(no)==0) || throw(joCoreBlockException("lenght of noffsets vector does not match number of operators"))
    ws=Base.deepcopy(get(mykws, :weights, zeros(0)))
    typeof(ws)<:AbstractVector || throw(joCoreBlockException("weights must be a vector"))
    (length(ws)==l || length(ws)==0) || throw(joCoreBlockException("lenght of weights vector does not match number of operators"))
    name=get(mykws, :name, "joCoreBlock")
    typeof(name)<:String || throw(joCoreBlockException("name must be a string"))
    ME=get(mykws, :ME, 0)
    typeof(ME)<:Integer || throw(joCoreBlockException("ME must be Integer"))
    ME>=0 || throw(joCoreBlockException("ME must be >=0"))
    NE=get(mykws, :NE, 0)
    typeof(NE)<:Integer || throw(joCoreBlockException("NE must be Integer"))
    NE>=0 || throw(joCoreBlockException("NE must be >=0"))
    ms=zeros(Int,l)
    ns=zeros(Int,l)
    for i=1:l
        ms[i]=ops[i].m
        ns[i]=ops[i].n
    end
    if (length(mo)==0 && length(no)==0)
        m=sum(ms)
        n=sum(ns)
        mo=zeros(Int,l)
        no=zeros(Int,l)
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
    m+=ME
    n+=NE
    weighted=(length(ws)==l)
    fops=Vector{joAbstractLinearOperator}(0)
    fops_T=Vector{joAbstractLinearOperator}(0)
    fops_A=Vector{joAbstractLinearOperator}(0)
    fops_C=Vector{joAbstractLinearOperator}(0)
    for i=1:l
        if weighted
            push!(fops,ws[i]*ops[i])
            push!(fops_T,ws[i]*transpose(ops[i]))
            push!(fops_A,conj(ws[i])*adjoint(ops[i]))
            push!(fops_C,conj(ws[i])*conj(ops[i]))
        else
            push!(fops,ops[i])
            push!(fops_T,transpose(ops[i]))
            push!(fops_A,adjoint(ops[i]))
            push!(fops_C,conj(ops[i]))
        end
    end
    return joCoreBlock{deltype(fops[1]),reltype(fops[1])}(name*"($l)",m,n,l,ms,ns,mo,no,ws,
                      fops,fops_T,fops_A,fops_C,@joNF,@joNF,@joNF,@joNF)
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
conj(A::joCoreBlock{DDT,RDT}) where {DDT,RDT} =
    joCoreBlock{DDT,RDT}("(conj("*A.name*"))",
        A.m,A.n,A.l,A.ms,A.ns,A.mo,A.no,A.ws,
        A.fop_C,A.fop_A,A.fop_T,A.fop,
        A.iop_C,A.iop_A,A.iop_T,A.iop)

# transpose(jo)
transpose(A::joCoreBlock{DDT,RDT}) where {DDT,RDT} =
    joCoreBlock{RDT,DDT}("(transpose("*A.name*"))",
        A.n,A.m,A.l,A.ns,A.ms,A.no,A.mo,A.ws,
        A.fop_T,A.fop,A.fop_C,A.fop_A,
        A.iop_T,A.iop,A.iop_C,A.iop_A)

# adjoint(jo)
adjoint(A::joCoreBlock{DDT,RDT}) where {DDT,RDT} =
    joCoreBlock{RDT,DDT}("(adjoint("*A.name*"))",
        A.n,A.m,A.l,A.ns,A.ms,A.no,A.mo,A.ws,
        A.fop_A,A.fop_C,A.fop,A.fop_T,
        A.iop_A,A.iop_C,A.iop,A.iop_T)

# *(jo,vec)
function *(A::joCoreBlock{ADDT,ARDT},v::AbstractVector{ADDT}) where {ADDT,ARDT}
    size(A,2) == size(v,1) || throw(joCoreBlockException("shape mismatch"))
    V=zeros(ARDT,A.m) # must be preallocated with zeros
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
function *(A::joCoreBlock{ADDT,ARDT},mv::AbstractMatrix{ADDT}) where {ADDT,ARDT}
    size(A, 2) == size(mv, 1) || throw(joCoreBlockException("shape mismatch"))
    MV=zeros(ARDT,size(A,1),size(mv,2)) # must be preallocated with zeros
    for i=1:1:A.l
        sm=A.mo[i]+1
        em=A.mo[i]+A.ms[i]
        sn=A.no[i]+1
        en=A.no[i]+A.ns[i]
        MV[sm:em,:]+=A.fop[i]*mv[sn:en,:]
    end
    return MV
end

# -(jo)
function -(A::joCoreBlock{DDT,RDT}) where {DDT,RDT}
    fops=Vector{joAbstractLinearOperator}(0)
    fops_T=Vector{joAbstractLinearOperator}(0)
    fops_A=Vector{joAbstractLinearOperator}(0)
    fops_C=Vector{joAbstractLinearOperator}(0)
    for i=1:A.l
        push!(fops,-A.fop[i])
        push!(fops_T,-A.fop_T[i])
        push!(fops_A,-A.fop_A[i])
        push!(fops_C,-A.fop_C[i])
    end
    return joCoreBlock{DDT,RDT}("(-"*A.name*")",
        A.m,A.n,A.l,A.ms,A.ns,A.mo,A.no,A.ws,
        fops,fops_T,fops_A,fops_C,
        A.iop,A.iop_T,A.iop_A,A.iop_C)
end

