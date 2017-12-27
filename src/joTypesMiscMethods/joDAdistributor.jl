############################################################
# joDAdistributor methods ##################################
############################################################

# helper module
module joDAdistributor_etc
    function balanced_partition(parts::Tuple{Vararg{<:Integer}},dsize::Integer)
        vpart=collect(parts)
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

# constructors
"""
    julia> joDAdistributor(dims,procs,chunks;DT)

Creates joDAdistributor type

# Signature

    joDAdistributor(dims::Dims,
        procs::Vector{<:Integer}=workers(),
        chunks::Vector{<:Integer}=joDAdistributor_etc.default_distribution(dims,procs);
        DT::DataType=joFloat)

# Arguments

- dims - tuple with array's dimensions
- procs - vector of workers' ids
- chunks - vector of number of parts in each dimension
- DT - DataType of array's elements

# Examples

- joDAdistributor((3,40,5),workers(),[1,4,1];DT=Int8) - distribute Int8 array (3,40,5) over 2nd dimension and 4 workers

"""
function joDAdistributor(dims::Dims,
        procs::Vector{<:Integer}=workers(),
        chunks::Vector{<:Integer}=joDAdistributor_etc.default_distribution(dims,procs);
        DT::DataType=joFloat)
    idxs,cuts = joDAdistributor_etc.idxs_cuts(dims,chunks)
    return joDAdistributor(dims,procs,chunks,idxs,cuts,DT)
end
"""
    julia> joDAdistributor(parts,procs;DT)

Creates joDAdistributor type

# Signature

    joDAdistributor(parts::Tuple{Vararg{Tuple{Vararg{<:Integer}}}},
        procs::Vector{<:Integer}=workers();
        DT::DataType=joFloat)

# Arguments

- parts - tuple of tuples with part's size on each worker
- procs - vector of workers' ids
- DT - DataType of array's elements

# Examples

- joDAdistributor(((3,),(10,10,10,10),(5,));DT=Int8) - distribute Int8 array (3,40,5) over 2nd dimension and 4 workers

"""
function joDAdistributor(parts::Tuple{Vararg{Tuple{Vararg{<:Integer}}}},
        procs::Vector{<:Integer}=workers();
        DT::DataType=joFloat)
    cdims=convert(Dims,(sum.([parts...])...))
    chunks=[length.([parts...])...]
    nparts=prod(chunks); nprocs=length(procs)
    @assert nparts==nprocs "FATAL ERROR: mismatch between # of partitions ($nparts) and workers ($nprocs)"
    idxs,cuts = joDAdistributor_etc.idxs_cuts(cdims,parts)
    return joDAdistributor(cdims,procs,chunks,idxs,cuts,DT)
end
"""
    julia> joDAdistributor(dims,ddim,dparts,procs;DT)

Creates joDAdistributor type

# Signature

    function joDAdistributor(dims::Dims,
        ddim::Integer,dparts::Union{Vector{<:Integer},Dims},
        procs::Vector{<:Integer}=workers();
        DT::DataType=joFloat)

# Arguments

- dims - tuple with array's dimensions
- ddim - dimansion to distribute over
- dparts - tupe/vector of the part's size on each worker
- procs - vector of workers' ids
- DT - DataType of array's elements

# Examples

- joDAdistributor((3,40,5),2,(10,10,10,10);DT=Int8) - distribute 2nd dimension over 4 workers

"""
function joDAdistributor(dims::Dims,
        ddim::Integer,dparts::Union{Vector{<:Integer},Dims},
        procs::Vector{<:Integer}=workers();
        DT::DataType=joFloat)
    nd=length(dims)
    @assert sum(dparts)==dims[ddim] "FATAL ERROR: size of distributed dimension's parts does not sum up to its size"
    @assert ddim<=nd "FATAL ERROR: distributed dimension ($ddim) > # of dimensions ($nd)"
    parts=([i==ddim?(dparts...):tuple(dims[i]) for i=1:nd]...)
    cdims=convert(Dims,(sum.([parts...])...))
    chunks=[length.([parts...])...]
    nparts=prod(chunks); nprocs=length(procs)
    @assert nparts==nprocs "FATAL ERROR: mismatch between # of partitions ($nparts) and workers ($nprocs)"
    idxs,cuts = joDAdistributor_etc.idxs_cuts(cdims,parts)
    return joDAdistributor(cdims,procs,chunks,idxs,cuts,DT)
end
"""
    julia> joDAdistributor(m[,n[...]];DT)

Creates joDAdistributor type

# Signature

    joDAdistributor(dims::Integer...;DT::DataType=joFloat)

# Arguments

- m[,n[...]]: dimensions of distributed array

# Notes

- distributes over last non-singleton (worker-wise) dimension
- one of the dimensions must be large enough to have at least one index

# Examples

- joDAdistributor(20,30,4;DT=Int8) - distributes over 3rd dimension if nworkers <=4, or 2nd dimension if 4< nworkers <=30

"""
joDAdistributor(dims::Integer...;DT::DataType=joFloat) = joDAdistributor(convert(Dims,dims);DT=DT)

