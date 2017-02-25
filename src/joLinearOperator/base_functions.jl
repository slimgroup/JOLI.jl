############################################################
## joLinearOperator - overloaded Base functions

# eltype(jo)
eltype{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) = EDT

# deltype(jo)
deltype{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) = DDT

# reltype(jo)
reltype{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) = RDT

# show(jo)
show(A::joAbstractLinearOperator) = println((typeof(A),A.name,A.m,A.n))

# showall(jo)
showall(A::joAbstractLinearOperator) = println((typeof(A),A.name,A.m,A.n))

# display(jo)
display(A::joAbstractLinearOperator) = show(A)

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
full{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) = A*eye(DDT,A.n)

# norm(jo)
norm(A::joAbstractLinearOperator,p::Real=2) = norm(double(A),p)

# vecnorm(jo)
vecnorm(A::joAbstractLinearOperator,p::Real=2) = vecnorm(double(A),p)

# real(jo)
real{EDT<:Real,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) = A
function real{EDT<:Complex,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT})
    throw(joLinearOperatorException("real(jo) not implemented"))
end
joReal{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) = real(A)

# imag(jo)
imag{EDT<:Real,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) = joZeros(A.m,A.n,EDT)
function imag{EDT<:Complex,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT})
    throw(joLinearOperatorException("imag(jo) not implemented"))
end
joImag{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) = imag(A)

# conj(jo)
conj{EDT,DDT,RDT}(A::joLinearOperator{EDT,DDT,RDT}) =
    joLinearOperator{EDT,DDT,RDT}("conj("*A.name*")",A.m,A.n,
        get(A.fop_C),
        A.fop_CT,
        A.fop_T,
        A.fop,
        A.iop_C,
        A.iop_CT,
        A.iop_T,
        A.iop
        )
joConj(A::joAbstractLinearOperator) = conj(A)

# transpose(jo)
transpose{EDT,DDT,RDT}(A::joLinearOperator{EDT,DDT,RDT}) =
    joLinearOperator{EDT,RDT,DDT}(""*A.name*".'",A.n,A.m,
        get(A.fop_T),
        A.fop,
        A.fop_C,
        A.fop_CT,
        A.iop_T,
        A.iop,
        A.iop_C,
        A.iop_CT
        )

# ctranspose(jo)
ctranspose{EDT,DDT,RDT}(A::joLinearOperator{EDT,DDT,RDT}) =
    joLinearOperator{EDT,RDT,DDT}(""*A.name*"'",A.n,A.m,
        get(A.fop_CT),
        A.fop_C,
        A.fop,
        A.fop_T,
        A.iop_CT,
        A.iop_C,
        A.iop,
        A.iop_T
        )

# isreal(jo)
isreal{EDT,DDT,RDT}(A :: joAbstractLinearOperator{EDT,DDT,RDT}) = EDT <: Real

