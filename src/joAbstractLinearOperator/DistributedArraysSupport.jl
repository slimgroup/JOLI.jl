module joDAdistributor_etc
    function balanced_partition(part::Tuple{Vararg{<:Integer}},dsize::Integer)
        vpart=collect(part)
        nlabs=length(vpart)
        @assert sum(vpart)==dsize "FATAL ERROR: failed to properly partition $dsize to $nlabs workers"
        idxs = Vector{Int}(nlabs+1)
        for i=0:nlabs idxs[i+1]=sum(vpart[1:i])+1 end
        return idxs
    end
    function balanced_partition(nlabs::Integer,dsize::Integer)
        if dsize>=nlabs
            part = Vector{Int}(nlabs)
            idxs = Vector{Int}(nlabs+1)
            r::Int = rem(dsize,nlabs)
            c::Int = ceil(Int,dsize/nlabs)
            f::Int = floor(Int,dsize/nlabs)
            part[1:r]       = c
            part[r+1:nlabs] = f
            @assert sum(part)==dsize "FATAL ERROR: failed to properly partition $dsize to $nlabs workers"
            for i=0:nlabs idxs[i+1]=sum(part[1:i])+1 end
        else
            idxs = [[1:(dsize+1);], zeros(Int, nlabs-dsize);]
        end
        return idxs
    end

    function default_distribution(dims::Dims,pids::Vector{<:Integer})
        chunks = ones(Int, length(dims))
        np = length(pids)
            nd = length(dims)
        for i=nd:-1:1
            if dims[i]>=np
                chunks[i]=np
                return chunks
            end
        end
        return chunks
    end

    function idxs_cuts(dims::Dims, chunks::Vector{<:Integer})
        cuts = map(balanced_partition, chunks, dims)
        n = length(dims)
        idxs = Array{NTuple{n,UnitRange{Int}}}(chunks...)
        for cidx in CartesianRange(tuple(chunks...))
            idxs[cidx.I...] = ntuple(i -> (cuts[i][cidx[i]]:cuts[i][cidx[i] + 1] - 1), n)
        end
        return (idxs, cuts)
    end
    function idxs_cuts(dims::Dims, parts::Tuple{Vararg{Tuple{Vararg{<:Integer}}}})
        chunks=length.(parts)
        cuts = [map(balanced_partition, parts, dims)...]
        n = length(dims)
        idxs = Array{NTuple{n,UnitRange{Int}}}(chunks...)
        for cidx in CartesianRange(tuple(chunks...))
            idxs[cidx.I...] = ntuple(i -> (cuts[i][cidx[i]]:cuts[i][cidx[i] + 1] - 1), n)
        end
        return (idxs, cuts)
    end
end
using .joDAdistributor_etc

export joDAdistributor
struct joDAdistributor
    dims::Dims
    procs::Vector{Int}
    parts::Vector{Int}
    idxs::Array{Tuple{Vararg{UnitRange{<:Integer}}}}
    cuts::Vector{Vector{<:Integer}}
    DT::DataType
end
function joDAdistributor(dims::Dims,
        procs::Vector{<:Integer}=workers(),
        parts::Vector{<:Integer}=joDAdistributor_etc.default_distribution(dims,procs);
        DT::DataType=Float64)
    idxs,cuts = joDAdistributor_etc.idxs_cuts(dims,parts)
    return joDAdistributor(dims,procs,parts,idxs,cuts,DT)
end
function joDAdistributor(parts::Tuple{Vararg{Tuple{Vararg{<:Integer}}}},
        procs::Vector{<:Integer}=workers();
        DT::DataType=Float64)
    cdims=convert(Dims,(sum.([parts...])...))
    cparts=[length.([parts...])...]
    nparts=prod(cparts); nprocs=length(procs)
    @assert nparts==nprocs "FATAL ERROR: mismatch between # of partitions ($nparts) and workers ($nprocs)"
    idxs,cuts = joDAdistributor_etc.idxs_cuts(cdims,parts)
    return joDAdistributor(cdims,procs,cparts,idxs,cuts,DT)
end
function joDAdistributor(dims::Dims,
        ddim::Integer,dparts::Union{Vector{<:Integer},Dims},
        procs::Vector{<:Integer}=workers();
        DT::DataType=Float64)
    nd=length(dims)
    @assert sum(dparts)==dims[ddim] "FATAL ERROR: size of distributed dimension's parts does not sum up to its size"
    @assert ddim<=nd "FATAL ERROR: distributed dimension ($ddim) > # of dimensions ($nd)"
    parts=([i==ddim?(dparts...):tuple(dims[i]) for i=1:nd]...)
    cdims=convert(Dims,(sum.([parts...])...))
    cparts=[length.([parts...])...]
    nparts=prod(cparts); nprocs=length(procs)
    @assert nparts==nprocs "FATAL ERROR: mismatch between # of partitions ($nparts) and workers ($nprocs)"
    idxs,cuts = joDAdistributor_etc.idxs_cuts(cdims,parts)
    return joDAdistributor(cdims,procs,cparts,idxs,cuts,DT)
