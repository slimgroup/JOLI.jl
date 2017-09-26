############################################################
## joLooseMatrix - extra functions

# elements(jo)
elements{DDT,RDT}(A::joLooseMatrix{DDT,RDT}) = A*speye(DDT,A.n)

# hasinverse(jo)

# issquare(jo)

# istall(jo)

# iswide(jo)

# iscomplex(jo)

# islinear(jo)

# isadjoint(jo)

