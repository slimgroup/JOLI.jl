############################################################
# joStack ##############################################
############################################################

export joStack, joStackException

struct joStackException <: Exception
    msg :: String
end

############################################################
## outer constructors

"""
Stack operator composed from different square JOLI operators

    joStack(ops::joAbstractLinearOperator...;
        weights::AbstractVector,name::String)

# Example
    a=rand(Complex{Float64},4,4);
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
    b=rand(Complex{Float64},8,4);
    B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
    c=rand(Complex{Float64},6,4);
    C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64},name="C")
    # either
        S=joStack(A,B,C) # basic stack in function syntax
    # or
        S=[A; B; C] # basic stack in [] syntax
    w=rand(Complex{Float64},3)
    S=joStack(A,B,C;weights=w) # weighted stack

# Notes
- all operators must have the same # of columns (N)
- all given operators must have same domain/range types
- the domain/range types of joStack are equal to domain/range types of the given operators

"""
function joStack(ops::joAbstractLinearOperator...;
           weights::AbstractVector{WDT}=zeros(0),name::String="joStack") where {WDT<:Number}
    isempty(ops) && throw(joStackException("empty argument list"))
    l=length(ops)
    for i=1:l
        ops[i].n==ops[1].n || throw(joStackException("size mismatch for $i operator"))
        deltype(ops[i])==deltype(ops[1]) || throw(joStackException("domain type mismatch for $i operator"))
        reltype(ops[i])==reltype(ops[1]) || throw(joStackException("range type mismatch for $i operator"))
    end
    (length(weights)==l || length(weights)==0) || throw(joStackException("lenght of weights vector does not match number of operators"))
    ws=Base.deepcopy(weights)
    ms=zeros(Int,l)
    ns=zeros(Int,l)
    mo=zeros(Int,l)
    no=zeros(Int,l)
    for i=1:l
        ms[i]=ops[i].m
        ns[i]=ops[1].n
    end
    for i=2:l
        mo[i]=mo[i-1]+ms[i-1]
    end
    m=sum(ms)
    n=ops[1].n
    weighted=(length(ws)==l)
    fops=Vector{joAbstractLinearOperator}(0)
    fops_T=Vector{joAbstractLinearOperator}(0)
    fops_CT=Vector{joAbstractLinearOperator}(0)
    fops_C=Vector{joAbstractLinearOperator}(0)
    for i=1:l
        if weighted
            push!(fops,ws[i]*ops[i])
            push!(fops_T,ws[i]*transpose(ops[i]))
            push!(fops_CT,conj(ws[i])*adjoint(ops[i]))
            push!(fops_C,conj(ws[i])*conj(ops[i]))
        else
            push!(fops,ops[i])
            push!(fops_T,transpose(ops[i]))
            push!(fops_CT,adjoint(ops[i]))
            push!(fops_C,conj(ops[i]))
        end
    end
    return joCoreBlock{deltype(fops[1]),reltype(fops[1])}(name*"($l)",m,n,l,ms,ns,mo,no,ws,
                      fops,fops_T,fops_CT,fops_C,@joNF,@joNF,@joNF,@joNF)
end
"""
Stack operator composed from l-times replicated square JOLI operator

    joStack(l::Int,op::joAbstractLinearOperator;
        weights::AbstractVector,name::String)

# Example
    a=rand(Complex{Float64},4,4);
    w=rand(Complex{Float64},3)
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
    S=joStack(3,A) # basic stack
    S=joStack(3,A;weights=w) # weighted stack

# Notes
- all operators must have the same # of columns (N)
- all given operators must have same domain/range types
- the domain/range types of joStack are equal to domain/range types of the given operators

"""
function joStack(l::Integer,op::joAbstractLinearOperator;
           weights::AbstractVector{WDT}=zeros(0),name::String="joStack") where {WDT<:Number}
    (length(weights)==l || length(weights)==0) || throw(joStackException("lenght of weights vector does not match number of operators"))
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
    end
    m=l*op.m
    n=op.n
    weighted=(length(weights)==l)
    fops=Vector{joAbstractLinearOperator}(0)
    fops_T=Vector{joAbstractLinearOperator}(0)
    fops_CT=Vector{joAbstractLinearOperator}(0)
    fops_C=Vector{joAbstractLinearOperator}(0)
    for i=1:l
        if weighted
            push!(fops,ws[i]*op)
            push!(fops_T,ws[i]*transpose(op))
            push!(fops_CT,conj(ws[i])*adjoint(op))
            push!(fops_C,conj(ws[i])*conj(op))
        else
            push!(fops,op)
            push!(fops_T,transpose(op))
            push!(fops_CT,adjoint(op))
            push!(fops_C,conj(op))
        end
    end
    return joCoreBlock{deltype(op),reltype(op)}(name*"($l)",m,n,l,ms,ns,mo,no,ws,
                      fops,fops_T,fops_CT,fops_C,@joNF,@joNF,@joNF,@joNF)
end

