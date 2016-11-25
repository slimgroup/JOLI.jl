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

# transpose(jo)
transpose{T}(A::joLinearOperator{T}) = joLinearOperator{T}(""*A.name*".'",A.n,A.m,
    get(A.fop_T),@NF(A.fop),A.fop_C,A.fop_CT,
    A.iop_T,A.iop,A.iop_C,A.iop_CT)

# ctranspose(jo)
ctranspose{T}(A::joLinearOperator{T}) = joLinearOperator{T}(""*A.name*"'",A.n,A.m,
    get(A.fop_CT),A.fop_C,@NF(A.fop),A.fop_T,
    A.iop_CT,A.iop_C,A.iop,A.iop_T)

# conj(jo)
conj{T}(A::joLinearOperator{T}) = joLinearOperator{T}("conj("*A.name*")",A.m,A.n,
    get(A.fop_C),A.fop_CT,A.fop_T,@NF(A.fop),
    A.iop_C,A.iop_CT,A.iop_T,A.iop)

# isreal(jo)
isreal{T}(A :: joAbstractLinearOperator{T}) = T <: Real

# issymmetric(jo)
issymmetric(A::joAbstractLinearOperator) = (A.m == A.n && (vecnorm(double(A)-double(A.')) < joTol))

# ishermitian(jo)
ishermitian(A::joAbstractLinearOperator) = (A.m == A.n && (vecnorm(double(A)-double(A')) < joTol))

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
function *(A::joAbstractLinearOperator,B::joAbstractLinearOperator)
    size(A,2) == size(B,1) || throw(joLinearOperatorException("shape mismatch"))
    S=promote_type(eltype(A),eltype(B))
    return joLinearOperator{S}("("*A.name*"*"*B.name*")",size(A,1),size(B,2),
    v1->A*(B*v1),v2->B.'*(A.'*v2),
    @NF(v3->B'*(A'*v3)),@NF(v4->conj(A)*(conj(B)*v4)),
    @NF, @NF, @NF, @NF)
end

# *(jo,mvec)
function *(A::joAbstractLinearOperator,mv::AbstractMatrix)
    ##isnull(A.fop) && throw(joLinearOperatorException("*(jo,MultiVector) not supplied"))
    size(A, 2) == size(mv, 1) || throw(joLinearOperatorException("shape mismatch"))
    MV=zeros(promote_type(eltype(A),eltype(mv)),size(A,1),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A*mv[:,i]
    end
    return MV
end

# *(mvec,jo)

# *(jo,vec)
function *(A::joLinearOperator,v::AbstractVector)
    size(A, 2) == size(v, 1) || throw(joLinearOperatorException("shape mismatch"))
    return A.fop(v)
end

# *(vec,jo)

# *(num,jo)
*(a::Number,A::joAbstractLinearOperator) = throw(joLinearOperatorException("*(jo,num) not implemented"))

# *(jo,num)
*(A::joAbstractLinearOperator,a::Number) = a*A

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)

# \(jo,mvec)
function \(A::joAbstractLinearOperator,mv::AbstractMatrix)
    isnull(A.iop) && throw(joLinearOperatorException("\(jo,MultiVector) not supplied"))
    size(A, 1) == size(mv, 1) || throw(joLinearOperatorException("shape mismatch"))
    MV=zeros(promote_type(eltype(A),eltype(mv)),size(A,2),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A\mv[:,i]
    end
    return MV
end

# \(mvec,jo)

# \(jo,vec)
function \(A::joAbstractLinearOperator,v::AbstractVector)
    isnull(A.iop) && throw(joLinearOperatorException("\(jo,Vector) not supplied"))
    size(A, 1) == size(v, 1) || throw(joLinearOperatorException("shape mismatch"))
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
    return joLinearOperator{S}("("*A.name*"+"*B.name*")",size(A,1),size(B,2),
    v1->A.fop(v1)+B.fop(v1),v2->A.fop_T(v2)+B.fop_T(v2),
    v3->A.fop_CT(v3)+B.fop_CT(v3),v4->A.fop_C(v4)+B.fop_C(v4),
    @NF, @NF, @NF, @NF)
end

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)
+(A::joAbstractLinearOperator,b::Number) = throw(joLinearOperatorException("+(jo,num) not implemented"))

# +(num,jo)
+(b::Number,A::joAbstractLinearOperator) = A+b

############################################################
## overloaded Base -(...jo...)

# -(jo)
-{T}(A::joLinearOperator{T}) = joLinearOperator{T}("(-"*A.name*")",A.m,A.n,
    v1->-A.fop(v1),     v2->-A.fop_T(v2),     v3->-A.fop_CT(v3),     v4->-A.fop_C(v4),
    v5->-get(A.iop)(v5),v6->-get(A.iop_T)(v6),v7->-get(A.iop_CT)(v7),v8->-get(A.iop_C)(v8))

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
function islinear{T}(A::joAbstractLinearOperator{T},v::Bool=false)
    x::Array{T,1}=rand(T,A.n)
    y::Array{T,1}=rand(T,A.n)
    Axy=A*(x+y)
    AxAy=(A*x+A*y)
    res=vecnorm(Axy-AxAy)
    test=(res < joTol)
    v ? println("Linear test passed with tol=$joTol: ",test," / diffrence ",res) : test
    return test
end

# isadjoint(jo)
function isadjoint{T}(A::joAbstractLinearOperator{T},ctmult::Number=1,v::Bool=false)
    x::Array{T,1}=rand(T,A.n)
    y::Array{T,1}=rand(T,A.m)
    Axy=dot(A*x,y)
    xAty=dot(x,ctmult*A'*y)
    res=abs(Axy-xAty)
    test=(res < joTol)
    v ? println("Adjoint test passed with tol=$joTol: ",test," / diffrence ",res) : test
    return test
end
