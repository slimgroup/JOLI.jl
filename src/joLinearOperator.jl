############################################################
# joLinearOperator #########################################
############################################################

export joLinearOperator, joLinearOperatorException

############################################################
## type definition

"""
    joLinearOperator glueing type & constructor

    !!! Do not use to create the operators
    !!! Use joMatrix and joLinearFunction constructors

"""
immutable joLinearOperator{ODT<:Number} <: joAbstractLinearOperator{ODT}
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
eltype{ODT}(A::joAbstractLinearOperator{ODT}) = ODT

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
full{ODT}(A::joAbstractLinearOperator{ODT}) = A*eye(ODT,A.n)

# norm(jo)
norm(A::joAbstractLinearOperator,p::Real=2) = norm(double(A),p)

# vecnorm(jo)
vecnorm(A::joAbstractLinearOperator,p::Real=2) = vecnorm(double(A),p)

# real(jo)
real{ODT<:Real}(A::joAbstractLinearOperator{ODT}) = A
function real{ODT<:Complex}(A::joAbstractLinearOperator{ODT})
    throw(joLinearOperatorException("real(jo) not implemented"))
end
joReal{ODT}(A::joAbstractLinearOperator{ODT}) = real(A)

# imag(jo)
imag{ODT<:Real}(A::joAbstractLinearOperator{ODT}) = joZeros(A.m,A.n,ODT)
function imag{ODT<:Complex}(A::joAbstractLinearOperator{ODT})
    throw(joLinearOperatorException("imag(jo) not implemented"))
end
joImag{ODT}(A::joAbstractLinearOperator{ODT}) = imag(A)

