############################################################
# joLinearFunction - miscaleneous constructor-only operators 
############################################################

# FFT operators: joDFT
function apply_fft(v,ms)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1; push!(vs,lvmp); end
    rv=reshape(v,vs...)
    rv=fft(rv,1:l)
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
    rv=ifft(rv,1:l)
    lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
    return rv
end
export joDFT
"""
Multi-dimensional FFT transform over fast dimensions

    joDFT(m[,n[, ...]])

Note: passes isadjoint(joDFT(m),m)
"""
joDFT(ms::Integer...)=
    joLinearFunctionCT(Complex{Float64},prod(ms),prod(ms),
        v1->apply_fft(v1,ms),v2->apply_ifft(v2,ms),v3->apply_ifft(v3,ms),v4->apply_fft(v4,ms),"joDFT")
