############################################################
## joAbstractFosterLinearOperator - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractFosterLinearOperator{DDT,RDT}) where {DDT,RDT} = promote_type(DDT,RDT)

# deltype(jo)
deltype(A::joAbstractFosterLinearOperator{DDT,RDT}) where {DDT,RDT} = DDT

# reltype(jo)
reltype(A::joAbstractFosterLinearOperator{DDT,RDT}) where {DDT,RDT} = RDT

# show(jo)
show(A::joAbstractFosterLinearOperator) = println((typeof(A),A.name,A.m,A.n))

# display(jo)
display(A::joAbstractFosterLinearOperator) = show(A)

# size(jo)
size(A::joAbstractFosterLinearOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joAbstractFosterLinearOperator,ind::Integer)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	else
		throw(joAbstractFosterLinearOperatorException("invalid index"))
	end
end

# length(jo)
length(A::joAbstractFosterLinearOperator) = A.m*A.n

# jo_full(jo)

# norm(jo)

# real(jo)

# imag(jo)

# conj(jo)

# transpose(jo)

# adjoint(jo)

# isreal(jo)
isreal(A :: joAbstractFosterLinearOperator{DDT,RDT}) where {DDT,RDT} = (DDT<:Real && RDT<:Real)

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

############################################################
## overloaded Base +(...jo...)

# +(jo)

# +(jo,jo)

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)

# +(num,jo)

############################################################
## overloaded Base -(...jo...)

# -(jo)

# -(jo,jo)

# -(jo,mvec)

# -(mvec,jo)

# -(jo,vec)

# -(vec,jo)

# -(jo,num)

# -(num,jo)

############################################################
## overloaded Base .*(...jo...)

# .*(num,jo)
Base.Broadcast.broadcasted(::typeof(*),a::Number,A::joAbstractFosterLinearOperator) = a*A
Base.Broadcast.broadcasted(::typeof(*),a::joNumber,A::joAbstractFosterLinearOperator) = a*A

# .*(jo,num)
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractFosterLinearOperator,a::Number) = a*A
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractFosterLinearOperator,a::joNumber) = a*A

############################################################
## overloaded Base .\(...jo...)

############################################################
## overloaded Base .+(...jo...)

# .+(jo,num)
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractFosterLinearOperator,b::Number) = A+b
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractFosterLinearOperator,b::joNumber) = A+b

# .+(num,jo)
Base.Broadcast.broadcasted(::typeof(+),b::Number,A::joAbstractFosterLinearOperator) = A+b
Base.Broadcast.broadcasted(::typeof(+),b::joNumber,A::joAbstractFosterLinearOperator) = A+b

############################################################
## overloaded Base .-(...jo...)

# .-(jo,num)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractFosterLinearOperator,b::Number) = A+(-b)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractFosterLinearOperator,b::joNumber) = A+(-b)

# .-(num,jo)
Base.Broadcast.broadcasted(::typeof(-),b::Number,A::joAbstractFosterLinearOperator) = -A+b
Base.Broadcast.broadcasted(::typeof(-),b::joNumber,A::joAbstractFosterLinearOperator) = -A+b

############################################################
## overloaded Base block methods

# hcat(...jo...)

# vcat(...jo...)

# hvcat(...jo...)

############################################################
## overloaded LinearAlgebra functions

# mul!(...,jo,...)

# ldiv!(...,jo,...)

