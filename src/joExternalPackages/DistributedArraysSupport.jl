export dalloc

"""
    julia> dalloc(dims, [...])

Allocates a DistributedArrays.DArray without value assigment.

Use it to allocate quicker the array that will have all elements overwritten.

# Signature

    dalloc(dims::Dims, [...])

# Arguments

- optional trailing arguments are the same as those accepted by `DArray`.

"""
dalloc(dims::Dims, args...) = DArray(I->Array{joFloat}(map(length,I)), dims, args...)
dalloc(::Type{T}, dims::Dims, args...) where {T} = DArray(I->Array{T}(undef,map(length,I)), dims, args...)
dalloc(::Type{T}, d1::Integer, drest::Integer...) where {T} = dalloc(T, convert(Dims, tuple(d1, drest...)))
dalloc(d1::Integer, drest::Integer...) = dalloc(joFloat, convert(Dims, tuple(d1, drest...)))
dalloc(d::Dims) = dalloc(joFloat, d)

"""
    julia> dfill(F, d; [DT])

Constructs a DistributedArrays.DArray, according to given distributor, filled with elements provided by anonymous function F.

# Signature

    dfill(F::Function,d::joDAdistributor;DT::DataType=d.DT)

# Arguments

- `F`: anonymous function of the form `I->f(...,map(length,I)))`
- `d`: see help for joDAdistributor
- `DT`: keyword argument to overwrite the type in joDAdistributor

# Notes

- function F will be passed via `map(length,I)` the tuple with dimensions of local part
- one has to pass array type manualy to F

# Examples

- `dfill(I->ones(d.DT,map(length,I)),d)`: fill a distributed array with ones of type d.DT

"""
function dfill(F::Function,d::joDAdistributor;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, F, d.dims, procs, d.idxs, d.cuts)
end

"""
    julia> dfill(x, d; [DT])

Constructs a DistributedArrays.DArray, according to given distributor, filled with x.

# Signature

    dfill(x::Number,d::joDAdistributor;DT::DataType=d.DT)

# Arguments

- `d`: see help for joDAdistributor
- `DT`: keyword argument to overwrite the type in joDAdistributor

# Examples

- `dfill(3.,d)`: fill a distributed array with d.DT(3.)
- `dfill(3.,d;DT=Float32)`: fill a distributed array with Float32(3.)

"""
function dfill(x::Number,d::joDAdistributor;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    X=DT(x)
    init=I->fill(X,map(length,I))
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

"""
    julia> dalloc(d; [DT])

Allocates a DistributedArrays.DArray, according to given distributor, without value assigment.

Use it to allocate quicker the array that will have all elements overwritten.

# Signature

    dalloc(d::joDAdistributor;DT::DataType=d.DT)

# Arguments

- `d`: see help for joDAdistributor
- `DT`: keyword argument to overwrite the type in joDAdistributor

# Examples

- `dalloc(d)`: allocate an array
- `dalloc(d,DT=Float32)`: allocate array and overwite d.DT with Float32

"""
function dalloc(d::joDAdistributor;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    init=I->Array{DT}(undef,map(length,I))
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

"""
    julia> dzeros(d; [DT])

Constructs a DistributedArrays.DArray, according to given distributor, filled with zeros.

# Signature

    dzeros(d::joDAdistributor;DT::DataType=d.DT)

# Arguments

- `d`: see help for joDAdistributor
- `DT`: keyword argument to overwrite the type in joDAdistributor

# Examples

- `dzeros(d)`: allocate an array of zeros
- `dzeros(d,DT=Float32)`: allocate array of Float32 zeros

"""
function dzeros(d::joDAdistributor;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    init=I->zeros(DT,map(length,I))
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

"""
    julia> dones(d; [DT])

Constructs a DistributedArrays.DArray, according to given distributor, filled with ones.

# Signature

    dones(d::joDAdistributor;DT::DataType=d.DT)

# Arguments

- `d`: see help for joDAdistributor
- `DT`: keyword argument to overwrite the type in joDAdistributor

# Examples

- `dones(d)`: allocate an array of ones
- `dones(d,DT=Float32)`: allocate array of Float32 ones

"""
function dones(d::joDAdistributor;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    init=I->ones(DT,map(length,I))
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

"""
    julia> drand(d; [DT], [RNG])

Constructs a DistributedArrays.DArray, according to given distributor, filled using built-in rand.

# Signature

    drand(d::joDAdistributor;DT::DataType=d.DT,RNG::AbstractRNG=RandomDevice())

# Arguments

- `d`: see help for joDAdistributor
- `DT`: keyword argument to overwrite the type in joDAdistributor
- `RNG`: random-number generator function (see help for rand/randn)

# Examples

- `drand(d)`: allocate an array with rand
- `drand(d,DT=Float32)`: allocate array with rand of Float32
- `drand(d,DT=Float32,RNG=MersenneTwister(1234))`: allocate array with rand of Float32 using MersenneTwister() random device

"""
function drand(d::joDAdistributor;DT::DataType=d.DT,RNG::AbstractRNG=RandomDevice())
    id=DistributedArrays.next_did()
    init=I->rand(RNG,DT,map(length,I))
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

"""
    julia> drandn(d; [DT], [RNG])

Constructs a DistributedArrays.DArray, according to given distributor, filled using built-in randn.

# Signature

    drandn(d::joDAdistributor;DT::DataType=d.DT,RNG::AbstractRNG=RandomDevice())

# Arguments

- `d`: see help for joDAdistributor
- `DT`: keyword argument to overwrite the type in joDAdistributor
- `RNG`: random-number generator function (see help for rand/randn)

# Notes

- only float type are supported by randn (see help for randn)

# Examples

- `drandn(d)`: allocate an array with randn
- `drandn(d,DT=Float32)`: allocate array with randn of Float32
- `drandn(d,DT=Float32,RNG=MersenneTwister(1234))`: allocate array with randn of Float32 using MersenneTwister() random device

"""
function drandn(d::joDAdistributor;DT::DataType=d.DT,RNG::AbstractRNG=RandomDevice())
    DT<:Integer && @warn "Cannot use Integer type in randn.\n\t Overwite joDAdistributor's type using DT keyword\n\t or create Float joDAdistributor.\n\t Falling back to joFloat!" key="JOLI:drandn:Integer" maxlog=1
    DT= (DT<:Integer) ? joFloat : DT
    id=DistributedArrays.next_did()
    init=I->randn(RNG,DT,map(length,I))
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

"""
    julia> distribute(A,d)

Distributes array according to given joDAdistributor.

# Signature

    distribute(a::AbstractArray,d::joDAdistributor)

# Arguments

- `A`: array to ditribute
- `d`: see help for joDAdistributor

# Notes

- the type in joDAdistributor is ignored here
- distributes over last non-singleton (worker-wise) dimension
- one of the dimensions must be large enough to hold at least one element on each worker

# Examples

- `distribute(A,d)`: distribute A using given distributor
- `distribute(A,joDAdistributor(size(A)...))`: distribute A using default distributor settings

"""
function distribute(A::AbstractArray,d::joDAdistributor)
    @assert size(A)==d.dims "FATAL ERROR: array size does not match dims of joDAdistributor"
    id=DistributedArrays.next_did()
    s = DistributedArrays.verified_destination_serializer(reshape(d.procs, size(d.idxs)), size(d.idxs)) do pididx
        A[d.idxs[pididx]...]
    end
    init = I->DistributedArrays.localpart(s)
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

