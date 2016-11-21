############################################################
# joLinearOperator #########################################
############################################################

export joLinearOperator, joLinearOperatorException

############################################################
## type definition

abstract joLinearOperator{T} <: joAbstractOperator{T}

type joLinearOperatorException <: Exception
    msg :: String
end

############################################################
## outer constructors

############################################################
## overloaded Base functions

# eltype(jo)
eltype{T}(A::joLinearOperator{T}) = T

# show(jo)
show(A::joLinearOperator) = println((typeof(A),A.name,A.m,A.n))

# showall(jo)
showall(A::joLinearOperator) = println((typeof(A),A.name,A.m,A.n))

# display(jo)
display(A::joLinearOperator) = show(A)

# size(jo)
size(A::joLinearOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joLinearOperator,ind::Int64)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	else
		throw(joLinearOperatorException("invalid index"))
	end
end

# length(jo)
length(A::joLinearOperator) = A.m*A.n

# full(jo)
full(A::joLinearOperator) = A*eye(A.n)

# norm(jo)
norm(A::joLinearOperator,p::Real=2) = norm(double(A),p)

# vecnorm(jo)
vecnorm(A::joLinearOperator,p::Real=2) = vecnorm(double(A),p)

# transpose(jo)
transpose(A::joLinearOperator) = throw(joLinearOperatorException("(jo).' not implemented"))

# ctranspose(jo)
ctranspose(A::joLinearOperator) = throw(joLinearOperatorException("(jo)' not implemented"))

# conj(jo)
conj(A::joLinearOperator) = throw(joLinearOperatorException("conj(jo) not implemented"))

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
*(A::joLinearOperator,B::joLinearOperator) = throw(joLinearOperatorException("*(jo,jo) not implemented"))

# *(jo,mvec)
function *(A::joLinearOperator,mv::AbstractMatrix)
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
    ##isnull(A.fop) && throw(joLinearOperatorException("*(jo,Vector) not supplied"))
    size(A, 2) == size(v, 1) || throw(joLinearOperatorException("shape mismatch"))
    return A*v
end

# *(vec,jo)

# *(num,jo)
*(a::Number,A::joLinearOperator) = throw(joLinearOperatorException("*(jo,num) not implemented"))

# *(jo,num)
*(A::joLinearOperator,a::Number) = a*A

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)

# \(jo,mvec)
function \(A::joLinearOperator,mv::AbstractMatrix)
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
function \(A::joLinearOperator,v::AbstractVector)
    isnull(A.iop) && throw(joLinearOperatorException("\(jo,Vector) not supplied"))
    size(A, 1) == size(v, 1) || throw(joLinearOperatorException("shape mismatch"))
    return A\v
end

# \(vec,jo)

# \(num,jo)

# \(jo,num)

############################################################
## overloaded Base +(...jo...)

# +(jo)
+(A::joLinearOperator) = A

# +(jo,jo)
+(A::joLinearOperator,B::joLinearOperator) = throw(joLinearOperatorException("+(jo,jo) not implemented"))

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)
+(A::joLinearOperator,b::Number) = throw(joLinearOperatorException("+(jo,num) not implemented"))

# +(num,jo)
+(b::Number,A::joLinearOperator) = A+b

############################################################
## overloaded Base -(...jo...)

# -(jo)
-(A::joLinearOperator) = throw(joLinearOperatorException("-(jo) not implemented"))

# -(jo,jo)
-(A::joLinearOperator,B::joLinearOperator) = A+(-B)

# -(jo,mvec)

# -(mvec,jo)

# -(jo,vec)

# -(vec,jo)

# -(jo,num)
-(A::joLinearOperator,b::Number) = A+(-b)

# -(num,jo)
-(b::Number,A::joLinearOperator) = -A+b

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

double(A::joLinearOperator) = A*speye(A.n)

