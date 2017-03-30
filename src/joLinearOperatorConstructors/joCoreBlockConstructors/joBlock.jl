############################################################
# joBlock ##############################################
############################################################

export joBlock, joBlockException

type joBlockException <: Exception
    msg :: String
end

############################################################
## outer constructors

"""
Block operator composed from different square JOLI operators

    joBlock(rows::Tuple{Vararg{Int}},ops::joAbstractLinearOperator...;
        weights::AbstractVector,name::String)

# Example
    a=rand(Complex{Float64},4,4);
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
    b=rand(Complex{Float64},4,8);
    B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
    c=rand(Complex{Float64},6,6);
    C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64},name="C")
    d=rand(Complex{Float64},6,6);
    D=joMatrix(d;DDT=Complex{Float32},RDT=Complex{Float64},name="D")
    # either
        S=joBlock([2,2],A,B,C,D) # basic stack in function syntax
    # or
        S=[A B; C D] # basic stack in [] syntax
    w=rand(Complex{Float64},4)
    S=joBlock(A,B,C;weights=w) # weighted stack

# Notes
- operators are to be given in row-major order
- all operators in a row must have the same # of rows (M)
- sum of Ns for operators in each row must be the same
- all given operators must have same domain/range types
- the domain/range types of joBlock are equal to domain/range types of the given operators

"""
function joBlock{RVDT<:Integer,WDT<:Number}(rows::Vector{RVDT},ops::joAbstractLinearOperator...;
           weights::AbstractVector{WDT}=zeros(0),name::String="joBlock")
    isempty(ops) && throw(joBlockException("empty argument list"))
    l=length(ops)
    sum(rows)==l || throw(joBlockException("sum of operators in the rows does not match # of operators"))
    r=length(rows)
    for i=1:l
        deltype(ops[i])==deltype(ops[1]) || throw(joBlockException("domain type mismatch for $i operator"))
        reltype(ops[i])==reltype(ops[1]) || throw(joBlockException("range type mismatch for $i operator"))
    end
    i=0
    mm=1
    for j=1:r
        for k=1:rows[j]
            i+=1
            ops[i].m==ops[mm].m || throw(joBlockException("size mismatch (M) for $k operator in row $j"))
        end
        mm+=rows[j]
    end
    (length(weights)==l || length(weights)==0) || throw(joBlockException("lenght of weights vector does not match number of operators"))
    ws=Base.deepcopy(weights)
    rm=zeros(Int,r)
    rn=zeros(Int,r)
    ms=zeros(Int,l)
    ns=zeros(Int,l)
    mo=zeros(Int,l)
    no=zeros(Int,l)
    i=0
    mm=1
    ro=0
    for j=1:r
        co=0
        rm[j]=ops[mm].m
        for k=1:rows[j]
            i+=1
            ms[i]=ops[mm].m
            ns[i]=ops[i].n
            mo[i]=ro
            no[i]=co
            rn[j]+=ops[i].n
            co+=ops[i].n
        end
        rn[j]==rn[1] || throw(joBlockException("size mismatch (N) for operators in row $j"))
        ro+=ops[mm].m
        mm+=rows[j]
    end
    m=sum(rm)
    n=rn[1]
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

