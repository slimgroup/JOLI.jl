############################################################
## joAbstractOperator - extra functions

# elements(jo)
elements(A::joAbstractOperator)  = throw(joAbstractOperatorException("elements(jo) not implemented"))

# iscomplex(jo)
iscomplex(A :: joAbstractOperator) = throw(joAbstractOperatorException("iscomplex(jo) not implemented"))

# isinvertible(jo)
isinvertible(A::joAbstractOperator) = throw(joAbstractOperatorException("isinvertible(jo) not implemented"))

# islinear(jo)
islinear(A::joAbstractOperator) = throw(joAbstractOperatorException("islinear(jo) not implemented"))

# isadjoint(jo)
isadjoint(A::joAbstractOperator) = throw(joAbstractOperatorException("isadjoint(jo) not implemented"))

