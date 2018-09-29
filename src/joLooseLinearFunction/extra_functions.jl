############################################################
## joLooseLinearFunction - extra functions

# elements(jo)
elements(A::joLooseLinearFunction{DDT,RDT}) where {DDT,RDT} = A*eye(DDT,A.n)

# hasinverse(jo)

# issquare(jo)

# istall(jo)

# iswide(jo)

# iscomplex(jo)

# islinear(jo)

# isadjoint(jo)

