############################################################
## joAbstractOperator - extra functions

# elements(jo)
elements(A::joAbstractOperator)  = jo_method_error(A,"elements(jo) not implemented")

# hasinverse(jo)
hasinverse(A::joAbstractOperator) = jo_method_error(A,"hasinverse(jo) not implemented")

# issquare(jo)
issquare(A::joAbstractOperator) = jo_method_error(A,"issquare(jo) not implemented")

# istall(jo)
istall(A::joAbstractOperator) = jo_method_error(A,"istall(jo) not implemented")

# iswide(jo)
iswide(A::joAbstractOperator) = jo_method_error(A,"iswide(jo) not implemented")

# iscomplex(jo)
iscomplex(A::joAbstractOperator) = jo_method_error(A,"iscomplex(jo) not implemented")

# islinear(jo)
islinear(A::joAbstractOperator) = jo_method_error(A,"islinear(jo) not implemented")

# isadjoint(jo)
isadjoint(A::joAbstractOperator) = jo_method_error(A,"isadjoint(jo) not implemented")

# joAddSolver(jo)
joAddSolverAny(A::joAbstractOperator,args::Function...) = jo_method_error(A,"joAddSolverAny(jo) not implemented")
joAddSolverAll(A::joAbstractOperator,args::Function...) = jo_method_error(A,"joAddSolverAll(jo) not implemented")

# isequiv

