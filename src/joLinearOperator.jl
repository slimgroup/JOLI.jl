############################################################
# joLinearOperator #########################################
############################################################

############################################################
## type definition

export joLinearOperator, joLinearOperatorException

abstract joLinearOperator{T} <: joAbstractOperator{T}

type joLinearOperatorException <: Exception
    msg :: String
end

############################################################
## overloaded Base functions

eltype{T}(A::joLinearOperator{T}) = T

show(A::joLinearOperator) = println((typeof(A),A.name,A.m,A.n))

showall(A::joLinearOperator) = println((typeof(A),A.name,A.m,A.n))

display(A::joLinearOperator) = show(A)

full(A::joLinearOperator) = A*eye(A.n)

size(A::joLinearOperator) = A.m,A.n

function size(A::joLinearOperator,ind::Int64)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	else
		throw(joLinearOperatorException("invalid index"))
	end
end

length(A::joLinearOperator) = A.m*A.n

norm(A::joLinearOperator,p::Real=2) = norm(double(A),p)

vecnorm(A::joLinearOperator,p::Real=2) = vecnorm(double(A),p)

transpose(A::joLinearOperator) = throw(joLinearOperatorException("(jo).' not implemented"))

ctranspose(A::joLinearOperator) = throw(joLinearOperatorException("(jo)' not implemented"))

conj(A::joLinearOperator) = throw(joLinearOperatorException("conj(jo) not implemented"))

############################################################
## overloaded Base *(...joOPerator...)

*(A::joLinearOperator,B::joLinearOperator) = throw(joLinearOperatorException("*(jo,jo) not implemented"))
function *(A::joLinearOperator,v::AbstractVector)
    size(A, 2) == size(v, 1) || throw(joLinearOperatorException("shape mismatch"))
    return A*v
end

function *(A::joLinearOperator,mv::AbstractMatrix)
    size(A, 2) == size(mv, 1) || throw(joLinearOperatorException("shape mismatch"))
    MV=zeros(promote_type(eltype(A),eltype(mv)),size(A,1),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A*mv[:,i]
    end
    return MV
end

*(a::Number,A::joLinearOperator) = throw(joLinearOperatorException("*(jo,Number) not implemented"))

*(A::joLinearOperator,a::Number) = a*A

############################################################
## overloaded Base \(...joOPerator...)

function \(A::joLinearOperator,v::AbstractVector)
    isnull(A.iop) && throw(joLinearOperatorException("\(jo,Vector) not implemented"))
    size(A, 1) == size(v, 1) || throw(joLinearOperatorException("shape mismatch"))
    return A\v
end

function \(A::joLinearOperator,mv::AbstractMatrix)
    isnull(A.iop) && throw(joLinearOperatorException("\(jo,MultiVector) not implemented"))
    size(A, 1) == size(mv, 1) || throw(joLinearOperatorException("shape mismatch"))
    MV=zeros(promote_type(eltype(A),eltype(mv)),size(A,2),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A\mv[:,i]
    end
    return MV
end

############################################################
## overloaded Base +(...joOPerator...)

+(A::joLinearOperator) = A

+(A::joLinearOperator,B::joLinearOperator) = throw(joLinearOperatorException("+(jo,jo) not implemented"))

+(A::joLinearOperator,b::Number) = throw(joLinearOperatorException("+(jo,Number) not implemented"))

+(b::Number,A::joLinearOperator) = A+b

############################################################
## overloaded Base -(...joOPerator...)

-(A::joLinearOperator) = throw(joLinearOperatorException("-(jo) not implemented"))

-(A::joLinearOperator,B::joLinearOperator) = A+(-B)

-(A::joLinearOperator,b::Number) = A+(-b)

-(b::Number,A::joLinearOperator) = -A+b

############################################################
## extra methods

double(A::joLinearOperator) = A*speye(A.n)

