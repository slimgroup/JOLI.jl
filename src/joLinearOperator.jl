############################################################
# joLinearOperator #########################################
############################################################

export joLinearOperator, joLinearOperatorException

############################################################
## type definition

immutable joLinearOperator{EDT<:Number,DDT<:Number,RDT<:Number} <: joAbstractLinearOperator{EDT,DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function              # forward
    fop_T::Nullable{Function}  # transpose
    fop_CT::Nullable{Function} # conj transpose
    fop_C::Nullable{Function}  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_CT::Nullable{Function}
    iop_C::Nullable{Function}
end

type joLinearOperatorException <: Exception
    msg :: String
end

############################################################
## outer constructors

############################################################
## overloaded Base functions

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
function *{AEDT,ADDT,ARDT,BEDT,BDDT,BRDT}(A::joLinearOperator{AEDT,ADDT,ARDT},B::joLinearOperator{BEDT,BDDT,BRDT}) # fix,DDT,RDT
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
function *{AEDT,ADDT,ARDT,BEDT,BDDT,BRDT}(A::joAbstractLinearOperator{AEDT,ADDT,ARDT},B::joAbstractLinearOperator{BEDT,BDDT,BRDT}) # fix,DDT,RDT
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
function *{AEDT,ADDT,ARDT,mvDT<:Number}(A::joLinearOperator{AEDT,ADDT,ARDT},mv::AbstractMatrix{mvDT}) # fix,DDT,RDT
    ##isnull(A.fop) && throw(joLinearOperatorException("*(jo,MultiVector) not supplied"))
    A.n == size(mv,1) || throw(joLinearOperatorException("shape mismatch"))
    nmvDT=promote_type(AEDT,mvDT)
    MV=zeros(nmvDT,A.m,size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A.fop(mv[:,i])
    end
    return MV
end
function *{AEDT,ADDT,ARDT,mvDT<:Number}(A::joAbstractLinearOperator{AEDT,ADDT,ARDT},mv::AbstractMatrix{mvDT}) # fix,DDT,RDT
    ##isnull(A.fop) && throw(joAbstractLinearOperatorException("*(jo,MultiVector) not supplied"))
    size(A,2) == size(mv,1) || throw(joLinearOperatorException("shape mismatch"))
    nmvDT=promote_type(AEDT,mvDT)
    MV=zeros(nmvDT,size(A,1),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A*mv[:,i]
    end
    return MV
end

# *(mvec,jo)

# *(jo,vec)
function *{AEDT,ADDT,ARDT,vDT<:Number}(A::joLinearOperator{AEDT,ADDT,ARDT},v::AbstractVector{vDT}) # fix,DDT,RDT
    A.n == size(v,1) || throw(joLinearOperatorException("shape mismatch"))
    return A.fop(v)
end

# *(vec,jo)

# *(num,jo)
function *{aDT<:Number,AEDT,ADDT,ARDT}(a::aDT,A::joLinearOperator{AEDT,ADDT,ARDT}) # fix,DDT,RDT
    nEDT=promote_type(aDT,AEDT)
    return joLinearOperator{nEDT,ADDT,ARDT}("(N*"*A.name*")",A.m,A.n,
        v1->a*A.fop(v1),
        v2->a*A.fop_T(v2),
        v3->conj(a)*A.fop_CT(v3),
        v4->conj(a)*A.fop_C(v4),
        @NF, @NF, @NF, @NF
        )
end
function *{aDT<:Number,AEDT,ADDT,ARDT}(a::aDT,A::joAbstractLinearOperator{AEDT,ADDT,ARDT}) # fix,DDT,RDT
    nEDT=promote_type(aDT,AEDT)
    return joLinearOperator{nEDT,ADDT,ARDT}("(N*"*A.name*")",A.m,A.n,
        v1->a*A*v1,
        v2->a*A.'*v2,
        v3->conj(a)*A'*v3,
        v4->conj(a)*conj(A)*v4,
        @NF, @NF, @NF, @NF
        )
end

# *(jo,num)
*(A::joAbstractLinearOperator,a::Number) = a*A

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)

# \(jo,mvec)
function \{AEDT,ADDT,ARDT,mvDT<:Number}(A::joLinearOperator{AEDT,ADDT,ARDT},mv::AbstractMatrix{mvDT}) # fix,DDT,RDT
    isinvertible(A) || throw(joLinearOperatorException("\(jo,MultiVector) not supplied"))
    A.m == size(mv,1) || throw(joLinearOperatorException("shape mismatch"))
    nmvDT=promote_type(AEDT,mvDT)
    MV=zeros(nmvDT,A.n,size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A.iop(mv[:,i])
    end
    return MV
end
function \{AEDT,ADDT,ARDT,mvDT<:Number}(A::joAbstractLinearOperator{AEDT,ADDT,ARDT},mv::AbstractMatrix{mvDT}) # fix,DDT,RDT
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
function \{AEDT,ADDT,ARDT,vDT<:Number}(A::joLinearOperator{AEDT,ADDT,ARDT},v::AbstractVector{vDT}) # fix,DDT,RDT
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
function +{AEDT,ADDT,ARDT,BEDT,BDDT,BRDT}(A::joLinearOperator{AEDT,ADDT,ARDT},B::joLinearOperator{BEDT,BDDT,BRDT}) # fix,DDT,RDT
    size(A) == size(B) || throw(joLinearOperatorException("shape mismatch"))
    nEDT=promote_type(AEDT,BEDT)
    return joLinearOperator{nEDT,ADDT,ARDT}("("*A.name*"+"*B.name*")",A.m,B.n,
        v1->A.fop(v1)+B.fop(v1),
        v2->A.fop_T(v2)+B.fop_T(v2),
        v3->A.fop_CT(v3)+B.fop_CT(v3),
        v4->A.fop_C(v4)+B.fop_C(v4),
        @NF, @NF, @NF, @NF
        )
end
function +{AEDT,ADDT,ARDT,BEDT,BDDT,BRDT}(A::joAbstractLinearOperator{AEDT,ADDT,ARDT},B::joAbstractLinearOperator{BEDT,BDDT,BRDT}) # fix,DDT,RDT
    size(A) == size(B) || throw(joAbstractLinearOperatorException("shape mismatch"))
    nEDT=promote_type(AEDT,BEDT)
    return joLinearOperator{nEDT,ADDT,ARDT}("("*A.name*"+"*B.name*")",size(A,1),size(B,2),
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
function +{AEDT,ADDT,ARDT,bDT<:Number}(A::joLinearOperator{AEDT,ADDT,ARDT},b::bDT) # fix,DDT,RDT
    nEDT=promote_type(AEDT,bDT)
    return joLinearOperator{nEDT,ADDT,ARDT}("("*A.name*"+N)",A.m,A.n,
        v1->A.fop(v1)+b*joOnes(A.m,A.n)*v1,
        v2->A.fop_T(v2)+b*joOnes(A.m,A.n)*v2,
        v3->A.fop_CT(v3)+conj(b)*joOnes(A.m,A.n)*v3,
        v4->A.fop_C(v4)+conj(b)*joOnes(A.m,A.n)*v4,
        @NF, @NF, @NF, @NF
        )
end
function +{AEDT,ADDT,ARDT,bDT<:Number}(A::joAbstractLinearOperator{AEDT,ADDT,ARDT},b::bDT) # fix,DDT,RDT
    nEDT=promote_type(AEDT,bDT)
    return joLinearOperator{nEDT,ADDT,ARDT}("("*A.name*"+N)",size(A,1),size(A,2),
        v1->A*v1+b*joOnes(A.m,A.n)*v1,
        v2->A.'*v2+b*joOnes(A.m,A.n)*v2,
        v3->A'*v3+conj(b)*joOnes(A.m,A.n)*v3,
        v4->conj(A)*v4+conj(b)*joOnes(A.m,A.n)*v4,
        @NF, @NF, @NF, @NF
        )
end

# +(num,jo)
+(b::Number,A::joAbstractLinearOperator) = A+b

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

############################################################
## extra methods

# double(jo)
double{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) = A*eye(DDT,A.n)

# iscomplex(jo)
iscomplex{EDT,DDT,RDT}(A :: joAbstractLinearOperator{EDT,DDT,RDT}) = !(EDT <: Real)

# isinvertible(jo)
isinvertible{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) = !isnull(A.iop)

# islinear(jo) # fix,DDT,RDT
function islinear{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT};tol::Number=joTol,verb::Bool=false)
    x=rand(DDT,A.n)
    y=rand(DDT,A.n)
    Axy=A*(x+y)
    AxAy=(A*x+A*y)
    dif=vecnorm(Axy-AxAy)
    test=(dif < tol)
    verb ? println("Linear test passed ($test) with tol=$tol: / diff=$dif") : test
    return test,dif
end
function islinear{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT},nDDT::DataType;tol::Number=joTol,verb::Bool=false)
    x=rand(nDDT,A.n)
    y=rand(nDDT,A.n)
    Axy=A*(x+y)
    AxAy=(A*x+A*y)
    dif=vecnorm(Axy-AxAy)
    test=(dif < tol)
    verb ? println("Linear test passed ($test) with tol=$tol: / diff=$dif") : test
    return test,dif
end

# isadjoint(jo) # fix,DDT,RDT
function isadjoint{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT};tol::Number=joTol,ctmult::Number=1.,verb::Bool=false)
    x=rand(DDT,A.n)
    y=A*rand(DDT,A.n)
    Axy=dot(A*x,y)
    xAty=dot(x,ctmult*A'*y)
    dif=abs(xAty-Axy)
    rto=abs(xAty/Axy)
    rer=abs(dif/xAty)
    test=(dif < tol)
    verb ? println("Adjoint test passed ($test) with tol=$tol: \n diff=   $dif \n relerr= $rer \n ratio=  $rto") : test
    return test,dif,rer,rto
end
function isadjoint{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT},nDDT::DataType;tol::Number=joTol,ctmult::Number=1.,verb::Bool=false)
    x=rand(nDDT,A.n)
    y=A*rand(nDDT,A.n)
    Axy=dot(A*x,y)
    xAty=dot(x,ctmult*A'*y)
    dif=abs(xAty-Axy)
    rto=abs(xAty/Axy)
    test=(dif < tol)
    rer=abs(dif/xAty)
    verb ? println("Adjoint test passed ($test) with tol=$tol: \n diff=   $dif \n relerr= $rer \n ratio=  $rto") : test
    return test,dif,rer,rto
end

