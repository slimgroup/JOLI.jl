# FFT operators: joDFT

## helper module
module joDFT_etc
    using JOLI: jo_convert
    using FFTW
    ### planned
    function apply_fft(pln::FFTW.cFFTWPlan,v::Vector{vdt},ms::Dims,rdt::DataType,centered::Bool) where vdt<:Union{AbstractFloat,Complex}
        mp=prod(ms)
        rv=reshape(v,ms)
        rv=(pln*rv)/sqrt(mp)
        if centered rv=fftshift(rv) end
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_fft(pln::FFTW.cFFTWPlan,v::Matrix{vdt},ms::Dims,rdt::DataType,centered::Bool) where vdt<:Union{AbstractFloat,Complex}
        lms=length(ms)
        nvc=size(v,2)
        msc=(ms...,nvc)
        dims=[1:lms...]
        mp=prod(ms)
        rv=reshape(v,msc)
        pf=plan_fft(rv,dims)
        rv=(pf*rv)/sqrt(mp)
        if centered rv=fftshift(rv,dims) end
        rv=reshape(rv,(mp,nvc))
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_ifft(pln::AbstractFFTs.ScaledPlan,v::Vector{vdt},ms::Dims,rdt::DataType,centered::Bool) where vdt<:Union{AbstractFloat,Complex}
        mp=prod(ms)
        rv=reshape(v,ms)
        if centered rv=ifftshift(rv) end
        rv=(pln*rv)*sqrt(mp)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_ifft(pln::AbstractFFTs.ScaledPlan,v::Matrix{vdt},ms::Dims,rdt::DataType,centered::Bool) where vdt<:Union{AbstractFloat,Complex}
        lms=length(ms)
        nvc=size(v,2)
        msc=(ms...,nvc)
        dims=[1:lms...]
        mp=prod(ms)
        rv=reshape(v,msc)
        pf=plan_ifft(rv,dims)
        if centered rv=fftshift(rv,dims) end
        rv=(pf*rv)*sqrt(mp)
        rv=reshape(rv,(prod(ms),nvc))
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    ### not planned
    function apply_fft(v::Vector{vdt},ms::Dims,rdt::DataType,centered::Bool) where vdt<:Union{AbstractFloat,Complex}
        mp=prod(ms)
        rv=reshape(v,ms)
        rv=fft(rv)/sqrt(mp)
        if centered rv=fftshift(rv) end
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_fft(v::Matrix{vdt},ms::Dims,rdt::DataType,centered::Bool) where vdt<:Union{AbstractFloat,Complex}
        lms=length(ms)
        nvc=size(v,2)
        msc=(ms...,nvc)
        dims=[1:lms...]
        mp=prod(ms)
        rv=reshape(v,msc)
        pf=plan_fft(rv,dims)
        rv=(pf*rv)/sqrt(mp)
        if centered rv=fftshift(rv,dims) end
        rv=reshape(rv,(mp,nvc))
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_ifft(v::Vector{vdt},ms::Dims,rdt::DataType,centered::Bool) where vdt<:Union{AbstractFloat,Complex}
        mp=prod(ms)
        rv=reshape(v,ms)
        if centered rv=ifftshift(rv) end
        rv=ifft(rv)*sqrt(mp)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_ifft(v::Matrix{vdt},ms::Dims,rdt::DataType,centered::Bool) where vdt<:Union{AbstractFloat,Complex}
        lms=length(ms)
        nvc=size(v,2)
        msc=(ms...,nvc)
        dims=[1:lms...]
        mp=prod(ms)
        rv=reshape(v,msc)
        pf=plan_ifft(rv,dims)
        if centered rv=fftshift(rv,dims) end
        rv=(pf*rv)*sqrt(mp)
        rv=reshape(rv,(prod(ms),nvc))
        rv=jo_convert(rdt,rv,false)
        return rv
    end
end
using .joDFT_etc

# constructors
export joDFT
"""
    julia> op = joDFT(m[,n[,...]];[plannned=...,][centered=...,][DDT=...,][RDT=...,][name=...])

Multi-dimensional FFT transform over fast dimension(s)

# Signature

    function joDFT(ms::Integer...;
        planned::Bool=true, centered::Bool=false,
        DDT::DataType=joFloat, RDT::DataType=(DDT<:Real ? Complex{DDT} : DDT),
        name::String="joDFT")

# Arguments

- `m`: dimension
- optional
    - `n,...`: more dimensions
- keywords
    - `planned`: use FFTW plan
    - `centered`: produce centered coefficients
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Notes

- multidimensional image must be vectorized
- if DDT:<Real then imaginary part will be neglected for transpose/adjoint
- if you intend to use joDFT in remote* calls, you have to either set planned=false or create the operator on the worker
- joDFT is always planned if applied to multi-vector

# Examples

1D FFT

    joDFT(m)

1D FFT with centered coefficients

    joDFT(m; centered=true)

1D FFT without the precomputed plan

    joDFT(m; planned=false)

2D FFT

    joDFT(m,n)

examples with DDT/RDT

    joDFT(m; DDT=Float32)
    joDFT(m; DDT=Float32,RDT=ComplexF64)

"""
function joDFT(ms::Integer...;
    planned::Bool=true, centered::Bool=false,
    DDT::DataType=joFloat, RDT::DataType=(DDT<:Real ? Complex{DDT} : DDT),
    name::String="joDFT")

    if planned
        pf=plan_fft(zeros(ms))
        ipf=plan_ifft(zeros(ms))
        if centered
            return joLinearFunction_A(prod(ms),prod(ms),
                v1->joDFT_etc.apply_fft(pf,v1,ms,RDT,true),
                v2->joDFT_etc.apply_ifft(ipf,v2,ms,DDT,true),
                v3->joDFT_etc.apply_ifft(ipf,v3,ms,DDT,true),
                v4->joDFT_etc.apply_fft(pf,v4,ms,RDT,true),
                DDT,RDT;fMVok=true,iMVok=true,
                name=name*"_pc"
                )
        else
            return joLinearFunction_A(prod(ms),prod(ms),
                v1->joDFT_etc.apply_fft(pf,v1,ms,RDT,false),
                v2->joDFT_etc.apply_ifft(ipf,v2,ms,DDT,false),
                v3->joDFT_etc.apply_ifft(ipf,v3,ms,DDT,false),
                v4->joDFT_etc.apply_fft(pf,v4,ms,RDT,false),
                DDT,RDT;fMVok=true,iMVok=true,
                name=name*"_p"
                )
        end
    else
        if centered
            return joLinearFunction_A(prod(ms),prod(ms),
                v1->joDFT_etc.apply_fft(v1,ms,RDT,true),
                v2->joDFT_etc.apply_ifft(v2,ms,DDT,true),
                v3->joDFT_etc.apply_ifft(v3,ms,DDT,true),
                v4->joDFT_etc.apply_fft(v4,ms,RDT,true),
                DDT,RDT;fMVok=true,iMVok=true,
                name=name*"_c"
                )
        else
            return joLinearFunction_A(prod(ms),prod(ms),
                v1->joDFT_etc.apply_fft(v1,ms,RDT,false),
                v2->joDFT_etc.apply_ifft(v2,ms,DDT,false),
                v3->joDFT_etc.apply_ifft(v3,ms,DDT,false),
                v4->joDFT_etc.apply_fft(v4,ms,RDT,false),
                DDT,RDT;fMVok=true,iMVok=true,
                name=name
                )
        end
    end
end

