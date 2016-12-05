############################################################
# joLinearFunction - miscaleneous constructor-only operators 
############################################################

# FFT operators: joDFT
function apply_fft_centered(v,ms)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1; push!(vs,lvmp); end
    rv=reshape(v,vs...)
    rv=fft(rv,1:l)/sqrt(mp)
    for d=1:l; rv=fftshift(rv,d); end
    lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
    return rv
end
function apply_ifft_centered(v,ms)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1; push!(vs,lvmp); end
    rv=reshape(v,vs...)
    for d=1:l; rv=ifftshift(rv,d); end
    rv=ifft(rv,1:l)*sqrt(mp)
    lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
    return rv
end
function apply_fft(v,ms)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1; push!(vs,lvmp); end
    rv=reshape(v,vs...)
    rv=fft(rv,1:l)/sqrt(mp)
    lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
    return rv
end
function apply_ifft(v,ms)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1; push!(vs,lvmp); end
    rv=reshape(v,vs...)
    rv=ifft(rv,1:l)*sqrt(mp)
    lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
    return rv
end
export joDFT
"""
    joDFT(m[,n[, ...]] [;centered=false | elmtype=Float64])

Multi-dimensional FFT transform over fast dimension(s)

# Examples

- joDFT(m) - 1D FFT

- joDFT(m; centered=true) - 1D FFT with centered coefficients

- joDFT(m,n) - 2D FFT

- jo(m; elmtype=Float32) - 1D FFT for 32-bit vectors

"""
function joDFT(ms::Integer...;centered::Bool=false,elmtype=Float64)
    if centered
        return joLinearFunctionCT(Complex{elmtype},prod(ms),prod(ms),
            v1->apply_fft_centered(v1,ms),v2->apply_ifft_centered(v2,ms),v3->apply_ifft_centered(v3,ms),v4->apply_fft_centered(v4,ms),"joDFT")
    else
        return joLinearFunctionCT(Complex{elmtype},prod(ms),prod(ms),
            v1->apply_fft(v1,ms),v2->apply_ifft(v2,ms),v3->apply_ifft(v3,ms),v4->apply_fft(v4,ms),"joDFT")
    end
end

# DCT operators: joDCT
function apply_dct(v,ms)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1; push!(vs,lvmp); end
    rv=reshape(v,vs...)
    rv=dct(rv,1:l)
    lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
    return rv
end
function apply_idct(v,ms)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1; push!(vs,lvmp); end
    rv=reshape(v,vs...)
    rv=idct(rv,1:l)
    lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
    return rv
end
export joDCT
"""
    joDCT(m[,n[, ...]] [elmtype=Float64])

Multi-dimensional DCT transform over fast dimension(s)

# Examples

- joDCT(m) - 1D DCT

- joDCT(m,n) - 2D DCT

- jo(m; elmtype=Float32) - 1D DCT for 32-bit vectors

"""
joDCT(ms::Integer...;elmtype=Float64) =
        joLinearFunctionCT(elmtype,prod(ms),prod(ms),
            v1->apply_dct(v1,ms),v2->apply_idct(v2,ms),v3->apply_idct(v3,ms),v4->apply_dct(v4,ms),"joDCT")

