############################################################
## joAbstractLinearOperator - overloaded Base functions

# eltype(jo)
eltype{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT}) = promote_type(DDT,RDT)

# deltype(jo)
deltype{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT}) = DDT

# reltype(jo)
reltype{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT}) = RDT

# show(jo)
show(A::joAbstractLinearOperator) = println((typeof(A),A.name,A.m,A.n))

# showall(jo)
showall(A::joAbstractLinearOperator) = println((typeof(A),A.name,A.m,A.n))

# display(jo)
display(A::joAbstractLinearOperator) = showall(A)

# size(jo)
size(A::joAbstractLinearOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joAbstractLinearOperator,ind::Integer)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	else
		throw(joAbstractLinearOperatorException("invalid index"))
	end
end

# length(jo)
length(A::joAbstractLinearOperator) = A.m*A.n

# full(jo)
full{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT}) = A*eye(DDT,A.n)

# norm(jo)
norm(A::joAbstractLinearOperator,p::Real=2) = norm(elements(A),p)

# vecnorm(jo)
vecnorm(A::joAbstractLinearOperator,p::Real=2) = vecnorm(elements(A),p)

# real(jo)
#real{DDT<:Real,RDT<:Real}(A::joAbstractLinearOperator{DDT,RDT}) = A
function real{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT})
    throw(joAbstractLinearOperatorException("real(jo) not implemented"))
end
joReal{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT}) = real(A)

# imag(jo)
#imag{DDT<:Real,RDT<:Real}(A::joAbstractLinearOperator{DDT,RDT}) = joZeros(A.m,A.n,DDT,RDT)
function imag{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT})
    throw(joAbstractLinearOperatorException("imag(jo) not implemented"))
end
joImag{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT}) = imag(A)

# conj(jo)
joConj(A::joAbstractLinearOperator) = conj(A)

# transpose(jo)

# ctranspose(jo)

# isreal(jo)
isreal{DDT,RDT}(A :: joAbstractLinearOperator{DDT,RDT}) = (DDT<:Real && RDT<:Real)

