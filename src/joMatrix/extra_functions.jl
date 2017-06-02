############################################################
## joMatrix - extra functions
# un-implemented methods are defined in joLinearOperator/extra_functions.jl

# elements(jo)
elements{DDT,RDT}(A::joMatrix{DDT,RDT}) = A*speye(DDT,A.n)

# hasinverse(jo)

# issquare(jo)

# iscomplex(jo)

# islinear(jo)

# isadjoint(jo)

