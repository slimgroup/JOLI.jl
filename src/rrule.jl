function Flux.Zygote.ChainRulesCore.rrule(::typeof(*), A::joAbstractLinearOperator{ADDT,ARDT}, v) where {ADDT,ARDT}
  Y = A*v
  function time_pullback(dy)
    DY = Flux.Zygote.unthunk(dy)
    return Flux.Zygote.NoTangent(), Flux.Zygote.NoTangent(), Flux.Zygote.@thunk(A' * DY)
  end
  return Y, time_pullback
end

function *(A::joAbstractLinearOperator{ADDT,ARDT}, v::Flux.Zygote.FillArrays.Fill{vDT,1}) where {ADDT,ARDT,vDT<:Number}
    A*Vector(v)
end