# issymmetric(jo)
issymmetric{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT}) =
    (A.m == A.n && (vecnorm(elements(A)-elements(A.')) < joTol))

# ishermitian(jo)
ishermitian{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT}) =
    (A.m == A.n && (vecnorm(elements(A)-elements(A')) < joTol))

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
function *{ARDT,BDDT,CDT}(A::joAbstractLinearOperator{CDT,ARDT},B::joAbstractLinearOperator{BDDT,CDT})
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("shape mismatch"))
    return joLinearOperator{BDDT,ARDT}("("*A.name*"*"*B.name*")",size(A,1),size(B,2),
        v1->A*(B*v1),
        v2->B.'*(A.'*v2),
        v3->B'*(A'*v3),
        v4->conj(A)*(conj(B)*v4),
        @joNF, @joNF, @joNF, @joNF
        )
end

# *(jo,mvec)

# *(mvec,jo)

# *(jo,vec)

# *(vec,jo)

# *(num,jo)
function *{ADDT,ARDT}(a::Number,A::joAbstractLinearOperator{ADDT,ARDT})
    return joLinearOperator{ADDT,ARDT}("(N*"*A.name*")",A.m,A.n,
        v1->jo_convert(ARDT,a*(A*v1),false),
        v2->jo_convert(ADDT,a*(A.'*v2),false),
        v3->jo_convert(ADDT,conj(a)*(A'*v3),false),
        v4->jo_convert(ARDT,conj(a)*(conj(A)*v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
end
function *{ADDT,ARDT}(a::joNumber{ADDT,ARDT},A::joAbstractLinearOperator{ADDT,ARDT})
    return joLinearOperator{ADDT,ARDT}("(N*"*A.name*")",A.m,A.n,
        v1->jo_convert(ARDT,a.rdt*(A*v1),false),
        v2->jo_convert(ADDT,a.ddt*(A.'*v2),false),
        v3->jo_convert(ADDT,conj(a.ddt)*(A'*v3),false),
        v4->jo_convert(ARDT,conj(a.rdt)*(conj(A)*v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
end

# *(jo,num)
*{ADDT,ARDT}(A::joAbstractLinearOperator{ADDT,ARDT},a::Number) = a*A
*{ADDT,ARDT}(A::joAbstractLinearOperator{ADDT,ARDT},a::joNumber{ADDT,ARDT}) = a*A

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)

# \(jo,mvec)

# \(mvec,jo)

# \(jo,vec)

# \(vec,jo)

# \(num,jo)

# \(jo,num)
#\{ADDT,ARDT}(A::joAbstractLinearOperator{ADDT,ARDT},a::Number) = inv(a)*A
#\{ADDT,ARDT}(A::joAbstractLinearOperator{ADDT,ARDT},a::joNumber{ADDT,ARDT}) = inv(a)*A

############################################################
## overloaded Base +(...jo...)

# +(jo)
+(A::joAbstractLinearOperator) = A

# +(jo,jo)
function +{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT},B::joAbstractLinearOperator{DDT,RDT})
    size(A) == size(B) || throw(joAbstractLinearOperatorException("shape mismatch"))
    return joLinearOperator{DDT,RDT}("("*A.name*"+"*B.name*")",size(A,1),size(B,2),
        v1->A*v1+B*v1,
        v2->A.'*v2+B.'*v2,
        v3->A'*v3+B'*v3,
        v4->conj(A)*v4+conj(B)*v4,
        @joNF, @joNF, @joNF, @joNF
        )
end

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)
function +{ADDT,ARDT}(A::joAbstractLinearOperator{ADDT,ARDT},b::Number)
    return joLinearOperator{ADDT,ARDT}("("*A.name*"+N)",size(A,1),size(A,2),
        v1->A*v1+joConstants(A.m,A.n,b;DDT=ADDT,RDT=ARDT)*v1,
        v2->A.'*v2+joConstants(A.n,A.m,b;DDT=ARDT,RDT=ADDT)*v2,
        v3->A'*v3+joConstants(A.n,A.m,conj(b);DDT=ARDT,RDT=ADDT)*v3,
        v4->conj(A)*v4+joConstants(A.m,A.n,conj(b);DDT=ADDT,RDT=ARDT)*v4,
        @joNF, @joNF, @joNF, @joNF
        )
end
function +{ADDT,ARDT}(A::joAbstractLinearOperator{ADDT,ARDT},b::joNumber{ADDT,ARDT})
    return joLinearOperator{ADDT,ARDT}("("*A.name*"+N)",size(A,1),size(A,2),
        v1->A*v1+joConstants(A.m,A.n,b.rdt;DDT=ADDT,RDT=ARDT)*v1,
        v2->A.'*v2+joConstants(A.n,A.m,b.ddt;DDT=ARDT,RDT=ADDT)*v2,
        v3->A'*v3+joConstants(A.n,A.m,conj(b.ddt);DDT=ARDT,RDT=ADDT)*v3,
        v4->conj(A)*v4+joConstants(A.m,A.n,conj(b.rdt);DDT=ADDT,RDT=ARDT)*v4,
        @joNF, @joNF, @joNF, @joNF
        )
end

# +(num,jo)
+{ADDT,ARDT}(b::Number,A::joAbstractLinearOperator{ADDT,ARDT}) = A+b
+{ADDT,ARDT}(b::joNumber{ADDT,ARDT},A::joAbstractLinearOperator{ADDT,ARDT}) = A+b

############################################################
## overloaded Base -(...jo...)

# -(jo)

# -(jo,jo)
-(A::joAbstractLinearOperator,B::joAbstractLinearOperator) = A+(-B)

# -(jo,mvec)

# -(mvec,jo)

# -(jo,vec)

# -(vec,jo)

# -(jo,num)
-(A::joAbstractLinearOperator,b::Number) = A+(-b)
-(A::joAbstractLinearOperator,b::joNumber) = A+(-b)

# -(num,jo)
-(b::Number,A::joAbstractLinearOperator) = -A+b
-(b::joNumber,A::joAbstractLinearOperator) = -A+b

############################################################
## overloaded Base .*(...jo...)

############################################################
## overloaded Base .\(...jo...)

############################################################
## overloaded Base .+(...jo...)

############################################################
## overloaded Base .-(...jo...)

############################################################
## overloaded Base block methods

# hcat(...jo...)
hcat(ops::joAbstractLinearOperator...) = joDict(ops...)

# vcat(...jo...)
vcat(ops::joAbstractLinearOperator...) = joStack(ops...)

# hvcat(...jo...)
hvcat(rows::Tuple{Vararg{Int}}, ops::joAbstractLinearOperator...) = joBlock(collect(rows),ops...)

############################################################
## overloaded Base.LinAlg functions

# A_mul_B!(...,jo,...)
A_mul_B!{DDT,RDT}(y::AbstractVector{RDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractVector{DDT}) = y[:] = A * x
A_mul_B!{DDT,RDT}(y::AbstractMatrix{RDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractMatrix{DDT}) = y[:,:] = A * x

# At_mul_B!(...,jo,...)
At_mul_B!{DDT,RDT}(y::AbstractVector{DDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractVector{RDT}) = y[:] = A.' * x
At_mul_B!{DDT,RDT}(y::AbstractMatrix{DDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractMatrix{RDT}) = y[:,:] = A.' * x

# Ac_mul_B!(...,jo,...)
Ac_mul_B!{DDT,RDT}(y::AbstractVector{DDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractVector{RDT}) = y[:] = A' * x
Ac_mul_B!{DDT,RDT}(y::AbstractMatrix{DDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractMatrix{RDT}) = y[:,:] = A' * x

# A_ldiv_B!(...,jo,...)
A_ldiv_B!{DDT,RDT}(y::AbstractVector{DDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractVector{RDT}) = y[:] = A \ x
A_ldiv_B!{DDT,RDT}(y::AbstractMatrix{DDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractMatrix{RDT}) = y[:,:] = A \ x

# At_ldiv_B!(...,jo,...)
At_ldiv_B!{DDT,RDT}(y::AbstractVector{RDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractVector{DDT}) = y[:] = A.' \ x
At_ldiv_B!{DDT,RDT}(y::AbstractMatrix{RDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractMatrix{DDT}) = y[:,:] = A.' \ x

# Ac_ldiv_B!(...,jo,...)
Ac_ldiv_B!{DDT,RDT}(y::AbstractVector{RDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractVector{DDT}) = y[:] = A' \ x
Ac_ldiv_B!{DDT,RDT}(y::AbstractMatrix{RDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractMatrix{DDT}) = y[:,:] = A' \ x

