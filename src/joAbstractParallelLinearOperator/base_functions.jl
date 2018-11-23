############################################################
## joAbstractParallelLinearOperator(s) - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractParallelLinearOperator{DDT,RDT}) where {DDT,RDT} = promote_type(DDT,RDT)

# deltype(jo)
deltype(A::joAbstractParallelLinearOperator{DDT,RDT}) where {DDT,RDT} = DDT

# reltype(jo)
reltype(A::joAbstractParallelLinearOperator{DDT,RDT}) where {DDT,RDT} = RDT

# show(jo)
show(A::joAbstractParallelLinearOperator) = println((typeof(A),A.name,A.m,A.n))

# display(jo)
display(A::joAbstractParallelLinearOperator) = show(A)

# size(jo)
size(A::joAbstractParallelLinearOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joAbstractParallelLinearOperator,ind::Integer)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	else
		throw(joAbstractParallelLinearOperatorException("invalid index"))
	end
end

# length(jo)
length(A::joAbstractParallelLinearOperator) = A.m*A.n

# jo_full(jo)

# norm(jo)

# real(jo)

# imag(jo)

# conj(jo)

# transpose(jo)

# adjoint(jo)

# isreal(jo)
isreal(A :: joAbstractParallelLinearOperator{DDT,RDT}) where {DDT,RDT} = (DDT<:Real && RDT<:Real)

# issymmetric(jo)

# ishermitian(jo)

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)

# *(jo,mvec)
function *(A::joDALinearOperator{ADDT,ARDT},mv::DArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joAbstractParallelLinearOperatorException("shape mismatch"))
    length(mv.cuts[1])==2 || throw(joAbstractParallelLinearOperatorException("*(jo,mv::DArray): DArray must be distributed only over 2nd dimension"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,DAmvec):",A.name,typeof(A),mvDT]," / "))
    parts=dparts(mv)
    dMV=joDAdistributor(WorkerPool(vec(mv.pids)),(A.m,size(mv,2)),2;DT=ARDT,parts=parts)
    MV=dalloc(dMV)
    spmd(joSPMDutils.jo_x_DAmv!,A,mv,MV,pids=mv.pids)
    return MV
end

# *(mvec,jo)

# *(jo,vec)

# *(vec,jo)

# *(num,jo)

# *(jo,num)

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)

# \(jo,mvec)

# \(mvec,jo)

# \(jo,vec)

# \(vec,jo)

# \(num,jo)

# \(jo,num)
#\{ADDT,ARDT}(A::joAbstractParallelLinearOperator{ADDT,ARDT},a::Number) = inv(a)*A
#\{ADDT,ARDT}(A::joAbstractParallelLinearOperator{ADDT,ARDT},a::joNumber{ADDT,ARDT}) = inv(a)*A

############################################################
## overloaded Base +(...jo...)

# +(jo)
+(A::joAbstractParallelLinearOperator) = A

# +(jo,jo)

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)

# +(num,jo)
+(b::Number,A::joAbstractParallelLinearOperator{ADDT,ARDT}) where {ADDT,ARDT} = A+b
+(b::joNumber{ADDT,ARDT},A::joAbstractParallelLinearOperator{ADDT,ARDT}) where {ADDT,ARDT} = A+b

############################################################
## overloaded Base -(...jo...)

# -(jo)

# -(jo,jo)
-(A::joAbstractParallelLinearOperator,B::joAbstractParallelLinearOperator) = A+(-B)

# -(jo,mvec)

# -(mvec,jo)

# -(jo,vec)

# -(vec,jo)

# -(jo,num)
-(A::joAbstractParallelLinearOperator,b::Number) = A+(-b)
-(A::joAbstractParallelLinearOperator,b::joNumber) = A+(-b)

# -(num,jo)
-(b::Number,A::joAbstractParallelLinearOperator) = -A+b
-(b::joNumber,A::joAbstractParallelLinearOperator) = -A+b

############################################################
## overloaded Base .*(...jo...)

# .*(num,jo)
Base.Broadcast.broadcasted(::typeof(*),a::Number,A::joAbstractParallelLinearOperator) = a*A
Base.Broadcast.broadcasted(::typeof(*),a::joNumber,A::joAbstractParallelLinearOperator) = a*A

# .*(jo,num)
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractParallelLinearOperator,a::Number) = a*A
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractParallelLinearOperator,a::joNumber) = a*A

############################################################
## overloaded Base .\(...jo...)

############################################################
## overloaded Base .+(...jo...)

# .+(jo,num)
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractParallelLinearOperator,b::Number) = A+b
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractParallelLinearOperator,b::joNumber) = A+b

# .+(num,jo)
Base.Broadcast.broadcasted(::typeof(+),b::Number,A::joAbstractParallelLinearOperator) = A+b
Base.Broadcast.broadcasted(::typeof(+),b::joNumber,A::joAbstractParallelLinearOperator) = A+b

############################################################
## overloaded Base .-(...jo...)

# .-(jo,num)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractParallelLinearOperator,b::Number) = A+(-b)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractParallelLinearOperator,b::joNumber) = A+(-b)

# .-(num,jo)
Base.Broadcast.broadcasted(::typeof(-),b::Number,A::joAbstractParallelLinearOperator) = -A+b
Base.Broadcast.broadcasted(::typeof(-),b::joNumber,A::joAbstractParallelLinearOperator) = -A+b

############################################################
## overloaded Base block methods

# hcat(...jo...)

# vcat(...jo...)

# hvcat(...jo...)

############################################################
## overloaded LinearAlgebra functions

# mul!(...,jo,...)

# ldiv!(...,jo,...)

