############################################################
# joBlockDiag ##############################################
############################################################

export joBlockDiag, joBlockDiagException

type joBlockDiagException <: Exception
    msg :: String
end

############################################################
## outer constructors

"""
Block-diagonal operator composed from different square JOLI operators

    joBlockDiag(ops::joAbstractLinearOperator...;weights::AbstractVector,name::String)

# Example
    a=rand(Complex{Float64},4,4);
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
    b=rand(Complex{Float64},8,8);
    B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
    c=rand(Complex{Float64},6,6);
    C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64},name="C")
    BD=joBlockDiag(A,B,C) # basic block diagonal
    w=rand(Complex{Float64},3)
    BD=joBlockDiag(A,B,C;weights=w) # weighted block diagonal

# Notes
- all operators must be square (M(i)==N(i))
- all given operators must have same domain/range types
- the domain/range types of joBlockDiag are equal to domain/range types of the given operators

"""
function joBlockDiag{WDT<:Number}(ops::joAbstractLinearOperator...;
           weights::AbstractVector{WDT}=zeros(0),name::String="joBlockDiag")
    isempty(ops) && throw(joBlockDiagException("empty argument list"))
    l=length(ops)
    for i=1:l
        ops[i].m==ops[i].n || throw(joBlockDiagException("non-square $i operator"))
        deltype(ops[i])==deltype(ops[1]) || throw(joBlockDiagException("domain type mismatch for $i operator"))
        reltype(ops[i])==reltype(ops[1]) || throw(joBlockDiagException("range type mismatch for $i operator"))
    end
    (length(weights)==l || length(weights)==0) || throw(joBlockDiagException("lenght of weights vector does not match number of operators"))
    ws=Base.deepcopy(weights)
    ms=zeros(Int,l)
    ns=zeros(Int,l)
    mo=zeros(Int,l)
    no=zeros(Int,l)
    for i=1:l
        ms[i]=ops[i].m
        ns[i]=ops[i].n
    end
    for i=2:l
        mo[i]=mo[i-1]+ms[i-1]
        no[i]=no[i-1]+ns[i-1]
    end
    m=sum(ms)
    n=sum(ns)
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
    return joCoreBlock{deltype(fops[1]),reltype(fops[1])}(name*"($l)",m,n,l,ms,ns,mo,no,ws,
                      fops,fops_T,fops_CT,fops_C,iops,iops_T,iops_CT,iops_C)
end
"""
Block-diagonal operator composed from l-times replicated square JOLI operator

    joBlockDiag(l::Int,op::joAbstractLinearOperator;weights::AbstractVector,name::String)

# Example
    a=rand(Complex{Float64},4,4);
    w=rand(Complex{Float64},3)
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
    BD=joBlockDiag(3,A) # basic block diagonal
    BD=joBlockDiag(3,A;weights=w) # weighted block diagonal

# Notes
- all given operators must have same domain/range types
- the domain/range types of joBlockDiag are equal to domain/range types of the given operators

"""
function joBlockDiag{WDT<:Number}(l::Integer,op::joAbstractLinearOperator;
           weights::AbstractVector{WDT}=zeros(0),name::String="joBlockDiag")
    op.m==op.n || throw(joBlockDiagException("non-square operator"))
    (length(weights)==l || length(weights)==0) || throw(joBlockDiagException("lenght of weights vector does not match number of operators"))
    ws=Base.deepcopy(weights)
    ms=zeros(Int,l)
    ns=zeros(Int,l)
    mo=zeros(Int,l)
    no=zeros(Int,l)
    for i=1:l
        ms[i]=op.m
        ns[i]=op.n
    end
    for i=2:l
        mo[i]=mo[i-1]+ms[i-1]
        no[i]=no[i-1]+ns[i-1]
    end
    m=l*op.m
    n=l*op.n
    weighted=(length(weights)==l)
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
            push!(fops,ws[i]*op)
            push!(fops_T,ws[i]*op.')
            push!(fops_CT,conj(ws[i])*op')
            push!(fops_C,conj(ws[i])*conj(op))
        else
            push!(fops,op)
            push!(fops_T,op.')
            push!(fops_CT,op')
            push!(fops_C,conj(op))
        end
    end
    return joCoreBlock{deltype(op),reltype(op)}(name*"($l)",m,n,l,ms,ns,mo,no,ws,
                      fops,fops_T,fops_CT,fops_C,iops,iops_T,iops_CT,iops_C)
end

