# DWT operators: joDWT

## helper module
module joDWT_etc
    using JOLI: jo_convert
    using Wavelets
    # 1D
    function apply_dwt(v::AbstractVector{<:Number},m::Integer,wt::OrthoFilter,L::Integer,rdt::DataType)
        rv=dwt(v,wt,L)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_idwt(v::AbstractVector{<:Number},m::Integer,wt::OrthoFilter,L::Integer,rdt::DataType)
        rv=idwt(v,wt,L)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    # 2D
    function apply_dwt(v::AbstractVector{<:Number},m::Integer,n::Integer,wt::OrthoFilter,L::Integer,rdt::DataType)
        rv=reshape(v,m,n)
        rv=dwt(rv,wt,L)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_idwt(v::AbstractVector{<:Number},m::Integer,n::Integer,wt::OrthoFilter,L::Integer,rdt::DataType)
        rv=reshape(v,m,n)
        rv=idwt(rv,wt,L)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
end
using .joDWT_etc

export joDWT
"""
    julia> joDWT(m,wt)
    julia> joDWT(m,n,wt)

1/2-dimensional DWT transform over fast dimension(s) - based on Wavelets.jl. See Wavelets.jl package form more information.

# Signature

    joDWT(m,[wt=wavelet(WT.haar);L=maxtransformlevels(m),DDT=joFloat,RDT=DDT])
    joDWT(m,n,[wt=wavelet(WT.haar);L=maxtransformlevels(min(m,n)),DDT=joFloat,RDT=DDT])

# Arguments

- `M` and `N`: dimentions
- `L`: number of levels
- `wt`: wavelet filter
- `DDT` and `RDT`: domain and range types

# Notes

- only square 2D arrays are supported for now due to limitations of Wavelets.jl package

# Examples

- wt=wavelet(WT.haar) - define wavelet
- joDWT(m,wt) - 1D DWT
- joDWT(m,n,wt) - 2D DWT
- joDWT(m,wt; DDT=Float32) - 1D DWT for 32-bit vectors
- joDWT(m,wt; DDT=Float32,RDT=Float64) - 1D DWT for 32-bit input and 64-bit output

"""
function joDWT(m::Integer,wt::OrthoFilter=wavelet(WT.haar);L::Integer=maxtransformlevels(m),DDT::DataType=joFloat,RDT::DataType=DDT)
    return joLinearFunctionCT(m,m,
        v1->joDWT_etc.apply_dwt(v1,m,wt,L,RDT),
        v2->joDWT_etc.apply_idwt(v2,m,wt,L,DDT),
        v3->joDWT_etc.apply_idwt(v3,m,wt,L,DDT),
        v4->joDWT_etc.apply_dwt(v4,m,wt,L,RDT),
        DDT,RDT;
        name="joDWT")
end
function joDWT(m::Integer,n::Integer,wt::OrthoFilter=wavelet(WT.haar);L::Integer=maxtransformlevels(min(m,n)),DDT::DataType=joFloat,RDT::DataType=DDT)
    (m!=n && n!=1) && throw(joLinearFunctionException("joDWT: only square images are supported for now"))
    return joLinearFunctionCT(m*n,m*n,
        v1->joDWT_etc.apply_dwt(v1,m,n,wt,L,RDT),
        v2->joDWT_etc.apply_idwt(v2,m,n,wt,L,DDT),
        v3->joDWT_etc.apply_idwt(v3,m,n,wt,L,DDT),
        v4->joDWT_etc.apply_dwt(v4,m,n,wt,L,RDT),
        DDT,RDT;
        name="joDWT")
end

