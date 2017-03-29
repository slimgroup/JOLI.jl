# DCT operators: joDCT

function apply_dct(pln,v::AbstractVector,ms::Tuple,rdt::DataType)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1 push!(vs,lvmp) end
    rv=reshape(v,vs...)
    rv=pln*rv
    lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
    rv=jo_convert(rdt,rv,false)
    return rv
end

function apply_idct(pln,v::AbstractVector,ms::Tuple,rdt::DataType)
    l::Integer=length(ms)
    mp::Integer=prod(ms)
    lv::Integer=length(v)
    lvmp::Integer=lv/mp
    vs=collect(ms)
    if lvmp>1 push!(vs,lvmp) end
    rv=reshape(v,vs...)
    rv=pln*rv
    lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
    rv=jo_convert(rdt,rv,false)
    return rv
end

export joDCT
"""
Multi-dimensional DCT transform over fast dimension(s)

    joDCT(m[,n[, ...]] [;DDT=Float64,RDT=DDT])

# Examples
- joDCT(m) - 1D DCT
- joDCT(m,n) - 2D DCT
- joDCT(m; DDT=Float32) - 1D DCT for 32-bit vectors
- joDCT(m; DDT=Float32,RDT=Float64) - 1D DCT for 32-bit input and 64-bit output

"""
function joDCT(ms::Integer...;DDT::DataType=Float64,RDT::DataType=DDT)
    pf=plan_dct(zeros(ms))
    ipf=plan_idct(zeros(ms))
    joLinearFunctionCT(prod(ms),prod(ms),
        v1->apply_dct(pf,v1,ms,RDT),
        v2->apply_idct(ipf,v2,ms,DDT),
        v3->apply_idct(ipf,v3,ms,DDT),
        v4->apply_dct(pf,v4,ms,RDT),
        DDT,RDT;
        name="joDCT"
        )
end

