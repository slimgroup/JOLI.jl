############################################################
# joAbstractOperator #######################################
############################################################

############################################################
## type definition

export joAbstractOperator, joAbstractOperatorException

abstract joAbstractOperator{T}

type joAbstractOperatorException <: Exception
    msg :: String
end

############################################################
## overloaded Base functions

eltype{T}(A::joAbstractOperator{T}) = T

show(A::joAbstractOperator) = throw(joAbstractOperatorException("show(jo) not implemented"))

showall(A::joAbstractOperator) = throw(joAbstractOperatorException("showall(jo) not implemented"))

display(A::joAbstractOperator) = throw(joAbstractOperatorException("display(jo) not implemented"))

full(A::joAbstractOperator) = throw(joAbstractOperatorException("full(jo) not implemented"))

size(A::joAbstractOperator) = throw(joAbstractOperatorException("size(jo) not implemented"))

size(A::joAbstractOperator,ind::Int64) = throw(joAbstractOperatorException("size(jo,1/2) not implemented"))

length(A::joAbstractOperator) = throw(joAbstractOperatorException("length(jo) not implemented"))

norm(A::joAbstractOperator,p::Real=2) = throw(joAbstractOperatorException("norm(jo) not implemented"))

vecnorm(A::joAbstractOperator,p::Real=2) = throw(joAbstractOperatorException("vecnorm(jo) not implemented"))

transpose(A::joAbstractOperator) = throw(joAbstractOperatorException("jo.' not implemented"))

ctranspose(A::joAbstractOperator) = throw(joAbstractOperatorException("jo' not implemented"))

conj(A::joAbstractOperator) = throw(joAbstractOperatorException("conj(jo) not implemented"))

############################################################
## overloaded Base *(...joAbstractOperator...)

*(A::joAbstractOperator,B::joAbstractOperator) = throw(joAbstractOperatorException("*(jo,jo) not implemented"))

*(A::joAbstractOperator,v::AbstractVector) = throw(joAbstractOperatorException("*(jo,vec) not implemented"))

*(A::joAbstractOperator,mv::AbstractMatrix) = throw(joAbstractOperatorException("*(jo,m-vec) not implemented"))

*(a::Number,A::joAbstractOperator) = throw(joAbstractOperatorException("*(Number,jo) not implemented"))

*(A::joAbstractOperator,a::Number) = throw(joAbstractOperatorException("*(jo,Number) not implemented"))

############################################################
## overloaded Base \(...joAbstractOperator...)

\(A::joAbstractOperator,v::AbstractVector) = throw(joAbstractOperatorException("\(jo,vec) not implemented"))

\(A::joAbstractOperator,mv::AbstractMatrix) = throw(joAbstractOperatorException("\(jo,m-vec) not implemented"))

############################################################
## overloaded Base +(...joAbstractOperator...)

+(A::joAbstractOperator)  = throw(joAbstractOperatorException("+(jo) not implemented"))

+(A::joAbstractOperator,B::joAbstractOperator) = throw(joAbstractOperatorException("+(jo,jo) not implemented"))

+(A::joAbstractOperator,b::Number) = throw(joAbstractOperatorException("+(jo,Number) not implemented"))

+(b::Number,A::joAbstractOperator)  = throw(joAbstractOperatorException("+(Number,jo) not implemented"))

############################################################
## overloaded Base -(...joAbstractOperator...)

-(A::joAbstractOperator) = throw(joAbstractOperatorException("-(jo) not implemented"))

-(A::joAbstractOperator,B::joAbstractOperator)  = throw(joAbstractOperatorException("-(jo,jo) not implemented"))

-(A::joAbstractOperator,b::Number)  = throw(joAbstractOperatorException("-(jo,Number) not implemented"))

-(b::Number,A::joAbstractOperator)  = throw(joAbstractOperatorException("-(Number,jo).' not implemented"))

############################################################
## extra methods

double(A::joAbstractOperator)  = throw(joAbstractOperatorException("double(jo) not implemented"))

