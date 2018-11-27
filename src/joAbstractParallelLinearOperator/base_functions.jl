############################################################
## joAbstractParallelLinearOperator(s) - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractParallelLinearOperator{DDT,RDT}) where {DDT,RDT} = promote_type(DDT,RDT)

# deltype(jo)
deltype(A::joAbstractParallelLinearOperator{DDT,RDT}) where {DDT,RDT} = DDT

# reltype(jo)
reltype(A::joAbstractParallelLinearOperator{DDT,RDT}) where {DDT,RDT} = RDT

# show(jo)
show(A::joAbstractParallelLinearOperator) = println((typeof(A),A.name,(A.m,A.n),A.nvc))

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
	elseif ind==3
		return A.nvc
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
conj(A::joDALinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDALinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.dst_in, A.dst_out, A.fclean, A.rclean
        )
conj(A::joDAdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAdistributingLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.dst, A.gclean
        )
conj(A::joDAgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAgatheringLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.dst, A.gclean
        )

# transpose(jo)
transpose(A::joDALinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDALinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.dst_out, A.dst_in, A.rclean, A.fclean
        )
transpose(A::joDAdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAgatheringLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.dst, A.gclean
        )
transpose(A::joDAgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAdistributingLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.dst, A.gclean
        )

# adjoint(jo)
adjoint(A::joDALinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDALinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.dst_out, A.dst_in, A.rclean, A.fclean
        )
adjoint(A::joDAdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAgatheringLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.dst, A.gclean
        )
adjoint(A::joDAgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAdistributingLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.dst, A.gclean
        )

# isreal(jo)
isreal(A :: joAbstractParallelLinearOperator{DDT,RDT}) where {DDT,RDT} = (DDT<:Real && RDT<:Real)

# issymmetric(jo)

# ishermitian(jo)

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)

# *(jo,mvec)

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

