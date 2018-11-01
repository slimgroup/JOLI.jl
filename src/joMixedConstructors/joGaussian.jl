# what is it: joGaussian

## helper module
module joGaussian_etc
    using JOLI: jo_convert
    using Random
    using LinearAlgebra
    function fI(v::AbstractVector{<:Number},m::Integer,n::Integer,rng::AbstractRNG,rns::Array{UInt32,1},rdt::DataType)
        rv = zeros(rdt,m)
        lrng=Random.seed!(rng,rns)
        for i=1:n
            rv = rv + randn(lrng,rdt,m) * v[i]
        end
        Random.seed!(rng,rns)
        rv = jo_convert(rdt,rv)
        return rv
    end
    function aI(v::AbstractVector{<:Number},m::Integer,n::Integer,rng::AbstractRNG,rns::Array{UInt32,1},rdt::DataType)
        rv = Vector{rdt}(undef,n)
        lrng=Random.seed!(rng,rns)
        for i=1:n
            rv[i] = (randn(lrng,rdt,1,m)*v)[1]
        end
        Random.seed!(rng,rns)
        rv = jo_convert(rdt,rv)
        return rv
    end
    function scale(m::Integer,n::Integer,rng::AbstractRNG,rns::Array{UInt32,1},rdt::DataType)
        rv = Vector{rdt}(undef,n)
        lrng=Random.seed!(rng,rns)
        for i=1:n
            #v = rdt(2.) .* randn(lrng,rdt,m)
            v = randn(lrng,rdt,m)
            rv[i] = (one(rdt)/sqrt(v'*v))
        end
        Random.seed!(rng,rns)
        rv = jo_convert(rdt,rv)
        return rv
    end
    function fIN(v::AbstractVector{<:Number},m::Integer,n::Integer,scale::AbstractVector{<:Number},rng::AbstractRNG,rns::Array{UInt32,1},rdt::DataType)
        rv = zeros(rdt,m)
        lrng=Random.seed!(rng,rns)
        for i=1:n
            rv = rv + randn(lrng,rdt,m) * (scale[i]*v[i])
        end
        Random.seed!(rng,rns)
        rv = jo_convert(rdt,rv)
        return rv
    end
    function aIN(v::AbstractVector{<:Number},m::Integer,n::Integer,scale::AbstractVector{<:Number},rng::AbstractRNG,rns::Array{UInt32,1},rdt::DataType)
        rv = Vector{rdt}(undef,n)
        lrng=Random.seed!(rng,rns)
        for i=1:n
            rv[i] = scale[i]*((randn(lrng,rdt,1,m)*v)[1])
        end
        Random.seed!(rng,rns)
        rv = jo_convert(rdt,rv)
        return rv
    end
end
using .joGaussian_etc

export joGaussian
"""
    julia> A=joGaussian(M,N;kwargs...)

% Description including return type

# Signature

    joGaussian(M::Integer,N::Integer=M;
        DDT::DataType=joFloat,RDT::DataType=DDT,
        implicit::Bool=false,normalized::Bool=false,orthonormal::Bool=false,
        RNG::AbstractRNG=Random.seed!())

# Arguments

- `M`,`N`: size
- optional
    - `DDT`,`RDT`: keyword domain/range DataType
    - `implicit`: keyword element-free operator if true
    - `normalized`: keyword normalized (unit global-norm for explicit or unit-column norm for implicit) operator if true
    - `orthonormal`: keyword explict orthonormal operator if true (above implicit/normalized is ignorred); requires M<=N
    - `RNG`: keyword random number generator function with explicit seeding

# Notes

- AbstractRNG has to support seeding (RNG.seed atribute to type); e.g. RandomDevice() will not work

# Examples

- `A=joGaussian(M,N)`: not-normalized and explict dense matrix
- `A=joGaussian(M,orthonormal=true)`: explicit orthonormal dense matrix
- `A=joGaussian(M,implicit=true)`: not-normalized and element-free operator
- `A=joGaussian(M,normalized=true)`: normalized and explict dense matrix
- `A=joGaussian(M,implicit=true,normalized=true)`: normalized and element-free operator

"""
function joGaussian(M::Integer,N::Integer=M;
         DDT::DataType=joFloat,RDT::DataType=DDT,
         implicit::Bool=false,normalized::Bool=false,orthonormal::Bool=false,
         RNG::AbstractRNG=Random.seed!())

    if orthonormal
        M>N && throw(joLinearFunctionException("Orthonormal mode is not supported when M > N"))
        A = qr(randn(RNG,DDT,N,M))
        #a = DDT(0.5)*(A.Q)'
        a = (A.Q)'
        return joMatrix(a;DDT=DDT,RDT=RDT,name="joGaussianO")
    else
        if implicit
            rngs=copy(RNG.seed)
            if normalized
                fscale = joGaussian_etc.scale(M,N,RNG,rngs,DDT)
                ascale = joGaussian_etc.scale(M,N,RNG,rngs,RDT)
                return joLinearFunctionFwd_A(M,N,
                    v1->joGaussian_etc.fIN(v1,M,N,fscale,RNG,rngs,RDT),
                    v2->joGaussian_etc.aIN(v2,M,N,ascale,RNG,rngs,DDT),
                    DDT,RDT;
                    name="joGaussianIN")
            else
                return joLinearFunctionFwd_A(M,N,
                    v1->joGaussian_etc.fI(v1,M,N,RNG,rngs,RDT),
                    v2->joGaussian_etc.aI(v2,M,N,RNG,rngs,DDT),
                    DDT,RDT;
                    name="joGaussianI")
            end
        else
            a = randn(RNG,DDT,M,N)
            if normalized
                nf=one(DDT)/sqrt(sum(a.*a))
                a = a * sparse(nf*LinearAlgebra.I,N,N)
                return joMatrix(a;DDT=DDT,RDT=RDT,name="joGaussianEN")
            else
                return joMatrix(a;DDT=DDT,RDT=RDT,name="joGaussianE")
            end
        end
    end
end

