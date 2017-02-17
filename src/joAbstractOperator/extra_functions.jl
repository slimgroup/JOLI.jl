############################################################
## joAbstractOperator - extra functions

# double(jo)
double(A::joAbstractOperator)  = throw(joAbstractOperatorException("double(jo) not implemented"))

# iscomplex(jo)
iscomplex(A :: joAbstractOperator) = throw(joAbstractOperatorException("iscomplex(jo) not implemented"))

# isinvertible(jo)
isinvertible(A::joAbstractOperator) = throw(joAbstractOperatorException("isinvertible(jo) not implemented"))

# islinear(jo)
islinear(A::joAbstractOperator,v::Bool=false) = throw(joAbstractOperatorException("islinear(jo) not implemented"))

# isadjoint(jo)
isadjoint(A::joAbstractOperator,ctmult::Number=1,v::Bool=false) = throw(joAbstractOperatorException("isadjoint(jo) not implemented"))

