# NFFT operators: joNFFT

## helper module
module joNFFT_etc
    using JOLI: jo_convert
    function apply_nfft_centered(pln,n,v::AbstractVector,rdt::DataType)
        iv=jo_convert(Complex{Float64},v)
        rv=nfft(pln,iv)/sqrt(n)
        rv=fftshift(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_infft_centered(pln,n,v::AbstractVector,rdt::DataType)
        iv=jo_convert(Complex{Float64},v)
        iv=ifftshift(iv)
        rv=nfft_adjoint(pln,iv)/sqrt(n)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_nfft(pln,n,v::AbstractVector,rdt::DataType)
        iv=jo_convert(Complex{Float64},v)
        rv=nfft(pln,iv)/sqrt(n)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_infft(pln,n,v::AbstractVector,rdt::DataType)
        iv=jo_convert(Complex{Float64},v)
        rv=nfft_adjoint(pln,iv)/sqrt(n)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
end
using .joNFFT_etc

export joNFFT
"""
1D NFFT transform over fast dimension (wrapper to https://github.com/tknopp/NFFT.jl/tree/master)

    joNFFT(N,nodes::Vector{joFloat} [,m=4,sigma=2.0,window=:kaiser_bessel,K=2000;centered=false,DDT=joComplex,RDT=DDT])

# Examples
- joNFFT(N,nodes) - 1D NFFT

# Notes
- NFFT always uses Complex{Float64} vectors internally
- see https://github.com/tknopp/NFFT.jl/tree/master for docs for optional parameters to NFFTplan

"""
function joNFFT(N::Integer,pos::Vector{joFloat},m=4,sigma=2.0,window=:kaiser_bessel,K=2000;centered::Bool=false,DDT::DataType=joComplex,RDT::DataType=DDT)
    M=length(pos)
    p=NFFTPlan(pos,N,m,sigma,window,K)
    if centered
        return joLinearFunctionFwd_A(M,N,
            v1->joNFFT_etc.apply_nfft_centered(p,N,v1,RDT),
            v2->joNFFT_etc.apply_infft_centered(p,N,v2,DDT),
            DDT,RDT;
            name="joNFFTc"
            )
    else
        return joLinearFunctionFwd_A(M,N,
            v1->joNFFT_etc.apply_nfft(p,N,v1,RDT),
            v2->joNFFT_etc.apply_infft(p,N,v2,DDT),
            DDT,RDT;
            name="joNFFT"
            )
    end
end

