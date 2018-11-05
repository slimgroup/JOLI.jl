module Seismic

    using JOLI

    # convert shot record to common-midpoint offset
    include("Seismic/joSRtoCMO.jl")

    # units-dependent Radon transform
    include("Seismic/joRadon.jl")

    # units-dependent NMO transform
    include("Seismic/joNMO.jl")
end
