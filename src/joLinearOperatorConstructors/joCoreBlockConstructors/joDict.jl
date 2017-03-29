############################################################
# joDict ##############################################
############################################################

export joDict, joDictException

type joDictException <: Exception
    msg :: String
end

############################################################
## outer constructors

"""
Dictionary operator composed from different square JOLI operators

    joDict(ops::joAbstractLinearOperator...;weights::AbstractVector,name::String)

# Example
    a=rand(Complex{Float64},4,4);
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
    b=rand(Complex{Float64},4,8);
    B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
    c=rand(Complex{Float64},4,6);
    C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64},name="C")
    # either
        D=joDict(A,B,C) # basic dictionary in function syntax
    #or
        D=[A B C] # basic dictionary in [] syntax
    w=rand(Complex{Float64},3)
    D=joDict(A,B,C;weights=w) # weighted dictionary

# Notes
- all operators must have the same # of rows (M)
- all given operators must have same domain/range types
- the domain/range types of joDict are equal to domain/range types of the given operators

"""
function joDict{WDT<:Number}(ops::joAbstractLinearOperator...;
           weights::AbstractVector{WDT}=zeros(0),name::String="joDict")
    isempty(ops) && throw(joDictException("empty argument list"))
    l=length(ops)
    for i=1:l
        ops[i].m==ops[1].m || throw(joDictException("size mismatch for $i operator"))
        deltype(ops[i])==deltype(ops[1]) || throw(joDictException("domain type mismatch for $i operator"))
        reltype(ops[i])==reltype(ops[1]) || throw(joDictException("range type mismatch for $i operator"))
    end
    (length(weights)==l || length(weights)==0) || throw(joDictException("lenght of weights vector does not match number of operators"))
    ws=Base.deepcopy(weights)
    ms=zeros(Int,l)
    ns=zeros(Int,l)
    mo=zeros(Int,l)
    no=zeros(Int,l)
    for i=1:l
        ms[i]=ops[1].m
        ns[i]=ops[i].n
    end
    for i=2:l
        no[i]=no[i-1]+ns[i-1]
    end
    m=ops[1].m
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
Dictionary operator composed from l-times replicated square JOLI operator

    joDict(l::Int,op::joAbstractLinearOperator;weights::AbstractVector,name::String)

# Example
    a=rand(Complex{Float64},4,4);
    w=rand(Complex{Float64},3)
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
    D=joDict(3,A) # basic dictionary
    D=joDict(3,A;weights=w) # weighted dictionary

# Notes
- all operators must have the same # of rows (M)
- all given operators must have same domain/range types
- the domain/range types of joDict are equal to domain/range types of the given operators

"""
function joDict{WDT<:Number}(l::Integer,op::joAbstractLinearOperator;
           weights::AbstractVector{WDT}=zeros(0),name::String="joDict")
    (length(weights)==l || length(weights)==0) || throw(joDictException("lenght of weights vector does not match number of operators"))
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
        no[i]=no[i-1]+ns[i-1]
    end
    m=op.m
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

