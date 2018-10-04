############################################################
## joLooseMatrix - extra functions

# elements(jo)
elements(A::joLooseMatrix{DDT,RDT}) where {DDT,RDT} = A*jo_speye(DDT,A.n)

# hasinverse(jo)

# issquare(jo)

# istall(jo)

# iswide(jo)

# iscomplex(jo)

# islinear(jo)

# isadjoint(jo)

