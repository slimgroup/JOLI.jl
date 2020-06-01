# DCT operators: joDCT

## helper module
module joDCT_etc
    using JOLI: jo_convert
    using FFTW
    ### planned
    function apply_dct(pln::FFTW.DCTPlan,v::Vector{vdt},ms::Dims,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        rv=reshape(v,ms)
        rv=pln*rv
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_dct(pln::FFTW.DCTPlan,v::Matrix{vdt},ms::Dims,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        lms=length(ms)
        nvc=size(v,2)
        msc=(ms...,nvc)
        rv=reshape(v,msc)
        pf=plan_dct(rv,[1:lms...])
        rv=pf*rv
        rv=reshape(rv,(prod(ms),nvc))
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_idct(pln::FFTW.DCTPlan,v::Vector{vdt},ms::Dims,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        rv=reshape(v,ms)
        rv=pln*rv
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_idct(pln::FFTW.DCTPlan,v::Matrix{vdt},ms::Dims,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        lms=length(ms)
        nvc=size(v,2)
        msc=(ms...,nvc)
        rv=reshape(v,msc)
        pf=plan_idct(rv,[1:lms...])
        rv=pf*rv
        rv=reshape(rv,(prod(ms),nvc))
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    ### not planned
    function apply_dct(v::Vector{vdt},ms::Dims,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        rv=reshape(v,ms)
        rv=dct(rv)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_dct(v::Matrix{vdt},ms::Dims,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        lms=length(ms)
        nvc=size(v,2)
        msc=(ms...,nvc)
        rv=reshape(v,msc)
        pf=plan_dct(rv,[1:lms...])
        rv=pf*rv
        rv=reshape(rv,(prod(ms),nvc))
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_idct(v::Vector{vdt},ms::Dims,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        rv=reshape(v,ms)
        rv=idct(rv)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_idct(v::Matrix{vdt},ms::Dims,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        lms=length(ms)
        nvc=size(v,2)
        msc=(ms...,nvc)
        rv=reshape(v,msc)
        pf=plan_idct(rv,[1:lms...])
        rv=pf*rv
        rv=reshape(rv,(prod(ms),nvc))
        rv=jo_convert(rdt,rv,false)
        return rv
    end
end
using .joDCT_etc

export joDCT
"""
    julia> op = joDCT(m[,n[,...]];[planned::Bool=true][,DDT=joFloat][,RDT=DDT])

Multi-dimensional DCT transform over fast dimension(s)

# Signature

    function joDCT(ms::Integer...;
        planned::Bool=true,
        DDT::DataType=joFloat,RDT::DataType=DDT,
        name::String="joDCT")

# Arguments

- `m`: dimension
- optional
    - `n,...`: more dimensions
- keywords
    - `planned`: use DCT plan
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Notes

- multidimensional image must be vectorized
- if you intend to use joDCT in remote* calls, you have to either set planned=false or create the operator on the worker
- joDCT is always planned if applied to multi-vector

# Examples

1D DCT

    joDCT(m)

1D DCT without the precomputed plan

    joDCT(m; planned=false)

2D DCT

    joDCT(m,n)

examples with DDT/RDT

    joDCT(m; DDT=Float32)
    joDCT(m; DDT=Float32,RDT=Float64)

"""
function joDCT(ms::Integer...;
    planned::Bool=true,
    DDT::DataType=joFloat,RDT::DataType=DDT,
    name::String="joDCT")

    if planned
        pf=plan_dct(zeros(ms))
        ipf=plan_idct(zeros(ms))
        return joLinearFunction_A(prod(ms),prod(ms),
            v1->joDCT_etc.apply_dct(pf,v1,ms,RDT),
            v2->joDCT_etc.apply_idct(ipf,v2,ms,DDT),
            v3->joDCT_etc.apply_idct(ipf,v3,ms,DDT),
            v4->joDCT_etc.apply_dct(pf,v4,ms,RDT),
            DDT,RDT;fMVok=true,iMVok=true,
            name=name*"_p"
            )
    else
        return joLinearFunction_A(prod(ms),prod(ms),
            v1->joDCT_etc.apply_dct(v1,ms,RDT),
            v2->joDCT_etc.apply_idct(v2,ms,DDT),
            v3->joDCT_etc.apply_idct(v3,ms,DDT),
            v4->joDCT_etc.apply_dct(v4,ms,RDT),
            DDT,RDT;fMVok=true,iMVok=true,
            name=name)
    end
end

