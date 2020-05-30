# joRomberg operator

## helper module
module joRomberg_etc
    using JOLI: jo_convert, jo_complex_eltype, LocalVector
    using FFTW

    function random_phases(DT::DataType,dims::Dims)
        dt = DT<:Complex ? jo_complex_eltype(DT) : DT
        p1 = exp.((dt(2)*im*pi).*rand(dt,dims))
        p2 = fft(real(ifft(p1)));
        p = p2./abs.(p2)
    end

    function apply_fwd(dims::Dims,phs::Array,sgn::Array,v::LocalVector{VT},rdt::DataType) where VT<:Real
       a = reshape(v,dims)
       y = real(sgn.*ifft(phs.*fft(a)))
       return jo_convert(rdt,vec(y),false)
    end
    function apply_fwd(dims::Dims,phs::Array,sgn::Array,v::LocalVector{VT},rdt::DataType) where VT<:Complex
       a = reshape(v,dims)
       y = sgn.*ifft(phs.*fft(a))
       return jo_convert(rdt,vec(y),false)
    end

    function apply_adj(dims::Dims,phs::Array,sgn::Array,v::LocalVector{VT},rdt::DataType) where VT<:Real
       a = reshape(v,dims)
       y = real(ifft(conj(phs).*fft(sgn.*a)))
       return jo_convert(rdt,vec(y),false)
    end
    function apply_adj(dims::Dims,phs::Array,sgn::Array,v::LocalVector{VT},rdt::DataType) where VT<:Complex
       a = reshape(v,dims)
       y = ifft(conj(phs).*fft(sgn.*a))
       return jo_convert(rdt,vec(y),false)
    end

end
using .joRomberg_etc

export joRomberg
"""
    julia> op = joRomberg(n1[,n2[,...]];[DDT=...,][RDT=...,][name=...])

A random comvolution based on Romberg 08

# Signature

    joRomberg(dims::Integer...;
        DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joRomberg")

# Arguments

- `n1[,n2[...]]`: dimensions of the image; M=N=prod(ni)
- keywords
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Examples

    A=joRomberg(9)

    A=joRomberg(9,11)

32-bit input

    A=joRomberg(9,11; DDT=Float32)

32-bit input and 64-bit output

    A=joRomberg(9,11; DDT=Float32,RDT=Float64)

"""
function joRomberg(dims::Integer...;DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joRomberg")

    m = n = prod(dims)
    phs = joRomberg_etc.random_phases(DDT,dims)
    sgn = sign.(randn(dims))
    return joLinearFunctionFwd_A(m,n,
        v1->joRomberg_etc.apply_fwd(dims,phs,sgn,v1,RDT),
        v2->joRomberg_etc.apply_adj(dims,phs,sgn,v2,DDT),
        DDT,RDT;
        name=name)
end

