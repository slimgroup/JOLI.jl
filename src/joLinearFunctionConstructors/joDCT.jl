# DCT operators: joDCT

function apply_dct(pln,v::AbstractVector,ms::Tuple)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1 push!(vs,lvmp) end
    rv=reshape(v,vs...)
    rv=pln*rv
    lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
    return rv
end

function apply_idct(pln,v::AbstractVector,ms::Tuple)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1 push!(vs,lvmp) end
    rv=reshape(v,vs...)
    rv=pln*rv
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
function joDCT(ms::Integer...;elmtype=Float64)
    pf=plan_dct(zeros(ms))
    ipf=plan_idct(zeros(ms))
    joLinearFunctionCT(elmtype,prod(ms),prod(ms),
        v1->apply_dct(pf,v1,ms),
        v2->apply_idct(ipf,v2,ms),
        v3->apply_idct(ipf,v3,ms),
        v4->apply_dct(pf,v4,ms),
        "joDCT"
        )
end

