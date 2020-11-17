# sinc interpolation operator

## helper module
module joSincInterp_etc
    using SpecialFunctions
    function kaiser_window(x,r,b)
        return abs(x) <= r ? besseli(0,b*sqrt(1-(x/r)^2))/besseli(0,b) : 0.0
    end
end
using .joSincInterp_etc

export joSincInterp
"""
    julia> joSincInterp(xin,xout;[r=...,][DDT=...,][RDT=...,][name=...])

sinc interpolation matrix for interpolating functions f defined on grid xin to functions defined on grid xout

# Signature

    function joSincInterp(xin::AbstractArray{T,1},xout::AbstractArray{T,1};
        r::I=0,DDT::DataType=T,RDT::DataType=DDT,name::String="joSincInterp")
        where {T<:AbstractFloat,I<:Integer}

# Arguments

- `xin`  - 1D input grid
- `xout` - 1D output grid
- keywords
    - `r`: kaiser window parameter (default: 0, no windowing)
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Notes

- If xout has more than one point, the spacings of xin and xout are normalized to the spacing of xout.
 
# Examples

% description

    joSincInterp(xin,xout)

examples with DDT/RDT

    % joSincInterp(xin,xout; DDT=Float32)
    % joSincInterp(xin,xout; DDT=Float32,RDT=Float64)

"""
function joSincInterp(xin::AbstractArray{T,1},xout::AbstractArray{T,1};
    r::I=0,DDT::DataType=T,RDT::DataType=DDT,name::String="joSincInterp") where {T<:AbstractFloat,I<:Integer}

    length(xin)>1 ? dx = min(xin[2]-xin[1], xout[2]-xout[1]) : dx = 1
    S = sinc.( (xout .- xin') ./ dx )
    if r > 0
        r_b =[1.24 2.94 4.53 6.31 7.91 9.42 10.95 12.53 14.09 14.18];
        window = [joSincInterp_etc.kaiser_window(xout[i]-xin[j],r,r_b[r]) for i in 1:length(xout), j in 1:length(xin)]
        S = S .* window
    end
    return joMatrix(S,DDT=DDT,RDT=RDT,name=name)

end

