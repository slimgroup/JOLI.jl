# DCT operators: joDCT

function apply_dct(v,ms)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1 push!(vs,lvmp) end
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
    if lvmp>1 push!(vs,lvmp) end
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
        v1->apply_dct(v1,ms),
        v2->apply_idct(v2,ms),
        v3->apply_idct(v3,ms),
        v4->apply_dct(v4,ms),
        "joDCT"
        )

