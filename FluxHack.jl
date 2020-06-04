# Here is the hack for example below
module JOLI4Flux
    using JOLI: joAbstractLinearOperator
    using Tracker
    import Base.*
    import Tracker.@grad

    *(x::joAbstractLinearOperator,y::TrackedVector) = Tracker.track(*, x, y)

    @grad a::joAbstractLinearOperator * b::AbstractVecOrMat = 
        Tracker.data(a)*Tracker.data(b), Δ -> (Δ * transpose(b), transpose(a) * Δ)
end
# end of hack

using Flux
using JOLI

A = joGaussian(10,100)
eA = elements(A)

m = Conv((3, 3), 1=>1, pad=1, stride=1);

x = randn(10,10,1,1);

y = A * vec(m(x))
display(y);println()

