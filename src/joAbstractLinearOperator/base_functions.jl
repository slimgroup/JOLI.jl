############################################################
## joAbstractLinearOperator - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = promote_type(DDT,RDT)

# deltype(jo)
deltype(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = DDT

# reltype(jo)
reltype(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = RDT

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
full(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = A*eye(DDT,A.n)

# norm(jo)
norm(A::joAbstractLinearOperator,p::Real=2) = norm(elements(A),p)

# vecnorm(jo)
vecnorm(A::joAbstractLinearOperator,p::Real=2) = vecnorm(elements(A),p)

# real(jo)
#real{DDT<:Real,RDT<:Real}(A::joAbstractLinearOperator{DDT,RDT}) = A
function real(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT}
    throw(joAbstractLinearOperatorException("real(jo) not implemented"))
end
joReal(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = real(A)

# imag(jo)
#imag{DDT<:Real,RDT<:Real}(A::joAbstractLinearOperator{DDT,RDT}) = joZeros(A.m,A.n,DDT,RDT)
function imag(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT}
    throw(joAbstractLinearOperatorException("imag(jo) not implemented"))
end
joImag(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = imag(A)

# conj(jo)
joConj(A::joAbstractLinearOperator) = conj(A)

# transpose(jo)

# adjoint(jo)

# isreal(jo)
isreal(A :: joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = (DDT<:Real && RDT<:Real)

# issymmetric(jo)
issymmetric(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} =
    (A.m == A.n && (vecnorm(elements(A)-elements(transpose(A))) < joTol))

# ishermitian(jo)
ishermitian(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} =
    (A.m == A.n && (vecnorm(elements(A)-elements(adjoint(A))) < joTol))

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
function *(A::joAbstractLinearOperator{CDT,ARDT},B::joAbstractLinearOperator{BDDT,CDT}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("shape mismatch"))
    return joLinearOperator{BDDT,ARDT}("("*A.name*"*"*B.name*")",size(A,1),size(B,2),
        v1->A*(B*v1),
        v2->transpose(B)*(transpose(A)*v2),
        v3->adjoint(B)*(adjoint(A)*v3),
        v4->conj(A)*(conj(B)*v4),
        @joNF, @joNF, @joNF, @joNF
        )
end

# *(jo,mvec)

# *(mvec,jo)

# *(jo,vec)

# *(vec,jo)

# *(num,jo)
function *(a::Number,A::joAbstractLinearOperator{ADDT,ARDT}) where {ADDT,ARDT}
    return joLinearOperator{ADDT,ARDT}("(N*"*A.name*")",A.m,A.n,
        v1->jo_convert(ARDT,a*(A*v1),false),
        v2->jo_convert(ADDT,a*(transpose(A)*v2),false),
        v3->jo_convert(ADDT,conj(a)*(adjoint(A)*v3),false),
        v4->jo_convert(ARDT,conj(a)*(conj(A)*v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
end
function *(a::joNumber{ADDT,ARDT},A::joAbstractLinearOperator{ADDT,ARDT}) where {ADDT,ARDT}
    return joLinearOperator{ADDT,ARDT}("(N*"*A.name*")",A.m,A.n,
        v1->jo_convert(ARDT,a.rdt*(A*v1),false),
        v2->jo_convert(ADDT,a.ddt*(transpose(A)*v2),false),
        v3->jo_convert(ADDT,conj(a.ddt)*(adjoint(A)*v3),false),
        v4->jo_convert(ARDT,conj(a.rdt)*(conj(A)*v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
end

# *(jo,num)
*(A::joAbstractLinearOperator{ADDT,ARDT},a::Number) where {ADDT,ARDT} = a*A
*(A::joAbstractLinearOperator{ADDT,ARDT},a::joNumber{ADDT,ARDT}) where {ADDT,ARDT} = a*A

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
function +(A::joAbstractLinearOperator{DDT,RDT},B::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT}
    size(A) == size(B) || throw(joAbstractLinearOperatorException("shape mismatch"))
    return joLinearOperator{DDT,RDT}("("*A.name*"+"*B.name*")",size(A,1),size(B,2),
        v1->A*v1+B*v1,
        v2->transpose(A)*v2+transpose(B)*v2,
        v3->adjoint(A)*v3+adjoint(B)*v3,
        v4->conj(A)*v4+conj(B)*v4,
        @joNF, @joNF, @joNF, @joNF
        )
end

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)
function +(A::joAbstractLinearOperator{ADDT,ARDT},b::Number) where {ADDT,ARDT}
    return joLinearOperator{ADDT,ARDT}("("*A.name*"+N)",size(A,1),size(A,2),
        v1->A*v1+joConstants(A.m,A.n,b;DDT=ADDT,RDT=ARDT)*v1,
        v2->transpose(A)*v2+joConstants(A.n,A.m,b;DDT=ARDT,RDT=ADDT)*v2,
        v3->adjoint(A)*v3+joConstants(A.n,A.m,conj(b);DDT=ARDT,RDT=ADDT)*v3,
        v4->conj(A)*v4+joConstants(A.m,A.n,conj(b);DDT=ADDT,RDT=ARDT)*v4,
        @joNF, @joNF, @joNF, @joNF
        )
end
function +(A::joAbstractLinearOperator{ADDT,ARDT},b::joNumber{ADDT,ARDT}) where {ADDT,ARDT}
    return joLinearOperator{ADDT,ARDT}("("*A.name*"+N)",size(A,1),size(A,2),
        v1->A*v1+joConstants(A.m,A.n,b.rdt;DDT=ADDT,RDT=ARDT)*v1,
        v2->transpose(A)*v2+joConstants(A.n,A.m,b.ddt;DDT=ARDT,RDT=ADDT)*v2,
        v3->adjoint(A)*v3+joConstants(A.n,A.m,conj(b.ddt);DDT=ARDT,RDT=ADDT)*v3,
        v4->conj(A)*v4+joConstants(A.m,A.n,conj(b.rdt);DDT=ADDT,RDT=ARDT)*v4,
        @joNF, @joNF, @joNF, @joNF
        )
end

# +(num,jo)
+(b::Number,A::joAbstractLinearOperator{ADDT,ARDT}) where {ADDT,ARDT} = A+b
+(b::joNumber{ADDT,ARDT},A::joAbstractLinearOperator{ADDT,ARDT}) where {ADDT,ARDT} = A+b

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
A_mul_B!(y::AbstractVector{RDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractVector{DDT}) where {DDT,RDT} = y[:] = A * x
A_mul_B!(y::AbstractMatrix{RDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractMatrix{DDT}) where {DDT,RDT} = y[:,:] = A * x

# At_mul_B!(...,jo,...)
At_mul_B!(y::AbstractVector{DDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractVector{RDT}) where {DDT,RDT} = y[:] = transpose(A) * x
At_mul_B!(y::AbstractMatrix{DDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractMatrix{RDT}) where {DDT,RDT} = y[:,:] = transpose(A) * x

# Ac_mul_B!(...,jo,...)
Ac_mul_B!(y::AbstractVector{DDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractVector{RDT}) where {DDT,RDT} = y[:] = adjoint(A) * x
Ac_mul_B!(y::AbstractMatrix{DDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractMatrix{RDT}) where {DDT,RDT} = y[:,:] = adjoint(A) * x

# A_ldiv_B!(...,jo,...)
A_ldiv_B!(y::AbstractVector{DDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractVector{RDT}) where {DDT,RDT} = y[:] = A \ x
A_ldiv_B!(y::AbstractMatrix{DDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractMatrix{RDT}) where {DDT,RDT} = y[:,:] = A \ x

# At_ldiv_B!(...,jo,...)
At_ldiv_B!(y::AbstractVector{RDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractVector{DDT}) where {DDT,RDT} = y[:] = transpose(A) \ x
At_ldiv_B!(y::AbstractMatrix{RDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractMatrix{DDT}) where {DDT,RDT} = y[:,:] = transpose(A) \ x

# Ac_ldiv_B!(...,jo,...)
Ac_ldiv_B!(y::AbstractVector{RDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractVector{DDT}) where {DDT,RDT} = y[:] = adjoint(A) \ x
Ac_ldiv_B!(y::AbstractMatrix{RDT},A::joAbstractLinearOperator{DDT,RDT},x::AbstractMatrix{DDT}) where {DDT,RDT} = y[:,:] = adjoint(A) \ x

