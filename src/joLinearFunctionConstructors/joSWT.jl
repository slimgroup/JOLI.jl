# DWT operators: joDWT

## helper module
module joSWT_etc
    using JOLI: jo_convert
    using PythonCall

    const pywt = PythonCall.pynew()

    function __init__()
        PythonCall.pycopy!(pywt, pyimport("pywt"))
    end

    # 1D
    function apply_swt(v::Vector{vdt}, wt::String, L::Integer,rdt::DataType,pad::Integer) where vdt<:Union{AbstractFloat,Complex}
        v = [v;zeros(vdt, pad)]
        rv = pywt.swt(v, wt, level=L, start_level=0, norm=true, trim_approx=true)
        rv = vcat([PyArray(r) for r in rv]...)
        rv = jo_convert(rdt, rv, false)
        return rv
    end

    function apply_iswt(v::Vector{vdt},wt::String,L::Integer,rdt::DataType,pad::Integer) where vdt<:Union{AbstractFloat,Complex}
        v = reshape(v, :, L+1)
        v = [v[:, i] for i=1:L+1]
        rv = PyArray(pywt.iswt(v, wt, norm=true))
        # Convert and remove pad
        rv = jo_convert(rdt, rv[1:end-pad], false)
        return rv
    end

end
using .joSWT_etc

export joSWT
"""
    julia> op = joSWT(m,[wt,];[L=...,][DDT=...,][RDT=...])

1-dimensional SWT transform based on PyWavelets. Only 1D is supported currently in JOLI but n-dimensional supported in PyWavelets.
Choice of wavelet is fixed to "db20"

# Signature

    function joSWT(m::Integer, wt::String="db20";
        L::Integer=maxtransformlevels(min(m,n)),
        DDT::DataType=joFloat,RDT::DataType=DDT,
        name::String="joDWT")

# Arguments

- `m`: dimention
- optional
    - `wt`: wavelet filter ("db20" by default) see for options:
    https://github.com/PyWavelets/pywt/blob/master/pywt/_extensions/wavelets_list.pxi
- keywords
    - `L`: number of levels
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Notes

- only 1D arrays are supported for now due to limitations of author time.
- only orthogonal wavelets should be used from ["haar", "db", "sym", "coif"] to have access to adjoint via inverse.

# Examples

1D DWT with default wavelet (Daubechie20 wavelet)

    joSWT(m)

examples with DDT/RDT

    joDWT(m,"db20"; DDT=Float32)
    joDWT(m,"sym5"; DDT=Float32,RDT=Float64)

"""
function joSWT(m::Integer, wt::String="db20";
    L::Integer=maxtransformlevels(m + m%2),
    DDT::DataType=joFloat,RDT::DataType=DDT,
    name::String="joSWT")

    # Only work with even number of points
    pad = m%2
    n = (L+1)*(m + pad)
    return joLinearFunction_A(n,m,
        v1->joSWT_etc.apply_swt(v1, wt, L, RDT, pad),
        v2->joSWT_etc.apply_iswt(v2, wt, L, DDT, pad),
        v3->joSWT_etc.apply_iswt(v3, wt, L, DDT, pad),
        v4->joSWT_etc.apply_swt(v4, wt, L, RDT, pad),
        DDT,RDT;
        name=name)
end

joSWT(m::Integer, wt::Py; kwargs...) = joSWT(m, string(wt); kwargs...)
