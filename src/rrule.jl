function rrule(::typeof(*), A::joAbstractLinearOperator{ADDT,ARDT}, v) where {ADDT,ARDT}
  Y = A*v
  function time_pullback(dy)
    DY = unthunk(Vector(dy))
    return NoTangent(), NoTangent(), @thunk(A' * DY)
  end
  return Y, time_pullback
end
