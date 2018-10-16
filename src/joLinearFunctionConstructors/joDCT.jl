# DCT operators: joDCT

## helper module
module joDCT_etc
    using JOLI: jo_convert
    using FFTW
    ### planned
    function apply_dct(pln::FFTW.DCTPlan,v::AbstractVector{<:Number},ms::Tuple,rdt::DataType)
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
    function apply_idct(pln::FFTW.DCTPlan,v::AbstractVector{<:Number},ms::Tuple,rdt::DataType)
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
    ### not planned
    function apply_dct(v::AbstractVector{<:Number},ms::Tuple,rdt::DataType)
        l::Integer=length(ms)
        mp::Integer=prod(ms)
        lv::Integer=length(v)
        lvmp::Integer=lv/mp
        vs=collect(ms)
        if lvmp>1 push!(vs,lvmp) end
        rv=reshape(v,vs...)
        rv=dct(rv,1:l)
        lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_idct(v::AbstractVector{<:Number},ms::Tuple,rdt::DataType)
        l::Integer=length(ms)
        mp::Integer=prod(ms)
        lv::Integer=length(v)
        lvmp::Integer=lv/mp
        vs=collect(ms)
        if lvmp>1 push!(vs,lvmp) end
        rv=reshape(v,vs...)
        rv=idct(rv,1:l)
        lvmp>1 ? rv=reshape(rv,mp,lvmp) : rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
end
using .joDCT_etc

export joDCT
"""
Multi-dimensional DCT transform over fast dimension(s)

    joDCT(m[,n[, ...]] [;planned::Bool=true,DDT=joFloat,RDT=DDT])

# Examples

- joDCT(m) - 1D DCT
- joDCT(m; planned=false) - 1D FFT without the precomputed plan
- joDCT(m,n) - 2D DCT
- joDCT(m; DDT=Float32) - 1D DCT for 32-bit vectors
- joDCT(m; DDT=Float32,RDT=Float64) - 1D DCT for 32-bit input and 64-bit output

# Notes

- if you intend to use joDCT in remote* calls, you have to either set planned=false or create the operator on the worker

"""
function joDCT(ms::Integer...;planned::Bool=true,DDT::DataType=joFloat,RDT::DataType=DDT)
    if planned
    pf=plan_dct(zeros(ms))
    ipf=plan_idct(zeros(ms))
    return joLinearFunction_A(prod(ms),prod(ms),
        v1->joDCT_etc.apply_dct(pf,v1,ms,RDT),
        v2->joDCT_etc.apply_idct(ipf,v2,ms,DDT),
        v3->joDCT_etc.apply_idct(ipf,v3,ms,DDT),
        v4->joDCT_etc.apply_dct(pf,v4,ms,RDT),
        DDT,RDT;
        name="joDCTp"
        )
    else
    return joLinearFunction_A(prod(ms),prod(ms),
        v1->joDCT_etc.apply_dct(v1,ms,RDT),
        v2->joDCT_etc.apply_idct(v2,ms,DDT),
        v3->joDCT_etc.apply_idct(v3,ms,DDT),
        v4->joDCT_etc.apply_dct(v4,ms,RDT),
        DDT,RDT;
        name="joDCT")
    end
end