# conj(jo)
conj{ODT}(A::joLinearOperator{ODT}) =
    joLinearOperator{ODT}("conj("*A.name*")",A.m,A.n,
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
transpose{ODT}(A::joLinearOperator{ODT}) =
    joLinearOperator{ODT}(""*A.name*".'",A.n,A.m,
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
ctranspose{ODT}(A::joLinearOperator{ODT}) =
    joLinearOperator{ODT}(""*A.name*"'",A.n,A.m,
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
isreal{ODT}(A :: joAbstractLinearOperator{ODT}) = ODT <: Real

# issymmetric(jo)
issymmetric{ODT}(A::joAbstractLinearOperator{ODT}) =
    (A.m == A.n && (vecnorm(double(A)-double(A.')) < joTol))

# ishermitian(jo)
ishermitian{ODT}(A::joAbstractLinearOperator{ODT}) =
    (A.m == A.n && (vecnorm(double(A)-double(A')) < joTol))

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
function *{AODT,BODT}(A::joLinearOperator{AODT},B::joLinearOperator{BODT})
    A.n == B.m || throw(joLinearOperatorException("shape mismatch"))
    nODT=promote_type(AODT,BODT)
    return joLinearOperator{nODT}("("*A.name*"*"*B.name*")",A.m,B.n,
        v1->A.fop(B.fop(v1)),
        v2->get(B.fop_T)(get(A.fop_T)(v2)),
        v3->get(B.fop_CT)(get(A.fop_CT)(v3)),
        v4->get(A.fop_C)(get(B.fop_C)(v4)),
        @NF, @NF, @NF, @NF
        )
end
function *{AODT,BODT}(A::joAbstractLinearOperator{AODT},B::joAbstractLinearOperator{BODT})
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("shape mismatch"))
    nODT=promote_type(AODT,BODT)
    return joLinearOperator{nODT}("("*A.name*"*"*B.name*")",size(A,1),size(B,2),
        v1->A*(B*v1),
        v2->B.'*(A.'*v2),
        v3->B'*(A'*v3),
        v4->conj(A)*(conj(B)*v4),
        @NF, @NF, @NF, @NF
        )
end

# *(jo,mvec)
function *{AODT,mvDT<:Number}(A::joLinearOperator{AODT},mv::AbstractMatrix{mvDT})
    ##isnull(A.fop) && throw(joLinearOperatorException("*(jo,MultiVector) not supplied"))
    A.n == size(mv,1) || throw(joLinearOperatorException("shape mismatch"))
    nmvDT=promote_type(AODT,mvDT)
    MV=zeros(nmvDT,A.m,size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A.fop(mv[:,i])
    end
    return MV
end
function *{AODT,mvDT<:Number}(A::joAbstractLinearOperator{AODT},mv::AbstractMatrix{mvDT})
    ##isnull(A.fop) && throw(joAbstractLinearOperatorException("*(jo,MultiVector) not supplied"))
    size(A,2) == size(mv,1) || throw(joLinearOperatorException("shape mismatch"))
    nmvDT=promote_type(AODT,mvDT)
    MV=zeros(nmvDT,size(A,1),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A*mv[:,i]
    end
    return MV
end

# *(mvec,jo)

# *(jo,vec)
function *{AODT,vDT<:Number}(A::joLinearOperator{AODT},v::AbstractVector{vDT})
    A.n == size(v,1) || throw(joLinearOperatorException("shape mismatch"))
    return A.fop(v)
end

# *(vec,jo)

# *(num,jo)
function *{aDT<:Number,AODT}(a::aDT,A::joLinearOperator{AODT})
    nODT=promote_type(aDT,AODT)
    return joLinearOperator{nODT}("(N*"*A.name*")",A.m,A.n,
        v1->a*A.fop(v1),
        v2->a*A.fop_T(v2),
        v3->conj(a)*A.fop_CT(v3),
        v4->conj(a)*A.fop_C(v4),
        @NF, @NF, @NF, @NF
        )
end
function *{aDT<:Number,AODT}(a::aDT,A::joAbstractLinearOperator{AODT})
    nODT=promote_type(aDT,AODT)
    return joLinearOperator{nODT}("(N*"*A.name*")",A.m,A.n,
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
function \{AODT,mvDT<:Number}(A::joLinearOperator{AODT},mv::AbstractMatrix{mvDT})
    isinvertible(A) || throw(joLinearOperatorException("\(jo,MultiVector) not supplied"))
    A.m == size(mv,1) || throw(joLinearOperatorException("shape mismatch"))
    nmvDT=promote_type(AODT,mvDT)
    MV=zeros(nmvDT,A.n,size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A.iop(mv[:,i])
    end
    return MV
end
function \{AODT,mvDT<:Number}(A::joAbstractLinearOperator{AODT},mv::AbstractMatrix{mvDT})
    isinvertible(A) || throw(joAbstractLinearOperatorException("\(jo,MultiVector) not supplied"))
    size(A,1) == size(mv,1) || throw(joAbstractLinearOperatorException("shape mismatch"))
    nmvDT=promote_type(AODT,mvDT)
    MV=zeros(nmvDT,size(A,2),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A\mv[:,i]
    end
    return MV
end

# \(mvec,jo)

# \(jo,vec)
function \{AODT,vDT<:Number}(A::joLinearOperator{AODT},v::AbstractVector{vDT})
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
function +{AODT,BODT}(A::joLinearOperator{AODT},B::joLinearOperator{BODT})
    size(A) == size(B) || throw(joLinearOperatorException("shape mismatch"))
    nODT=promote_type(AODT,BODT)
    return joLinearOperator{nODT}("("*A.name*"+"*B.name*")",A.m,B.n,
        v1->A.fop(v1)+B.fop(v1),
        v2->A.fop_T(v2)+B.fop_T(v2),
        v3->A.fop_CT(v3)+B.fop_CT(v3),
        v4->A.fop_C(v4)+B.fop_C(v4),
        @NF, @NF, @NF, @NF
        )
end
function +{AODT,BODT}(A::joAbstractLinearOperator{AODT},B::joAbstractLinearOperator{BODT})
    size(A) == size(B) || throw(joAbstractLinearOperatorException("shape mismatch"))
    nODT=promote_type(AODT,BODT)
    return joLinearOperator{nODT}("("*A.name*"+"*B.name*")",size(A,1),size(B,2),
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
function +{AODT,bDT<:Number}(A::joLinearOperator{AODT},b::bDT)
    nODT=promote_type(AODT,bDT)
    return joLinearOperator{nODT}("("*A.name*"+N)",A.m,A.n,
        v1->A.fop(v1)+b*joOnes(A.m,A.n)*v1,
        v2->A.fop_T(v2)+b*joOnes(A.m,A.n)*v2,
        v3->A.fop_CT(v3)+conj(b)*joOnes(A.m,A.n)*v3,
        v4->A.fop_C(v4)+conj(b)*joOnes(A.m,A.n)*v4,
        @NF, @NF, @NF, @NF
        )
end
function +{AODT,bDT<:Number}(A::joAbstractLinearOperator{AODT},b::bDT)
    nODT=promote_type(AODT,bDT)
    return joLinearOperator{nODT}("("*A.name*"+N)",size(A,1),size(A,2),
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
-{ODT}(A::joLinearOperator{ODT}) =
    joLinearOperator{ODT}("(-"*A.name*")",A.m,A.n,
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
double{ODT}(A::joAbstractLinearOperator{ODT}) = A*eye(ODT,A.n)

# iscomplex(jo)
iscomplex{ODT}(A :: joAbstractLinearOperator{ODT}) = !(ODT <: Real)

# isinvertible(jo)
isinvertible{ODT}(A::joAbstractLinearOperator{ODT}) = !isnull(A.iop)

# islinear(jo)
function islinear{ODT}(A::joAbstractLinearOperator{ODT};tol::Number=joTol,verb::Bool=false)
    x=rand(ODT,A.n)
    y=rand(ODT,A.n)
    Axy=A*(x+y)
    AxAy=(A*x+A*y)
    dif=vecnorm(Axy-AxAy)
    test=(dif < tol)
    verb ? println("Linear test passed ($test) with tol=$tol: / diff=$dif") : test
    return test,dif
end
function islinear{ODT}(A::joAbstractLinearOperator{ODT},DDT::DataType;tol::Number=joTol,verb::Bool=false)
    x=rand(DDT,A.n)
    y=rand(DDT,A.n)
    Axy=A*(x+y)
    AxAy=(A*x+A*y)
    dif=vecnorm(Axy-AxAy)
    test=(dif < tol)
    verb ? println("Linear test passed ($test) with tol=$tol: / diff=$dif") : test
    return test,dif
end

# isadjoint(jo)
function isadjoint{ODT}(A::joAbstractLinearOperator{ODT};tol::Number=joTol,ctmult::Number=1.,verb::Bool=false)
    x=rand(ODT,A.n)
    y=rand(ODT,A.m)
    Axy=dot(A*x,y)
    xAty=dot(x,ctmult*A'*y)
    dif=abs(xAty-Axy)
    rto=abs(xAty/Axy)
    rer=abs(dif/xAty)
    test=(dif < tol)
    verb ? println("Adjoint test passed ($test) with tol=$tol: \n diff=   $dif \n relerr= $rer \n ratio=  $rto") : test
    return test,dif,rer,rto
end
function isadjoint{ODT}(A::joAbstractLinearOperator{ODT},DDT::DataType,RDT::DataType;tol::Number=joTol,ctmult::Number=1.,verb::Bool=false)
    x=rand(DDT,A.n)
    y=rand(RDT,A.m)
    Axy=dot(A*x,y)
    xAty=dot(x,ctmult*A'*y)
    dif=abs(xAty-Axy)
    rto=abs(xAty/Axy)
    test=(dif < tol)
    rer=abs(dif/xAty)
    verb ? println("Adjoint test passed ($test) with tol=$tol: \n diff=   $dif \n relerr= $rer \n ratio=  $rto") : test
    return test,dif,rer,rto
end

