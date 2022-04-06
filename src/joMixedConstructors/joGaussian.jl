# what is it: joGaussian

## helper module
module joGaussian_etc
    using JOLI: jo_convert, LocalVector
    using Random
    using LinearAlgebra
    function fI(v::LocalVector{vdt},m::Integer,n::Integer,rng::AbstractRNG,rns::Array{UInt32,1},rdt::DataType) where vdt<:Number
        rv = zeros(rdt,m)
        lrng=Random.seed!(rng,rns)
        for i=1:n
            rv = rv + randn(lrng,rdt,m) * v[i]
        end
        Random.seed!(rng,rns)
        rv = jo_convert(rdt,rv,false)
        return rv
    end
    function aI(v::LocalVector{vdt},m::Integer,n::Integer,rng::AbstractRNG,rns::Array{UInt32,1},rdt::DataType) where vdt<:Number
        rv = Vector{rdt}(undef,n)
        lrng=Random.seed!(rng,rns)
        for i=1:n
            rv[i] = (randn(lrng,rdt,1,m)*v)[1]
        end
        Random.seed!(rng,rns)
        rv = jo_convert(rdt,rv,false)
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
        rv = jo_convert(rdt,rv,false)
        return rv
    end
    function fIN(v::LocalVector{vdt},m::Integer,n::Integer,scale::LocalVector{<:Number},rng::AbstractRNG,rns::Array{UInt32,1},rdt::DataType) where vdt<:Number
        rv = zeros(rdt,m)
        lrng=Random.seed!(rng,rns)
        for i=1:n
            rv = rv + randn(lrng,rdt,m) * (scale[i]*v[i])
        end
        Random.seed!(rng,rns)
        rv = jo_convert(rdt,rv,false)
        return rv
    end
    function aIN(v::LocalVector{vdt},m::Integer,n::Integer,scale::LocalVector{<:Number},rng::AbstractRNG,rns::Array{UInt32,1},rdt::DataType) where vdt<:Number
        rv = Vector{rdt}(undef,n)
        lrng=Random.seed!(rng,rns)
        for i=1:n
            rv[i] = scale[i]*((randn(lrng,rdt,1,m)*v)[1])
        end
        Random.seed!(rng,rns)
        rv = jo_convert(rdt,rv,false)
        return rv
    end
end
using .joGaussian_etc

export joGaussian
"""
    julia> op = joGaussian(M,[N];
                [implicit=...,][normalized=...,][orthonormal=...,][RNG=...,]
                [DDT=...,][RDT=...,][name=...])

Gausian matrix

# Signature

    joGaussian(M::Integer,N::Integer=M;
        implicit::Bool=false,normalized::Bool=false,orthonormal::Bool=false,
        RNG::AbstractRNG=Random.seed!(),
        DDT::DataType=joFloat,RDT::DataType=DDT,
        name::String="joGaussian")

# Arguments

- `M[,N]`: sizes
- keywords
    - `implicit`: keyword element-free operator if true
    - `normalized`: keyword normalized (unit global-norm for explicit or unit-column norm for implicit) operator if true
    - `orthonormal`: keyword explict orthonormal operator if true (above implicit/normalized is ignorred); requires M<=N
    - `RNG`: keyword random number generator function with explicit seeding
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Notes

- AbstractRNG has to support seeding (RNG.seed atribute to type); e.g. RandomDevice() will not work

# Examples

not-normalized and explict dense matrix

    A=joGaussian(M,N)

explicit orthonormal dense matrix

    A=joGaussian(M,orthonormal=true)

not-normalized and element-free operator

    A=joGaussian(M,implicit=true)

normalized and explict dense matrix

    A=joGaussian(M,normalized=true)

normalized and element-free operator

    A=joGaussian(M,implicit=true,normalized=true)

examples with DDT/RDT

    A=joGaussian(M,N; DDT=Float32)
    A=joGaussian(M,N; DDT=Float32,RDT=Float64)

"""
function joGaussian(M::Integer,N::Integer=M;
         implicit::Bool=false,normalized::Bool=false,orthonormal::Bool=false,
         RNG::AbstractRNG=MersenneTwister(),
         DDT::DataType=joFloat,RDT::DataType=DDT,
         name::String="joGaussian")

    if orthonormal
        M>N && throw(joLinearFunctionException("Orthonormal mode is not supported when M > N"))
        A = qr(randn(RNG,DDT,N,M))
        #a = DDT(0.5)*(A.Q)'
        a = (A.Q)'
        return joMatrix(a;DDT=DDT,RDT=RDT,name=name*"_o")
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
                    name=name*"_in")
            else
                return joLinearFunctionFwd_A(M,N,
                    v1->joGaussian_etc.fI(v1,M,N,RNG,rngs,RDT),
                    v2->joGaussian_etc.aI(v2,M,N,RNG,rngs,DDT),
                    DDT,RDT;
                    name=name*"_i")
            end
        else
            a = randn(RNG,DDT,M,N)
            if normalized
                nf=one(DDT)/sqrt(sum(a.*a))
                a = a * sparse(nf*LinearAlgebra.I,N,N)
                return joMatrix(a;DDT=DDT,RDT=RDT,name=name*"_en")
            else
                return joMatrix(a;DDT=DDT,RDT=RDT,name=name*"_e")
            end
        end
    end
end

