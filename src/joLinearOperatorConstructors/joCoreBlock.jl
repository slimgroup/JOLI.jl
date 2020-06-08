############################################################
# joCoreBlock ##############################################
############################################################

############################################################
## outer constructors

"""
Universal (Core) block operator composed from different JOLI operators

    joCoreBlock(ops::joAbstractLinearOperator...;
        moffsets::LocalVector{Integer},noffsets::LocalVector{Integer},
        weights::LocalVector,mextend::Integer,nextend::Integer,name::String)

# Example
    a=rand(ComplexF64,4,5);
    A=joMatrix(a;DDT=ComplexF32,RDT=ComplexF64,name="A")
    b=rand(ComplexF64,7,8);
    B=joMatrix(b;DDT=ComplexF32,RDT=ComplexF64,name="B")
    c=rand(ComplexF64,6,8);
    C=joMatrix(c;DDT=ComplexF32,RDT=ComplexF64,name="C")
    moff=[0;5;13]
    noff=[0;6;15]
    BD=joCoreBlock(A,B,C;moffsets=moff,noffsets=noff) # sparse blocks
    BD=joCoreBlock(A,B,C;moffsets=moff,noffsets=noff,mextend=5,nextend=5) # sparse blocks with zero extansion of (mextend,nextend) size
    BD=joCoreBlock(A,B,C) # basic diagonal-corners adjacent blocks
    w=rand(ComplexF64,3)
    BD=joCoreBlock(A,B,C;weights=w) # weighted basic diagonal-corners adjacent blocks

# Notes
- all given operators must have same domain/range types
- the domain/range types of joCoreBlock are equal to domain/range types of the given operators

"""
function joCoreBlock(ops::joAbstractLinearOperator...;
        moffsets::LocalVector{OT}=zeros(Int,0),noffsets::LocalVector{OT}=zeros(Int,0),
        weights::LocalVector{WT}=zeros(0),mextend::Integer=0,nextend::Integer=0,
        name::String="joCoreBlock") where {OT<:Integer,WT<:Number}
    isempty(ops) && throw(joCoreBlockException("empty argument list"))
    l=length(ops)
    for i=1:l
        deltype(ops[i])==deltype(ops[1]) || throw(joCoreBlockException("domain type mismatch for $i operator"))
        reltype(ops[i])==reltype(ops[1]) || throw(joCoreBlockException("range type mismatch for $i operator"))
    end
    mo=Base.deepcopy(moffsets)
    (length(mo)==l || length(mo)==0) || throw(joCoreBlockException("lenght of moffsets vector does not match number of operators"))
    no=Base.deepcopy(noffsets)
    (length(no)==l || length(no)==0) || throw(joCoreBlockException("lenght of noffsets vector does not match number of operators"))
    ws=Base.deepcopy(weights)
    (length(ws)==l || length(ws)==0) || throw(joCoreBlockException("lenght of weights vector does not match number of operators"))
    mextend>=0 || throw(joCoreBlockException("mextend must be >=0"))
    nextend>=0 || throw(joCoreBlockException("nextend must be >=0"))
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
    m+=mextend
    n+=nextend
    weighted=(length(ws)==l)
    fops=Vector{joAbstractLinearOperator}(undef,0)
    fops_T=Vector{joAbstractLinearOperator}(undef,0)
    fops_A=Vector{joAbstractLinearOperator}(undef,0)
    fops_C=Vector{joAbstractLinearOperator}(undef,0)
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

# show(jo)
function show(A::joCoreBlock)
    println("Type: $(typeof(A).name)")
    println("Name: $(A.name)")
    println("Size: $(size(A))")
    println(" DDT: $(deltype(A))")
    println(" RDT: $(reltype(A))")
    println("# of ops: $(A.l)")
    for i=1:A.l
        a=A.fop[i]
        println("  $i Type: $(typeof(a).name)")
        println("     Name: $(a.name)")
        println("     Size: $(size(a))")
        println(" M-offset: $(A.mo[i])")
        println(" N-offset: $(A.no[i])")
        try
            println("   Weight: $(A.ws[i])")
        catch
            nothing
        end
        println("      DDT: $(deltype(a))")
        println("      RDT: $(reltype(a))")
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
function *(A::joCoreBlock{ADDT,ARDT},v::LocalVector{ADDT}) where {ADDT,ARDT}
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
function *(A::joCoreBlock{ADDT,ARDT},mv::LocalMatrix{ADDT}) where {ADDT,ARDT}
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
    fops=Vector{joAbstractLinearOperator}(undef,0)
    fops_T=Vector{joAbstractLinearOperator}(undef,0)
    fops_A=Vector{joAbstractLinearOperator}(undef,0)
    fops_C=Vector{joAbstractLinearOperator}(undef,0)
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

