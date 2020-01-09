############################################################
## joAbstractDMVparallelLinearOperator - extra functions

# elements(jo)
elements(A::joAbstractDMVparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = A*jo_eye(DDT,A.n)

# hasinverse(jo)
hasinverse(A::joAbstractDMVparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = !isnull(A.iop)

# issquare(jo)
issquare(A::joAbstractDMVparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = (A.m == A.n)

# istall(jo)
istall(A::joAbstractDMVparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = (A.m > A.n)

# iswide(jo)
iswide(A::joAbstractDMVparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = (A.m < A.n)

# iscomplex(jo)
iscomplex(A::joAbstractDMVparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = !(DDT<:Real && RDT<:Real)

# islinear(jo)
#function islinear(A::joAbstractDMVparallelLinearOperator{DDT,RDT},samples::Integer=3;tol::Float64=0.,verbose::Bool=false) where {DDT,RDT}
#end

# isadjoint(jo)
#function isadjoint(A::joAbstractDMVparallelLinearOperator{DDT,RDT},samples::Integer=3;tol::Float64=0.,normfactor::Real=1.,userange::Bool=false,verbose::Bool=false) where {DDT,RDT}
#end