# issymmetric(jo)
issymmetric{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) =
    (A.m == A.n && (vecnorm(double(A)-double(A.')) < joTol))

# ishermitian(jo)
ishermitian{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) =
    (A.m == A.n && (vecnorm(double(A)-double(A')) < joTol))

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
function *{AEDT,ARDT,BEDT,BDDT,CDT}(A::joLinearOperator{AEDT,CDT,ARDT},B::joLinearOperator{BEDT,BDDT,CDT})
    A.n == B.m || throw(joLinearOperatorException("shape mismatch"))
    nEDT=promote_type(AEDT,BEDT)
    return joLinearOperator{nEDT,BDDT,ARDT}("("*A.name*"*"*B.name*")",A.m,B.n,
        v1->A.fop(B.fop(v1)),
        v2->get(B.fop_T)(get(A.fop_T)(v2)),
        v3->get(B.fop_CT)(get(A.fop_CT)(v3)),
        v4->get(A.fop_C)(get(B.fop_C)(v4)),
        @NF, @NF, @NF, @NF
        )
end
function *{AEDT,ARDT,BEDT,BDDT,CDT}(A::joAbstractLinearOperator{AEDT,CDT,ARDT},B::joAbstractLinearOperator{BEDT,BDDT,CDT})
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("shape mismatch"))
    nEDT=promote_type(AEDT,BEDT)
    return joLinearOperator{nEDT,BDDT,ARDT}("("*A.name*"*"*B.name*")",size(A,1),size(B,2),
        v1->A*(B*v1),
        v2->B.'*(A.'*v2),
        v3->B'*(A'*v3),
        v4->conj(A)*(conj(B)*v4),
        @NF, @NF, @NF, @NF
        )
end

# *(jo,mvec)
function *{AEDT,ADDT,ARDT,mvDT<:Number}(A::joLinearOperator{AEDT,ADDT,ARDT},mv::AbstractMatrix{mvDT}) # fix DDT/RDT
    A.n == size(mv,1) || throw(joLinearOperatorException("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    nmvDT=promote_type(AEDT,mvDT)
    MV=zeros(nmvDT,A.m,size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A.fop(mv[:,i])
    end
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *{AEDT,ADDT,ARDT,mvDT<:Number}(A::joAbstractLinearOperator{AEDT,ADDT,ARDT},mv::AbstractMatrix{mvDT}) # fix DDT/RDT
    size(A,2) == size(mv,1) || throw(joLinearOperatorException("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    nmvDT=promote_type(AEDT,mvDT)
    MV=zeros(nmvDT,size(A,1),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A*mv[:,i]
    end
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end

# *(mvec,jo)

# *(jo,vec)
function *{AEDT,ADDT,ARDT,vDT<:Number}(A::joLinearOperator{AEDT,ADDT,ARDT},v::AbstractVector{vDT})
    A.n == size(v,1) || throw(joLinearOperatorException("shape mismatch"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end

# *(vec,jo)

# *(num,jo)
function *{AEDT,ADDT,ARDT}(a::AEDT,A::joLinearOperator{AEDT,ADDT,ARDT}) # fix DDT/RDT
    return joLinearOperator{AEDT,ADDT,ARDT}("(N*"*A.name*")",A.m,A.n,
        v1->a*A.fop(v1),
        v2->a*A.fop_T(v2),
        v3->conj(a)*A.fop_CT(v3),
        v4->conj(a)*A.fop_C(v4),
        @NF, @NF, @NF, @NF
        )
end
function *{AEDT,ADDT,ARDT}(a::AEDT,A::joAbstractLinearOperator{AEDT,ADDT,ARDT}) # fix DDT/RDT
    return joLinearOperator{AEDT,ADDT,ARDT}("(N*"*A.name*")",A.m,A.n,
        v1->a*A*v1,
        v2->a*A.'*v2,
        v3->conj(a)*A'*v3,
        v4->conj(a)*conj(A)*v4,
        @NF, @NF, @NF, @NF
        )
end

# *(jo,num)
*{AEDT,ADDT,ARDT}(A::joLinearOperator{AEDT,ADDT,ARDT},a::AEDT) = a*A
*{AEDT,ADDT,ARDT}(A::joAbstractLinearOperator{AEDT,ADDT,ARDT},a::AEDT) = a*A

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)

# \(jo,mvec)
function \{AEDT,ADDT,ARDT,mvDT<:Number}(A::joLinearOperator{AEDT,ADDT,ARDT},mv::AbstractMatrix{mvDT})
    isinvertible(A) || throw(joLinearOperatorException("\(jo,MultiVector) not supplied"))
    A.m == size(mv,1) || throw(joLinearOperatorException("shape mismatch"))
    nmvDT=promote_type(AEDT,mvDT)
    MV=zeros(nmvDT,A.n,size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A.iop(mv[:,i])
    end
    return MV
end
function \{AEDT,ADDT,ARDT,mvDT<:Number}(A::joAbstractLinearOperator{AEDT,ADDT,ARDT},mv::AbstractMatrix{mvDT})
    isinvertible(A) || throw(joAbstractLinearOperatorException("\(jo,MultiVector) not supplied"))
    size(A,1) == size(mv,1) || throw(joAbstractLinearOperatorException("shape mismatch"))
    nmvDT=promote_type(AEDT,mvDT)
    MV=zeros(nmvDT,size(A,2),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A\mv[:,i]
    end
    return MV
end

# \(mvec,jo)

# \(jo,vec)
function \{AEDT,ADDT,ARDT,vDT<:Number}(A::joLinearOperator{AEDT,ADDT,ARDT},v::AbstractVector{vDT})
    isinvertible(A) || throw(joLinearOperatorException("\(jo,Vector) not supplied"))
    A.m == size(v,1) || throw(joLinearOperatorException("shape mismatch"))
    return get(A.iop)(v)
end

# \(vec,jo)

# \(num,jo)

# \(jo,num)

############################################################
## overloaded Base +(...jo...)

# +(jo)
+(A::joAbstractLinearOperator) = A

# +(jo,jo)
function +{EDT,DDT,RDT}(A::joLinearOperator{EDT,DDT,RDT},B::joLinearOperator{EDT,DDT,RDT})
    size(A) == size(B) || throw(joLinearOperatorException("shape mismatch"))
    return joLinearOperator{EDT,DDT,RDT}("("*A.name*"+"*B.name*")",A.m,B.n,
        v1->A.fop(v1)+B.fop(v1),
        v2->A.fop_T(v2)+B.fop_T(v2),
        v3->A.fop_CT(v3)+B.fop_CT(v3),
        v4->A.fop_C(v4)+B.fop_C(v4),
        @NF, @NF, @NF, @NF
        )
end
function +{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT},B::joAbstractLinearOperator{EDT,DDT,RDT})
    size(A) == size(B) || throw(joAbstractLinearOperatorException("shape mismatch"))
    return joLinearOperator{EDT,DDT,RDT}("("*A.name*"+"*B.name*")",size(A,1),size(B,2),
        v1->A*v1+B*v1,
        v2->A.'*v2+B.'*v2,
        v3->A'*v3+B'*v3,
        v4->conj(A)*v4+conj(B)*v4,
        @NF, @NF, @NF, @NF
        )
end

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)
function +{AEDT,ADDT,ARDT}(A::joLinearOperator{AEDT,ADDT,ARDT},b::AEDT)
    return joLinearOperator{AEDT,ADDT,ARDT}("("*A.name*"+N)",A.m,A.n,
        v1->A.fop(v1)+joConstants(A.m,A.n,b,AEDT,ADDT,ARDT)*v1,
        v2->get(A.fop_T)(v2)+joConstants(A.n,A.m,b,AEDT,ARDT,ADDT)*v2,
        v3->get(A.fop_CT)(v3)+joConstants(A.n,A.m,conj(b),AEDT,ARDT,ADDT)*v3,
        v4->get(A.fop_C)(v4)+joConstants(A.m,A.n,conj(b)*AEDT,ADDT,ARDT)*v4,
        @NF, @NF, @NF, @NF
        )
end
function +{AEDT,ADDT,ARDT}(A::joAbstractLinearOperator{AEDT,ADDT,ARDT},b::AEDT)
    return joLinearOperator{AEDT,ADDT,ARDT}("("*A.name*"+N)",size(A,1),size(A,2),
        v1->A*v1+joConstants(A.m,A.n,b,AEDT,ADDT,ARDT)*v1,
        v2->A.'*v2+joConstants(A.n,A.m,b,AEDT,ARDT,ADDT)*v2,
        v3->A'*v3+joConstants(A.n,A.m,conj(b),AEDT,ARDT,ADDT)*v3,
        v4->conj(A)*v4+joConstants(A.m,A.n,conj(b),AEDT,ADDT,ARDT)*v4,
        @NF, @NF, @NF, @NF
        )
end

# +(num,jo)
+{AEDT,ADDT,ARDT}(b::AEDT,A::joLinearOperator{AEDT,ADDT,ARDT}) = A+b
+{AEDT,ADDT,ARDT}(b::AEDT,A::joAbstractLinearOperator{AEDT,ADDT,ARDT}) = A+b

############################################################
## overloaded Base -(...jo...)

# -(jo)
-{EDT,DDT,RDT}(A::joLinearOperator{EDT,DDT,RDT}) =
    joLinearOperator{EDT,DDT,RDT}("(-"*A.name*")",A.m,A.n,
        v1->-A.fop(v1),
        v2->-get(A.fop_T)(v2),
        v3->-get(A.fop_CT)(v3),
        v4->-get(A.fop_C)(v4),
        v5->-get(A.iop)(v5),
        v6->-get(A.iop_T)(v6),
        v7->-get(A.iop_CT)(v7),
        v8->-get(A.iop_C)(v8)
        )

# -(jo,jo)
-(A::joAbstractLinearOperator,B::joAbstractLinearOperator) = A+(-B)

# -(jo,mvec)

# -(mvec,jo)

# -(jo,vec)

# -(vec,jo)

# -(jo,num)
-(A::joAbstractLinearOperator,b::Number) = A+(-b)

# -(num,jo)
-(b::Number,A::joAbstractLinearOperator) = -A+b

############################################################
## overloaded Base .*(...jo...)

# .*(jo,jo)

# .*(jo,mvec)

# .*(mvec,jo)

# .*(jo,vec)

# .*(vec,jo)

# .*(num,jo)

# .*(jo,num)

############################################################
## overloaded Base .\(...jo...)

# .\(jo,jo)

# .\(jo,mvec)

# .\(mvec,jo)

# .\(jo,vec)

# .\(vec,jo)

# .\(num,jo)

# .\(jo,num)

############################################################
## overloaded Base .+(...jo...)

# .+(jo,jo)

# .+(jo,mvec)

# .+(mvec,jo)

# .+(jo,vec)

# .+(vec,jo)

# .+(jo,num)

# .+(num,jo)

############################################################
## overloaded Base .-(...jo...)

# .-(jo,jo)

# .-(jo,mvec)

# .-(mvec,jo)

# .-(jo,vec)

# .-(vec,jo)

# .-(jo,num)

# .-(num,jo)

############################################################
## overloaded Base hcat(...jo...)

############################################################
## overloaded Base vcat(...jo...)

