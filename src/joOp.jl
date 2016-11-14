## joOp ##

##################
## type definition

export joOp, joOpException

abstract joOp{T}

type joOpException <: Exception
    msg :: String
end

##########################
## overloaded Base methods

eltype{T}(A::joOp{T}) = T

#show(A::joOp) = println((typeof(A),A.name,A.m,A.n,typeof(A.linop)))
show(A::joOp) = println((typeof(A),A.name,A.m,A.n))
showall(A::joOp) = println((typeof(A),A.name,A.m,A.n))
display(A::joOp) = show(A)
full(A::joOp) = A*eye(A.n)


size(A::joOp) = A.m,A.n

function size(A::joOp,ind::Int64)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	else
		throw(joOpException("invalid index"))
	end
end

length(A::joOp) = A.m*A.n

norm(A::joOp,p::Real=2) = norm(double(A),p)

vecnorm(A::joOp,p::Real=2) = vecnorm(double(A),p)

transpose(A::joOp) = throw(joOpException("(jo).' not implemented"))

ctranspose(A::joOp) = throw(joOpException("(jo)' not implemented"))

*(A::joOp,B::joOp) = throw(joOpException("*(jo,jo) not implemented"))
function *(A::joOp,v::AbstractVector)
    size(A, 2) == size(v, 1) || throw(joOpException("shape mismatch"))
    return A*v
end
function *(A::joOp,mv::AbstractMatrix)
    size(A, 2) == size(mv, 1) || throw(joOpException("shape mismatch"))
    MV=zeros(promote_type(eltype(A),eltype(mv)),size(A,1),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A*mv[:,i]
    end
    return MV
end
*(a::Number,A::joOp) = throw(joOpException("*(jo,Number) not implemented"))
*(A::joOp,a::Number) = a*A

function \(A::joOp,v::AbstractVector)
    size(A, 1) == size(v, 1) || throw(joOpException("shape mismatch"))
    return A\v
end
function \(A::joOp,mv::AbstractMatrix)
    size(A, 1) == size(mv, 1) || throw(joOpException("shape mismatch"))
    MV=zeros(promote_type(eltype(A),eltype(mv)),size(A,2),size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A\mv[:,i]
    end
    return MV
end


+(A::joOp) = A
+(A::joOp,B::joOp) = throw(joOpException("+(jo,jo) not implemented"))
+(A::joOp,b::Number) = throw(joOpException("+(jo,Number) not implemented"))
+(b::Number,A::joOp) = A+b

-(A::joOp) = throw(joOpException("-(jo) not implemented"))
-(A::joOp,B::joOp) = A+(-B)
-(A::joOp,b::Number) = A+(-b)
-(b::Number,A::joOp) = -A+b

################
## extra methods

double(A::joOp) = A*speye(A.n)

