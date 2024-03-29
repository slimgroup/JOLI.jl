# NFFT operators: joNFFT

## helper module
module joNFFT_etc
    using NFFT
    using FFTW: fftshift, ifftshift
    using JOLI: jo_convert
    function apply_nfft_centered(pln,n,v::Vector{vdt},rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        iv=jo_convert(ComplexF64,v,false)
        rv= (pln*iv)/sqrt(n)
        rv=fftshift(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_infft_centered(pln,n,v::Vector{vdt},rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        iv=jo_convert(ComplexF64,v,false)
        iv=ifftshift(iv)
        rv=(adjoint(pln)*iv)/sqrt(n)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_nfft(pln,n,v::Vector{vdt},rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        iv=jo_convert(ComplexF64,v,false)
        rv= (pln*iv)/sqrt(n)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_infft(pln,n,v::Vector{vdt},rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        iv=jo_convert(ComplexF64,v,false)
        rv=(adjoint(pln)*iv)/sqrt(n)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
end
using .joNFFT_etc

export joNFFT
"""
    julia> op = joNFFT(N,pos[,m=...][,sigma=...][,window=...];
                [centered=...,][DDT=...,][RDT=...,][name=...])

1D NFFT transform over fast dimension (wrapper to https://github.com/tknopp/NFFT.jl)

# Signature

    function joNFFT(N::Integer,pos::Vector{joFloat},
        m=4,sigma=2.0,window=:kaiser_bessel; centered::Bool=false,
        DDT::DataType=joComplex,RDT::DataType=DDT,name::String="joNFFT")

# Arguments

- `N`: size
- `pos`: nodes positions
- optional
    - see https://github.com/tknopp/NFFT.jl for info about optional parameters to NFFTplan: `m`, `sigma`, `window`, and `K`
- keywords
    - `centered`: return centered coefficients
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Notes

- NFFT always uses ComplexF64 vectors internally

# Examples

1D NFFT

    joNFFT(N,pos)

centered coefficients

    joNFFT(N,pos; centered=true)

examples with DDT/RDT

    % joNFFT(N,pos; DDT=ComplexF32)
    % joNFFT(N,pos; DDT=ComplexF32,RDT=ComplexF64)

"""
function joNFFT(N::Integer,pos::Vector{joFloat},
    m=4,sigma=2.0,window=:kaiser_bessel; centered::Bool=false,
    DDT::DataType=joComplex,RDT::DataType=DDT,name::String="joNFFT")

    M = length(pos)
    p = plan_nfft(pos, N; m=m, σ=sigma, window=window)
    if centered
        return joLinearFunctionFwd_A(M,N,
            v1->joNFFT_etc.apply_nfft_centered(p,N,v1,RDT),
            v2->joNFFT_etc.apply_infft_centered(p,N,v2,DDT),
            DDT,RDT;
            name=name*"_c"
            )
    else
        return joLinearFunctionFwd_A(M,N,
            v1->joNFFT_etc.apply_nfft(p,N,v1,RDT),
            v2->joNFFT_etc.apply_infft(p,N,v2,DDT),
            DDT,RDT;
            name=name
            )
    end
end

