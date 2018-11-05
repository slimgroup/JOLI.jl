# joRadon - Radon transform (experimental)

## helper module
module joRadon_etc
    using FFTW
    using JOLI: jo_convert
    # linear and parabolic Radon transform and its adjoint.
    #
    # Tristan van Leeuwen, 2012 (tleeuwen@eos.ubc.ca)
    # Modified by Henryk Modzelewski (Nov 2018)
    #
    # use:
    #   out = fwd_lpradon(input,t,h,q,power)
    #   out = adj_lpradon(input,t,h,q,power)
    #
    # input:
    #   input - vectorized matrix of size (length(t) x length(h)) for forward, (length(t) x length(q)) for adjoint)
    #   t     - time vector in seconds
    #   h     - offset vecror in meters
    #   q     - radon parameter
    #   power - 1: linear radon, 2: parabolic radon
    #   mode  - 1: forward, -1: adjoint
    #
    # output:            println(size(L))
    #   vectorized matrix of size (length(t) x length(q)) for forward, (length(t) x length(h)) for adjoint)
    #
    #
    function fwd_lpradon(in::Vector{idt}, t::Vector, h::Vector, q::Vector, power::Integer, rdt::DataType) where idt<:Real

        (idt<:Real && rdt<:Real) || throw(joLinearFunctionException("joRadon: input and output must be real"))

        dt   = t[2] - t[1]
        tN   = length(t)
        hN   = length(h)
        qN   = length(q)
        fftN = 2*nextpow(2,tN)
        two::idt = 2

        input = reshape(in,tN,hN)
        h=jo_convert(idt,h)
        q=jo_convert(idt,q)

        input_padded = Matrix{idt}(fftN, hN)
        input_padded[1:tN,:] = input[:,:]
        input_padded[tN+1:fftN,:] .= zero(idt)

        input_padded  = fft(input_padded, 1)
        out = zeros(Complex{rdt}, fftN, qN)

        for k = 2:Int(floor(fftN/2))
            f = two*pi*(k-1)/fftN/dt
            L = exp.(im*f*(h.^power)*q')
            tmp = transpose(input_padded[k,:])*L
            out[k,:] = tmp
            out[fftN+2-k,:] = conj(tmp)
        end
        out = real(ifft(out, 1))
        out = jo_convert(rdt,vec(out[1:tN,:]))

        return out
    end
    function adj_lpradon(in::Vector{idt}, t::Vector, h::Vector, q::Vector, power::Integer, rdt::DataType) where idt<:Real

        (idt<:Real && rdt<:Real) || throw(joLinearFunctionException("joRadon: input and output must be real"))

        dt   = t[2] - t[1]
        tN   = length(t)
        hN   = length(h)
        qN   = length(q)
        fftN = 2*nextpow(2,tN)
        two::idt = 2

        input = reshape(in,tN,qN)
        h=jo_convert(idt,h)
        q=jo_convert(idt,q)

        input_padded = Matrix{idt}(fftN, qN)
        input_padded[1:tN,:] = input[:,:]
        input_padded[tN+1:fftN,:] .= zero(idt)

        input_padded  = fft(input_padded,1)
        out = zeros(Complex{rdt}, fftN, hN)

        for k = 2:Int(floor(fftN/2))
            f = two*pi*(k-1)/fftN/dt
            L = exp.(im*f*(h.^power)*q')
            tmp = transpose(input_padded[k,:])*L'
            out[k,:] = tmp
            out[fftN+2-k,:] = conj(tmp)
        end

        out = real(ifft(out,1))
        out = jo_convert(rdt,vec(out[1:tN,:]))

        return out
    end
end
using .joRadon_etc

export joRadon
"""
    julia> joRadon(t,h,q,power)

2d linear and parabolic Radon transform

# Signature

    joRadon(t::Vector,h::Vector,q::Vector,power::Integer;DDT::DataType=joComplex,RDT::DataType=DDT)

# Arguments

- `t`: time vector [s]
- `h`: offset vector [m]
- `q`: Radon parameter
- `power`: 1: linear radon, 2: parabolic radon

# Notes

- joRadon is dimensionalized; it is not standard units-independent operator
- 2D array must be in vectorized form of array(t,h) of size (length(t),length(q))

"""
function joRadon(t::Vector,h::Vector,q::Vector,power::Integer;DDT::DataType=joComplex,RDT::DataType=DDT)
    (DDT<:Real && RDT<:Real) || throw(joLinearFunctionException("joRadon: domain and range must be real"))
    (power>0 && power<3) || throw(joLinearFunctionException("joRadon: power can only be either 1 or 2"))
    nt=length(t)
    nh=length(h)
    nq=length(q)
    return joLinearFunctionFwdT(nt*nq, nt*nh,
        v1->joRadon_etc.fwd_lpradon(vec(v1),t,h,q,power,RDT),
        v2->joRadon_etc.adj_lpradon(vec(v2),t,h,q,power,DDT),
        DDT,RDT;
        name="joRadon")
end
