# DWT operators: joDWT

## helper module
module joDWT_etc
    using JOLI: jo_convert
    using Wavelets
    # 1D
    function apply_dwt(v::Vector{vdt},m::Integer,wt::OrthoFilter,L::Integer,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        rv=dwt(v,wt,L)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_idwt(v::Vector{vdt},m::Integer,wt::OrthoFilter,L::Integer,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        rv=idwt(v,wt,L)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    # 2D
    function apply_dwt(v::Vector{vdt},m::Integer,n::Integer,wt::OrthoFilter,L::Integer,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        rv=reshape(v,m,n)
        rv=dwt(rv,wt,L)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_idwt(v::Vector{vdt},m::Integer,n::Integer,wt::OrthoFilter,L::Integer,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
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
    julia> joDWT(m,[n,][wt=...];[L=...,][DDT=...,][RDT=...])

1/2-dimensional DWT transform over fast dimension(s) - based on Wavelets.jl. See Wavelets.jl package form more information, especially current filter list.

# Signature

    function joDWT(m::Integer,n::Integer,wt::OrthoFilter=wavelet(WT.haar);
        L::Integer=maxtransformlevels(min(m,n)),
        DDT::DataType=joFloat,RDT::DataType=DDT,
        name::String="joDWT")

# Arguments

- `m`: dimention
- optional
    - `n`: 2nd dimention
    - `wt`: wavelet filter (Haar by default)
- keywords
    - `L`: number of levels
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Notes

- only square 2D arrays are supported for now due to limitations of Wavelets.jl package

# Examples

```
joDWT(m,wt) # 1D DWT using Haar wavelet
wt=wavelet(WT.haar) # define wavelet
joDWT(m,wt) # 1D DWT
joDWT(m,n,wt) # 2D DWT
joDWT(m,wt; DDT=Float32) # 1D DWT for 32-bit vectors
joDWT(m,wt; DDT=Float32,RDT=Float64) # 1D DWT for 32-bit input and 64-bit output
```

"""
function joDWT(m::Integer,wt::OrthoFilter=wavelet(WT.haar);
    L::Integer=maxtransformlevels(m),
    DDT::DataType=joFloat,RDT::DataType=DDT,
    name::String="joDWT")

    return joLinearFunction_A(m,m,
        v1->joDWT_etc.apply_dwt(v1,m,wt,L,RDT),
        v2->joDWT_etc.apply_idwt(v2,m,wt,L,DDT),
        v3->joDWT_etc.apply_idwt(v3,m,wt,L,DDT),
        v4->joDWT_etc.apply_dwt(v4,m,wt,L,RDT),
        DDT,RDT;
        name=name)
end
function joDWT(m::Integer,n::Integer,wt::OrthoFilter=wavelet(WT.haar);
    L::Integer=maxtransformlevels(min(m,n)),
    DDT::DataType=joFloat,RDT::DataType=DDT,
    name::String="joDWT")

    (m!=n && n!=1) && throw(joLinearFunctionException("joDWT: only square images are supported for now"))
    return joLinearFunction_A(m*n,m*n,
        v1->joDWT_etc.apply_dwt(v1,m,n,wt,L,RDT),
        v2->joDWT_etc.apply_idwt(v2,m,n,wt,L,DDT),
        v3->joDWT_etc.apply_idwt(v3,m,n,wt,L,DDT),
        v4->joDWT_etc.apply_dwt(v4,m,n,wt,L,RDT),
        DDT,RDT;
        name=name)
end

