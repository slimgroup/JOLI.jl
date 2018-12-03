############################################################
## joMatrix - extra functions

# elements(jo)
#elements(A::joAbstractDAparallelToggleOperator) = throw(joAbstractDAparallelToggleOperatorException("elements: pointless operation for joDAdistribute/joDAgather operations"))

# hasinverse(jo)

# issquare(jo)

# istall(jo)

# iswide(jo)

# iscomplex(jo)

# islinear(jo)

# isadjoint(jo)

# isequiv
function isequiv(a::joDAdistributor,b::DArray)
    (a.procs == vec(b.pids)) || return false
    (a.idxs  == b.indices  ) || return false
    return true
end
