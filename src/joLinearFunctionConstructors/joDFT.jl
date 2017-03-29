# FFT operators: joDFT

function apply_fft_centered(pln,v::AbstractVector,ms::Tuple,rdt::DataType)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1 push!(vs,lvmp) end
    rv=reshape(v,vs...)
    rv=(pln*rv)/sqrt(mp)
    for d=1:l rv=fftshift(rv,d) end
    lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
    rv=jo_convert(rdt,rv,false)
    return rv
end

function apply_ifft_centered(pln,v::AbstractVector,ms::Tuple,rdt::DataType)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1 push!(vs,lvmp) end
    rv=reshape(v,vs...)
    for d=1:l rv=ifftshift(rv,d) end
    rv=(pln*rv)*sqrt(mp)
    lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
    rv=jo_convert(rdt,rv,false)
    return rv
end

function apply_fft(pln,v::AbstractVector,ms::Tuple,rdt::DataType)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1 push!(vs,lvmp) end
    rv=reshape(v,vs...)
    rv=(pln*rv)/sqrt(mp)
    lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
    rv=jo_convert(rdt,rv,false)
    return rv
end

function apply_ifft(pln,v::AbstractVector,ms::Tuple,rdt::DataType)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1 push!(vs,lvmp) end
    rv=reshape(v,vs...)
    rv=(pln*rv)*sqrt(mp)
    lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
    rv=jo_convert(rdt,rv,false)
    return rv
end

export joDFT
"""
Multi-dimensional FFT transform over fast dimension(s)

    joDFT(m[,n[, ...]]
            [;centered=false,DDT=Float64,RDT=(DDT:<Real?Complex{DDT}:DDT)])

# Examples

- joDFT(m) - 1D FFT
- joDFT(m; centered=true) - 1D FFT with centered coefficients
- joDFT(m,n) - 2D FFT
- joDFT(m; DDT=Float32) - 1D FFT for 32-bit input
- joDFT(m; DDT=Float32,RDT=Float64) - 1D FFT for 32-bit input and 64-bit output

# Notes
- if DDT:<Real then imaginary part will be neglected for transpose/ctranspose

"""
function joDFT(ms::Integer...;centered::Bool=false,DDT::DataType=Float64,RDT::DataType=(DDT<:Real?Complex{DDT}:DDT))
    pf=plan_fft(zeros(ms))
    ipf=plan_ifft(zeros(ms))
    if centered
        return joLinearFunctionCT(prod(ms),prod(ms),
            v1->apply_fft_centered(pf,v1,ms,RDT),
            v2->apply_ifft_centered(ipf,v2,ms,DDT),
            v3->apply_ifft_centered(ipf,v3,ms,DDT),
            v4->apply_fft_centered(pf,v4,ms,RDT),
            DDT,RDT;
            name="joDFTc"
            )
    else
        return joLinearFunctionCT(prod(ms),prod(ms),
            v1->apply_fft(pf,v1,ms,RDT),
            v2->apply_ifft(ipf,v2,ms,DDT),
            v3->apply_ifft(ipf,v3,ms,DDT),
            v4->apply_fft(pf,v4,ms,RDT),
            DDT,RDT;
            name="joDFT"
            )
    end
end

