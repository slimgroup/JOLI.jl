############################################################
## joAbstractFosterLinearOperator - extra functions

# elements(jo)
elements(A::joLooseMatrix{DDT,RDT}) where {DDT,RDT} = A*jo_speye(DDT,A.n)
elements(A::joLooseLinearFunction{DDT,RDT}) where {DDT,RDT} = A*jo_eye(DDT,A.n)

# hasinverse(jo)
hasinverse(A::joAbstractFosterLinearOperator{DDT,RDT}) where {DDT,RDT} = !isnull(A.iop)

# issquare(jo)
issquare(A::joAbstractFosterLinearOperator{DDT,RDT}) where {DDT,RDT} = (A.m == A.n)

# istall(jo)
istall(A::joAbstractFosterLinearOperator{DDT,RDT}) where {DDT,RDT} = (A.m > A.n)

# iswide(jo)
iswide(A::joAbstractFosterLinearOperator{DDT,RDT}) where {DDT,RDT} = (A.m < A.n)

# iscomplex(jo)
iscomplex(A::joAbstractFosterLinearOperator{DDT,RDT}) where {DDT,RDT} = !(DDT<:Real && RDT<:Real)

# islinear(jo)

# isadjoint(jo)

