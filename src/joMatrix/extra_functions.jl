############################################################
## joMatrix - extra functions

# elements(jo)
elements(A::joMatrix{DDT,RDT}) where {DDT,RDT} = A*speye(DDT,A.n)

# hasinverse(jo)

# issquare(jo)

# istall(jo)

# iswide(jo)

# iscomplex(jo)

# islinear(jo)

# isadjoint(jo)

