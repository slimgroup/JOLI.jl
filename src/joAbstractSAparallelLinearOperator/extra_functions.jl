############################################################
## joAbstractSAparallelLinearOperator - extra functions

# elements(jo)
elements(A::joAbstractSAparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = A*jo_eye(DDT,A.n)

# hasinverse(jo)
hasinverse(A::joAbstractSAparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = !isnull(A.iop)

# issquare(jo)
issquare(A::joAbstractSAparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = (A.m == A.n)

# istall(jo)
istall(A::joAbstractSAparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = (A.m > A.n)

# iswide(jo)
iswide(A::joAbstractSAparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = (A.m < A.n)

# iscomplex(jo)
iscomplex(A::joAbstractSAparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = !(DDT<:Real && RDT<:Real)

# islinear(jo)
#function islinear(A::joAbstractSAparallelLinearOperator{DDT,RDT},samples::Integer=3;tol::Float64=0.,verbose::Bool=false) where {DDT,RDT}
#end

# isadjoint(jo)
#function isadjoint(A::joAbstractSAparallelLinearOperator{DDT,RDT},samples::Integer=3;tol::Float64=0.,normfactor::Real=1.,userange::Bool=false,verbose::Bool=false) where {DDT,RDT}
#end

