############################################################
# joLinearFunction - miscaleneous constructor-only operators 
############################################################

# FFT operators: joDFT
function apply_fft(v,ms)
    l=length(ms)
    mp=prod(ms)
    lv=length(v)
    vs=collect(ms)
    push!(vs,lv/mp)
    rv=reshape(v,vs...)
    return vec(fft(rv,1:l))
end
function apply_ifft(v,ms)
    l=length(ms)
    mp=prod(ms)
    lv=length(v)
    vs=collect(ms)
    push!(vs,lv/mp)
    rv=reshape(v,vs...)
    return vec(ifft(rv,1:l))
end
export joDFT
"""
Multi-dimensional FFT transform over fast dimensions

    joDFT(m,[n ...])

Note: passes isadjoint(joDFT(m),m)
"""
joDFT(ms::Integer...)=
    joLinearFunctionCT(Complex{Float64},prod(ms),prod(ms),
        v1->apply_fft(v1,ms),v2->apply_ifft(v2,ms),v3->apply_ifft(v3,ms),v4->apply_fft(v4,ms),"joDFT")