end
joDAdistributor(dims::Integer...;DT::DataType=Float64) = joDAdistributor(convert(Dims,dims);DT=DT)

export dalloc
"""
    dalloc(dims, ...)

Construct and allocate a distributed array without assigment of any value.

Use it to allocate quicker the array that will have all elements overwritten.

# SIGNATURE

    dalloc(dims::Dims, ...)

# WHERE

- trailing arguments are the same as those accepted by `DArray`.

"""
dalloc(dims::Dims, args...) = DArray(I->Array{Float64}(map(length,I)), dims, args...)
dalloc{T}(::Type{T}, dims::Dims, args...) = DArray(I->Array{T}(map(length,I)), dims, args...)
dalloc{T}(::Type{T}, d1::Integer, drest::Integer...) = dalloc(T, convert(Dims, tuple(d1, drest...)))
dalloc(d1::Integer, drest::Integer...) = dalloc(Float64, convert(Dims, tuple(d1, drest...)))
dalloc(d::Dims) = dalloc(Float64, d)
#dalloc(d::joDAdistributor) = dalloc(d.DT, d.dims, d.procs, d.parts)
"""
    dalloc(d; DT)

Construct and allocate a distributed array without assigment of any value.

Use it to allocate quicker the array that will have all elements overwritten.

# SIGNATURE

    dalloc(d::joDAdistributor;DT::DataType=d.DT)

# WHERE

- d: see help for joDAdistributor
- DT: keyword argument to overwrite the type in joDAdistributor

"""
function dalloc(d::joDAdistributor;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    init=I->Array{DT}(map(length,I))
    np = prod(d.parts)
    procs = reshape(d.procs[1:np], ntuple(i->d.parts[i], length(d.parts)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end
"""
    dzeros(d; DT)

Construct and allocate a distributed array filled with zeros.

# SIGNATURE

    dzeros(d::joDAdistributor;DT::DataType=d.DT)

# WHERE

- d: see help for joDAdistributor
- DT: keyword argument to overwrite the type in joDAdistributor

"""
function dzeros(d::joDAdistributor;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    init=I->zeros(DT,map(length,I))
    np = prod(d.parts)
    procs = reshape(d.procs[1:np], ntuple(i->d.parts[i], length(d.parts)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end
"""
    dones(d; DT)

Construct and allocate a distributed array filled with ones.

# SIGNATURE

    dones(d::joDAdistributor;DT::DataType=d.DT)

# WHERE

- d: see help for joDAdistributor
- DT: keyword argument to overwrite the type in joDAdistributor

"""
function dones(d::joDAdistributor;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    init=I->ones(DT,map(length,I))
    np = prod(d.parts)
    procs = reshape(d.procs[1:np], ntuple(i->d.parts[i], length(d.parts)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end
"""
    dfill(x, d; DT)

Construct and allocate a distributed array filled with x.

# SIGNATURE

    dfill(x::Number,d::joDAdistributor;DT::DataType=d.DT)

# WHERE

- d: see help for joDAdistributor
- DT: keyword argument to overwrite the type in joDAdistributor

"""
function dfill(x::Number,d::joDAdistributor;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    X=DT(x)
    init=I->fill(X,map(length,I))
    np = prod(d.parts)
    procs = reshape(d.procs[1:np], ntuple(i->d.parts[i], length(d.parts)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end
"""
    drand(d; DT, RNG)

Construct and allocate a distributed array filled using built-in rand.

# SIGNATURE

    drand(d::joDAdistributor;DT::DataType=d.DT,RNG=RandomDevice())

# WHERE

- d: see help for joDAdistributor
- DT: keyword argument to overwrite the type in joDAdistributor
- RNG: random-number generator function (see help for rand/randn)

"""
function drand(d::joDAdistributor;DT::DataType=d.DT,RNG=RandomDevice())
    id=DistributedArrays.next_did()
    init=I->rand(RNG,DT,map(length,I))
    np = prod(d.parts)
    procs = reshape(d.procs[1:np], ntuple(i->d.parts[i], length(d.parts)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end
"""
    drandn(d; DT, RNG)

Construct and allocate a distributed array filled using built-in randn.

# SIGNATURE

    drandn(d::joDAdistributor;DT::DataType=d.DT,RNG=RandomDevice())

# WHERE

- d: see help for joDAdistributor
- DT: keyword argument to overwrite the type in joDAdistributor
- RNG: random-number generator function (see help for rand/randn)

# NOTES

- only float type are supported by randn (see help for randn)

"""
function drandn(d::joDAdistributor;DT::DataType=d.DT,RNG=RandomDevice())
    DT<:Integer && warn("Cannot use Integer type in randn.\n\t Overwite joDAdistributor's type using DT keyword\n\t or create Float joDAdistributor"; once=true, key="JOLI:drandn:Integer")
    DT= (DT<:Integer) ? Float64 : DT
    id=DistributedArrays.next_did()
    init=I->randn(RNG,DT,map(length,I))
    np = prod(d.parts)
    procs = reshape(d.procs[1:np], ntuple(i->d.parts[i], length(d.parts)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

