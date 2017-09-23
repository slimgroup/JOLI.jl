############################################################
## joMatrix - extra functions

# elements(jo)
elements{DDT,RDT}(A::joMatrix{DDT,RDT}) = A*speye(DDT,A.n)

# hasinverse(jo)

# issquare(jo)

# istall(jo)

# iswide(jo)

# iscomplex(jo)

# islinear(jo)

# isadjoint(jo)

