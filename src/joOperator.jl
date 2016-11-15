############################################################
# joOperator ###############################################
############################################################

##################
## type definition

export joOperator, joOperatorException

abstract joOperator{T}

type joOperatorException <: Exception
    msg :: String
end

##########################
## overloaded Base methods

eltype{T}(A::joOperator{T}) = T

#show(A::joOperator) = println((typeof(A),A.name,A.m,A.n,typeof(A.linop)))
show(A::joOperator) = println((typeof(A),A.name,A.m,A.n))
showall(A::joOperator) = println((typeof(A),A.name,A.m,A.n))
display(A::joOperator) = show(A)
full(A::joOperator) = A*eye(A.n)


size(A::joOperator) = A.m,A.n

function size(A::joOperator,ind::Int64)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	else
		throw(joOperatorException("invalid index"))
	end
end

length(A::joOperator) = A.m*A.n

norm(A::joOperator,p::Real=2) = norm(double(A),p)

vecnorm(A::joOperator,p::Real=2) = vecnorm(double(A),p)

transpose(A::joOperator) = throw(joOperatorException("(jo).' not implemented"))

ctranspose(A::joOperator) = throw(joOperatorException("(jo)' not implemented"))

*(A::joOperator,B::joOperator) = throw(joOperatorException("*(jo,jo) not implemented"))
function *(A::joOperator,v::AbstractVector)
    size(A, 2) == size(v, 1) || throw(joOperatorException("shape mismatch"))
    return A*v
end
function *(A::joOperator,mv::AbstractMatrix)
    size(A, 2) == size(mv, 1) || throw(joOperatorException("shape mismatch"))
    MV=zeros(promote_type(eltype(A),eltype(mv)),size(A,1),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A*mv[:,i]
    end
    return MV
end
*(a::Number,A::joOperator) = throw(joOperatorException("*(jo,Number) not implemented"))
*(A::joOperator,a::Number) = a*A

function \(A::joOperator,v::AbstractVector)
    size(A, 1) == size(v, 1) || throw(joOperatorException("shape mismatch"))
    return A\v
end
function \(A::joOperator,mv::AbstractMatrix)
    size(A, 1) == size(mv, 1) || throw(joOperatorException("shape mismatch"))
    MV=zeros(promote_type(eltype(A),eltype(mv)),size(A,2),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A\mv[:,i]
    end
    return MV
end


+(A::joOperator) = A
+(A::joOperator,B::joOperator) = throw(joOperatorException("+(jo,jo) not implemented"))
+(A::joOperator,b::Number) = throw(joOperatorException("+(jo,Number) not implemented"))
+(b::Number,A::joOperator) = A+b

-(A::joOperator) = throw(joOperatorException("-(jo) not implemented"))
-(A::joOperator,B::joOperator) = A+(-B)
-(A::joOperator,b::Number) = A+(-b)
-(b::Number,A::joOperator) = -A+b

################
## extra methods

double(A::joOperator) = A*speye(A.n)

