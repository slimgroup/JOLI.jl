############################################################
# joBlockDiag ##############################################
############################################################

##################
## type definition

export joBlockDiag, joBlockDiagException

immutable joBlockDiag{DDT,RDT} <: joAbstractLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    l::Integer
    ms::Vector{Integer}
    ns::Vector{Integer}
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

type joBlockDiagException <: Exception
    msg :: String
end

############################################################
## outer constructors

"""
    joBlockDiag(ops::joAbstractLinearOperator...;weights::AbstractVector)

Block-diagonal operator composed from diffrent square JOLI operators

# Example
    a=rand(Complex{Float64},4,4);
    w=rand(Complex{Float64},3)
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
    b=rand(Complex{Float64},8,8);
    B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
    c=rand(Complex{Float64},6,6);
    C=joMatrix(c;DDT=Complex{Float62},RDT=Complex{Float64},name="C")
    BD=joBlockDiag(A,B,C) # basic block diagonal
    BD=joBlockDiag(A,B,C;weights=w) # weighted block diagonal

# Notes
- all given operators must have same domain/range types
- the domain/range types of joBlockDiag are equal to domain/range types of the given operators

"""
function joBlockDiag{WDT<:Number}(ops::joAbstractLinearOperator...;weights::AbstractVector{WDT}=zeros(0))
    isempty(ops) && throw(joBlockDiagException("empty argument list"))
    m=0
    n=0
    l=length(ops)
    (length(weights)==l || length(weights)==0) || throw(joBlockDiagException("lenght of weights vector does not match number of operators"))
    weighted=(length(weights)==l)
    ms=Vector{Integer}(0)
    ns=Vector{Integer}(0)
    fops=Vector{joAbstractLinearOperator}(0)
    fops_T=Vector{joAbstractLinearOperator}(0)
    fops_CT=Vector{joAbstractLinearOperator}(0)
    fops_C=Vector{joAbstractLinearOperator}(0)
    iops=Vector{joAbstractLinearOperator}(0)
    iops_T=Vector{joAbstractLinearOperator}(0)
    iops_CT=Vector{joAbstractLinearOperator}(0)
    iops_C=Vector{joAbstractLinearOperator}(0)
    for i=1:l
        deltype(ops[i])==deltype(ops[1]) || throw(joBlockDiagException("domain type mismatch for $i operator"))
        reltype(ops[i])==reltype(ops[1]) || throw(joBlockDiagException("range type mismatch for $i operator"))
        ops[i].m==ops[i].n || throw(joBlockDiagException("non-square $i operator"))
        m+=ops[i].m
        push!(ms,ops[i].m)
        n+=ops[i].n
        push!(ns,ops[i].n)
        if weighted
            push!(fops,weights[i]*ops[i])
            push!(fops_T,weights[i]*ops[i].')
            push!(fops_CT,conj(weights[i])*ops[i]')
            push!(fops_C,conj(weights[i])*conj(ops[i]))
        else
            push!(fops,ops[i])
            push!(fops_T,ops[i].')
            push!(fops_CT,ops[i]')
            push!(fops_C,conj(ops[i]))
        end
    end
    return joBlockDiag{deltype(fops[l]),reltype(fops[1])}("joBlockDiag($l)",m,n,l,ms,ns,weights,
                      fops,fops_T,fops_CT,fops_C,iops,iops_T,iops_CT,iops_C)
end
"""
    joBlockDiag(l::Integer,op::joAbstractLinearOperator;weights::AbstractVector)

Block-diagonal operator composed from l-times replicated square JOLI operator

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
function joBlockDiag{WDT<:Number}(l::Integer,op::joAbstractLinearOperator;weights::AbstractVector{WDT}=zeros(0))
    op.m==op.n || throw(joBlockDiagException("non-square operator"))
    m=l*op.m
    n=l*op.n
    (length(weights)==l || length(weights)==0) || throw(joBlockDiagException("lenght of weights vector does not match number of operators"))
    weighted=(length(weights)==l)
    ms=Vector{Integer}(0)
    ns=Vector{Integer}(0)
    fops=Vector{joAbstractLinearOperator}(0)
    fops_T=Vector{joAbstractLinearOperator}(0)
    fops_CT=Vector{joAbstractLinearOperator}(0)
    fops_C=Vector{joAbstractLinearOperator}(0)
    iops=Vector{joAbstractLinearOperator}(0)
    iops_T=Vector{joAbstractLinearOperator}(0)
    iops_CT=Vector{joAbstractLinearOperator}(0)
    iops_C=Vector{joAbstractLinearOperator}(0)
    for i=1:l
        push!(ms,op.m)
        push!(ns,op.n)
        if weighted
            push!(fops,weights[i]*op)
            push!(fops_T,weights[i]*op.')
            push!(fops_CT,conj(weights[i])*op')
            push!(fops_C,conj(weights[i])*conj(op))
        else
            push!(fops,op)
            push!(fops_T,op.')
            push!(fops_CT,op')
            push!(fops_C,conj(op))
        end
    end
    return joBlockDiag{deltype(op),reltype(op)}("joBlockDiag($l)",m,n,l,ms,ns,weights,
                      fops,fops_T,fops_CT,fops_C,iops,iops_T,iops_CT,iops_C)
end

############################
## overloaded Base functions

# showall(jo)
function showall(A::joBlockDiag)
    println("# joBlockDiag")
    println("-     name: ",A.name)
    println("-     type: ",typeof(A))
    println("-     size: ",size(A))
    println("- # of ops: ",A.l)
    println("-  m-sizes: ",A.ms)
    println("-  n-sizes: ",A.ns)
    println("- weigthts: ",A.ws)
    for i=1:A.l
    println("*     op $i: ",(A.fop[i].name,typeof(A.fop[i]),A.fop[i].m,A.fop[i].n))
    end
end

# conj(jo)
conj{DDT,RDT}(A::joBlockDiag{DDT,RDT}) =
    joBlockDiag{DDT,RDT}("(conj("*A.name*"))",
        A.m,A.n,A.l,A.ms,A.ns,A.ws,
        A.fop_C,A.fop_CT,A.fop_T,A.fop,
        A.iop_C,A.iop_CT,A.iop_T,A.iop)

# transpose(jo)
transpose{DDT,RDT}(A::joBlockDiag{DDT,RDT}) =
    joBlockDiag{RDT,DDT}("("*A.name*".')",
        A.n,A.m,A.l,A.ns,A.ms,A.ws,
        A.fop_T,A.fop,A.fop_C,A.fop_CT,
        A.iop_T,A.iop,A.iop_C,A.iop_CT)

# ctranspose(jo)
ctranspose{DDT,RDT}(A::joBlockDiag{DDT,RDT}) =
    joBlockDiag{RDT,DDT}("("*A.name*"')",
        A.n,A.m,A.l,A.ns,A.ms,A.ws,
        A.fop_CT,A.fop_C,A.fop,A.fop_T,
        A.iop_CT,A.iop_C,A.iop,A.iop_T)

############################################################
## overloaded Base *(...jo...)

# *(jo,vec)
function *{ADDT,ARDT}(A::joBlockDiag{ADDT,ARDT},v::AbstractVector{ADDT})
    size(A,2) == size(v,1) || throw(joBlockDiagException("shape mismatch"))
    V=zeros(ARDT,A.n)
    s::Integer=0
    e::Integer=0
    for i=1:1:A.l
        s=e+1
        e=e+A.fop[i].n
        V[s:e]=A.fop[i]*v[s:e]
    end
    return V
end

# *(jo,mvec)
#function *{AEDT,mvDT:<Number}(A::joBlockDiag{AEDT},mv::AbstractMatrix{mvDT})
    #size(A, 2) == size(mv, 1) || throw(joBlockDiagException("shape mismatch"))
    #MV=zeros(promote_type(AEDT,eltype(mv)),size(A,1),size(mv,2))
    #for i=1:size(mv,2)
        #MV[:,i]=A*mv[:,i]
    #end
    #return MV
#end

