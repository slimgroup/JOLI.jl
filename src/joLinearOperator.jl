############################################################
# joLinearOperator #########################################
############################################################

export joLinearOperator, joLinearOperatorException

############################################################
## type definition

immutable joLinearOperator{T} <: joAbstractLinearOperator{T}
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
eltype{T}(A::joAbstractLinearOperator{T}) = T

# show(jo)
show(A::joAbstractLinearOperator) = println((typeof(A),A.name,A.m,A.n))

# showall(jo)
showall(A::joAbstractLinearOperator) = println((typeof(A),A.name,A.m,A.n))

# display(jo)
display(A::joAbstractLinearOperator) = show(A)

# size(jo)
size(A::joAbstractLinearOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joAbstractLinearOperator,ind::Int64)
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
full(A::joAbstractLinearOperator) = A*eye(A.n)

# norm(jo)
norm(A::joAbstractLinearOperator,p::Real=2) = norm(double(A),p)

# vecnorm(jo)
vecnorm(A::joAbstractLinearOperator,p::Real=2) = vecnorm(double(A),p)

# real(jo)
real(A::joAbstractLinearOperator) = throw(joLinearOperatorException("real(jo) not implemented"))
joReal(A::joAbstractLinearOperator) = real(A)

# imag(jo)
imag(A::joAbstractLinearOperator) = throw(joLinearOperatorException("imag(jo) not implemented"))
joImag(A::joAbstractLinearOperator) = imag(A)

