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
dalloc{T}(::Type{T}, dims::Dims, args...) = DArray(I->Array{T}(map(length,I)), dims, args...)
dalloc{T}(::Type{T}, d1::Integer, drest::Integer...) = dalloc(T, convert(Dims, tuple(d1, drest...)))
dalloc(d1::Integer, drest::Integer...) = dalloc(joFloat, convert(Dims, tuple(d1, drest...)))
dalloc(d::Dims) = dalloc(joFloat, d)

"""
    julia> dalloc(d; [DT])

Allocates a DistributedArrays.DArray without value assigment.

Use it to allocate quicker the array that will have all elements overwritten.

# Signature

    dalloc(d::joDAdistributor;DT::DataType=d.DT)

# Arguments

- d: see help for joDAdistributor
- DT: keyword argument to overwrite the type in joDAdistributor

"""
function dalloc(d::joDAdistributor;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    init=I->Array{DT}(map(length,I))
    np = prod(d.chunks)
    procs = reshape(d.procs[1:np], ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

"""
    julia> dzeros(d; [DT])

Constructs a DistributedArrays.DArray filled with zeros.

# Signature

    dzeros(d::joDAdistributor;DT::DataType=d.DT)

# Arguments

- d: see help for joDAdistributor
- DT: keyword argument to overwrite the type in joDAdistributor

"""
function dzeros(d::joDAdistributor;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    init=I->zeros(DT,map(length,I))
    np = prod(d.chunks)
    procs = reshape(d.procs[1:np], ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

"""
    julia> dones(d; [DT])

Constructs a DistributedArrays.DArray filled with ones.

# Signature

    dones(d::joDAdistributor;DT::DataType=d.DT)

# Arguments

- d: see help for joDAdistributor
- DT: keyword argument to overwrite the type in joDAdistributor

"""
function dones(d::joDAdistributor;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    init=I->ones(DT,map(length,I))
    np = prod(d.chunks)
    procs = reshape(d.procs[1:np], ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

"""
    julia> dfill(x, d; [DT])

Constructs a DistributedArrays.DArray filled with x.

# Signature

    dfill(x::Number,d::joDAdistributor;DT::DataType=d.DT)

# Arguments

- d: see help for joDAdistributor
- DT: keyword argument to overwrite the type in joDAdistributor

"""
function dfill(x::Number,d::joDAdistributor;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    X=DT(x)
    init=I->fill(X,map(length,I))
    np = prod(d.chunks)
    procs = reshape(d.procs[1:np], ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

"""
    julia> drand(d; [DT], [RNG])

Constructs a DistributedArrays.DArray filled using built-in rand.

# Signature

    drand(d::joDAdistributor;DT::DataType=d.DT,RNG=RandomDevice())

# Arguments

- d: see help for joDAdistributor
- DT: keyword argument to overwrite the type in joDAdistributor
- RNG: random-number generator function (see help for rand/randn)

"""
function drand(d::joDAdistributor;DT::DataType=d.DT,RNG=RandomDevice())
    id=DistributedArrays.next_did()
    init=I->rand(RNG,DT,map(length,I))
    np = prod(d.chunks)
    procs = reshape(d.procs[1:np], ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

"""
    julia> drandn(d; [DT], [RNG])

Constructs a DistributedArrays.DArray filled using built-in randn.

# Signature

    drandn(d::joDAdistributor;DT::DataType=d.DT,RNG=RandomDevice())

# Arguments

- d: see help for joDAdistributor
- DT: keyword argument to overwrite the type in joDAdistributor
- RNG: random-number generator function (see help for rand/randn)

# Notes

- only float type are supported by randn (see help for randn)

"""
function drandn(d::joDAdistributor;DT::DataType=d.DT,RNG=RandomDevice())
    DT<:Integer && warn("Cannot use Integer type in randn.\n\t Overwite joDAdistributor's type using DT keyword\n\t or create Float joDAdistributor.\n\t Falling back to joFloat!"; once=true, key="JOLI:drandn:Integer")
    DT= (DT<:Integer) ? joFloat : DT
    id=DistributedArrays.next_did()
    init=I->randn(RNG,DT,map(length,I))
    np = prod(d.chunks)
    procs = reshape(d.procs[1:np], ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