# conj(jo)
conj{T}(A::joLinearOperator{T}) =
    joLinearOperator{T}("conj("*A.name*")",A.m,A.n,
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
transpose{T}(A::joLinearOperator{T}) =
    joLinearOperator{T}(""*A.name*".'",A.n,A.m,
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
ctranspose{T}(A::joLinearOperator{T}) =
    joLinearOperator{T}(""*A.name*"'",A.n,A.m,
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
isreal{T}(A :: joAbstractLinearOperator{T}) = T <: Real

# issymmetric(jo)
issymmetric(A::joAbstractLinearOperator) =
    (A.m == A.n && (vecnorm(double(A)-double(A.')) < joTol))

# ishermitian(jo)
ishermitian(A::joAbstractLinearOperator) =
    (A.m == A.n && (vecnorm(double(A)-double(A')) < joTol))

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
function *(A::joLinearOperator,B::joLinearOperator)
    A.n == B.m || throw(joLinearOperatorException("shape mismatch"))
    S=promote_type(eltype(A),eltype(B))
    return joLinearOperator{S}("("*A.name*"*"*B.name*")",A.m,B.n,
        v1->A.fop(B.fop(v1)),
        v2->get(B.fop_T)(get(A.fop_T)(v2)),
        v3->get(B.fop_CT)(get(A.fop_CT)(v3)),
        v4->get(A.fop_C)(get(B.fop_C)(v4)),
        @NF, @NF, @NF, @NF
        )
end
function *(A::joAbstractLinearOperator,B::joAbstractLinearOperator)
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("shape mismatch"))
    S=promote_type(eltype(A),eltype(B))
    return joLinearOperator{S}("("*A.name*"*"*B.name*")",size(A,1),size(B,2),
        v1->A*(B*v1),
        v2->B.'*(A.'*v2),
        v3->B'*(A'*v3),
        v4->conj(A)*(conj(B)*v4),
        @NF, @NF, @NF, @NF
        )
end

# *(jo,mvec)
function *(A::joLinearOperator,mv::AbstractMatrix)
    ##isnull(A.fop) && throw(joLinearOperatorException("*(jo,MultiVector) not supplied"))
    A.n == size(mv,1) || throw(joLinearOperatorException("shape mismatch"))
    MV=zeros(promote_type(eltype(A),eltype(mv)),A.m,size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A.fop(mv[:,i])
    end
    return MV
end
function *(A::joAbstractLinearOperator,mv::AbstractMatrix)
    ##isnull(A.fop) && throw(joAbstractLinearOperatorException("*(jo,MultiVector) not supplied"))
    size(A,2) == size(mv,1) || throw(joLinearOperatorException("shape mismatch"))
    MV=zeros(promote_type(eltype(A),eltype(mv)),size(A,1),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A*mv[:,i]
    end
    return MV
end

# *(mvec,jo)

# *(jo,vec)
function *(A::joLinearOperator,v::AbstractVector)
    A.n == size(v,1) || throw(joLinearOperatorException("shape mismatch"))
    return A.fop(v)
end

# *(vec,jo)

# *(num,jo)
function *(a::Number,A::joLinearOperator)
    S=promote_type(eltype(a),eltype(A))
    return joLinearOperator{S}("(N*"*A.name*")",A.m,A.n,
        v1->a*A.fop(v1),
        v2->a*A.fop_T(v2),
        v3->conj(a)*A.fop_CT(v3),
        v4->conj(a)*A.fop_C(v4),
        @NF, @NF, @NF, @NF
        )
end
function *(a::Number,A::joAbstractLinearOperator)
    S=promote_type(eltype(a),eltype(A))
    return joLinearOperator{S}("(N*"*A.name*")",A.m,A.n,
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
function \(A::joLinearOperator,mv::AbstractMatrix)
    isnull(A.iop) && throw(joLinearOperatorException("\(jo,MultiVector) not supplied"))
    A.m == size(mv,1) || throw(joLinearOperatorException("shape mismatch"))
    MV=zeros(promote_type(eltype(A),eltype(mv)),A.n,size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A.iop(mv[:,i])
    end
    return MV
end
function \(A::joAbstractLinearOperator,mv::AbstractMatrix)
    isinvertible(A) || throw(joAbstractLinearOperatorException("\(jo,MultiVector) not supplied"))
    size(A,1) == size(mv,1) || throw(joAbstractLinearOperatorException("shape mismatch"))
    MV=zeros(promote_type(eltype(A),eltype(mv)),size(A,2),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A\mv[:,i]
    end
    return MV
end

# \(mvec,jo)

# \(jo,vec)
function \(A::joLinearOperator,v::AbstractVector)
    isnull(A.iop) && throw(joLinearOperatorException("\(jo,Vector) not supplied"))
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
function +(A::joLinearOperator,B::joLinearOperator)
    size(A) == size(B) || throw(joLinearOperatorException("shape mismatch"))
    S=promote_type(eltype(A),eltype(B))
    return joLinearOperator{S}("("*A.name*"+"*B.name*")",A.m,B.n,
        v1->A.fop(v1)+B.fop(v1),
        v2->A.fop_T(v2)+B.fop_T(v2),
        v3->A.fop_CT(v3)+B.fop_CT(v3),
        v4->A.fop_C(v4)+B.fop_C(v4),
        @NF, @NF, @NF, @NF
        )
end
function +(A::joAbstractLinearOperator,B::joAbstractLinearOperator)
    size(A) == size(B) || throw(joAbstractLinearOperatorException("shape mismatch"))
    S=promote_type(eltype(A),eltype(B))
    return joLinearOperator{S}("("*A.name*"+"*B.name*")",size(A,1),size(B,2),
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
function +(A::joLinearOperator,b::Number)
    S=promote_type(eltype(A),eltype(b))
    return joLinearOperator{S}("("*A.name*"+N)",A.m,A.n,
        v1->A.fop(v1)+b*joOnes(A.m,A.n)*v1,
        v2->A.fop_T(v2)+b*joOnes(A.m,A.n)*v2,
        v3->A.fop_CT(v3)+conj(b)*joOnes(A.m,A.n)*v3,
        v4->A.fop_C(v4)+conj(b)*joOnes(A.m,A.n)*v4,
        @NF, @NF, @NF, @NF
        )
end
function +(A::joAbstractLinearOperator,b::Number)
    S=promote_type(eltype(A),eltype(b))
    return joLinearOperator{S}("("*A.name*"+N)",size(A,1),size(A,2),
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
-{T}(A::joLinearOperator{T}) =
    joLinearOperator{T}("(-"*A.name*")",A.m,A.n,
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
double(A::joAbstractLinearOperator) = A*eye(A.n)

# iscomplex(jo)
iscomplex{T}(A :: joAbstractLinearOperator{T}) = !(T <: Real)

# isinvertible(jo)
isinvertible(A::joAbstractLinearOperator) = !isnull(A.iop)

# islinear(jo)
function islinear{T}(A::joAbstractLinearOperator{T};tol::Number=joTol,verb::Bool=false)
    x::Array{T,1}=rand(T,A.n)
    y::Array{T,1}=rand(T,A.n)
    Axy=A*(x+y)
    AxAy=(A*x+A*y)
    res=vecnorm(Axy-AxAy)
    test=(res < tol)
    verb ? println("Linear test passed with tol=$tol: ",test," / diffrence ",res) : test
    return test
end

# isadjoint(jo)
function isadjoint{T}(A::joAbstractLinearOperator{T};tol::Number=joTol,ctmult::Number=1,verb::Bool=false)
    x::Array{T,1}=rand(T,A.n)
    y::Array{T,1}=rand(T,A.m)
    Axy=dot(A*x,y)
    xAty=dot(x,ctmult*A'*y)
    res=abs(Axy-xAty)
    test=(res < tol)
    verb ? println("Adjoint test passed with tol=$tol ",test," / diffrence ",res) : test
    return test
end
