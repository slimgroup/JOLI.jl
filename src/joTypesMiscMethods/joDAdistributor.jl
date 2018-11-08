############################################################
# joDAdistributor methods ##################################
############################################################

# helper module
module joDAdistributor_etc
    using Distributed
    function balanced_partition(nlabs::Integer,dsize::Integer)
        part = Vector{Int}(undef,nlabs)
        r::Int = rem(dsize,nlabs)
        c::Int = ceil(Int,dsize/nlabs)
        f::Int = floor(Int,dsize/nlabs)
        part[1:r]       .= c
        part[r+1:nlabs] .= f
        sum(part)==dsize || throw(joDAdistributorException("joDAdistributor: failed to properly partition $dsize to $nlabs workers"))
        return part
    end
    function balanced_partition_idxs(parts::Tuple{Vararg{INT}},dsize::Integer) where INT<:Integer
        vpart=collect(parts)
        nlabs=length(vpart)
        sum(vpart)==dsize || throw(joDAdistributorException("joDAdistributor: failed to properly partition $dsize to $nlabs workers"))
        idxs = Vector{Int}(undef,nlabs+1)
        for i=0:nlabs idxs[i+1]=sum(vpart[1:i])+1 end
        return idxs
    end
    function balanced_partition_idxs(nlabs::Integer,dsize::Integer)
        if dsize>=nlabs
            part = Vector{Int}(undef,nlabs)
            idxs = Vector{Int}(undef,nlabs+1)
            r::Int = rem(dsize,nlabs)
            c::Int = ceil(Int,dsize/nlabs)
            f::Int = floor(Int,dsize/nlabs)
            part[1:r]       .= c
            part[r+1:nlabs] .= f
            sum(part)==dsize || throw(joDAdistributorException("joDAdistributor: failed to properly partition $dsize to $nlabs workers"))
            for i=0:nlabs idxs[i+1]=sum(part[1:i])+1 end
        else
            idxs = [collect(1:dsize+1)..., zeros(Int, nlabs-dsize)...,]
        end
        return idxs
    end

    function default_chunks(dims::Dims,pids::Vector{INT}) where INT<:Integer
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

    function idxs_cuts(dims::Dims, chunks::Vector{INT}) where INT<:Integer
        cuts = map(balanced_partition_idxs, chunks, dims)
        n = length(dims)
        idxs = Array{NTuple{n,UnitRange{Int}}}(undef,chunks...)
        for cidx in CartesianIndices(tuple(chunks...))
            idxs[cidx.I...] = ntuple(i -> (cuts[i][cidx[i]]:cuts[i][cidx[i] .+ 1] .- 1), n)
        end
        return (idxs, cuts)
    end
    function idxs_cuts(dims::Dims, parts::Tuple{Vararg{Tuple{Vararg{INT}}}}) where INT<:Integer
        chunks=length.(parts)
        cuts = [map(balanced_partition_idxs, parts, dims)...]
        n = length(dims)
        idxs = Array{NTuple{n,UnitRange{Int}}}(undef,chunks...)
        for cidx in CartesianIndices(tuple(chunks...))
            idxs[cidx.I...] = ntuple(i -> (cuts[i][cidx[i]]:cuts[i][cidx[i] .+ 1] .- 1), n)
        end
        return (idxs, cuts)
    end
end
using .joDAdistributor_etc

# printouts
function show(d::joDAdistributor)
    println("joDAdistributor: ",d.name)
    println(" DataType: ",d.DT)
    println(" Dims    : ",d.dims)
    println(" Chunks  : ",d.chunks)
    println(" Workers : ",d.procs)
end
function display(d::joDAdistributor)
    println("joDAdistributor: ",d.name)
    println(" DataType: ",d.DT)
    println(" Dims    : ",d.dims)
    println(" Chunks  : ",d.chunks)
    println(" Workers : ",d.procs)
    for i=1:length(d.procs)
        @printf "  Worker/ranges: %3d " d.procs[i]
        println(d.idxs[i])
    end
end

# constructors
"""
    julia> transpose(in::joDAdistributor)

Get joDAdistributor represeanting transpose of another given joDAdistributor

# Notes
- operation will preserve # of distributed dimension
- only transposes of 1D distribution are supported

"""
function transpose(in::joDAdistributor)
    dims=reverse(in.dims)
    length(dims)==2 || throw(joDAdistributorException("joDAdistributor: transpose(joDAdistributor) makes sense only for 2D distributed arrays"))
    nlabs=length(in.procs)
    ddim=findfirst(i->i>1,in.chunks)
    ldim=findlast(i->i>1,in.chunks)
    ddim==ldim || throw(joDAdistributorException("joDAdistributor: cannot transpose and array with more then one distributed dimension"))
    parts=JOLI.joDAdistributor_etc.balanced_partition(nlabs,dims[ddim])
    return joDAdistributor(dims,ddim,DT=in.DT,parts=parts)
end

"""
    julia> joDAdistributor(in::DArray)

Get joDAdistributor represeanting a given DArray

"""
function joDAdistributor(DA::DArray)
    name=filter(x->!isspace(x),"DArray_$(DA.id)")
    dims=DA.dims
    procs=[DA.pids...,]
    chunks=map(i->length(i)-1,DA.cuts)
    idxs=DA.indices
    cuts=DA.cuts
    DT=eltype(DA)
    joDAdistributor(name,dims,procs,chunks,idxs,cuts,DT)
end

"""
    julia> joDAdistributor(wpool,dims;[DT,][chunks,][name])
    julia> joDAdistributor(dims;[DT,][chunks,][name])

Creates joDAdistributor type - basic distribution

# Signatures

    joDAdistributor(wpool::WorkerPool,dims::Dims;
        DT::DataType=joFloat,
        chunks::Vector{Integer}=joDAdistributor_etc.default_chunks(dims,sorted(workers(wpool))),
        name::String="joDAdistributor";
    joDAdistributor(dims::Dims;kwargs...)

# Arguments

- `wpool`: WorkerPool instance - defaults to WorkerPool(workers())
- `dims`: tuple with array's dimensions
- `DT`: DataType of array's elements
- `chunks`: vector of number of parts in each dimension
- `name`: name of distributor

# Examples

- `joDAdistributor((3,40,5);DT=Int8)`: basic distributor for Int8 array (3,40,5)
- `joDAdistributor((3,40,5);DT=Int8, chunks=[1,nworkers(),1])`: basic distributor for Int8 array (3,40,5) forcing distribution in 2nd dimension

"""
function joDAdistributor(wpool::WorkerPool,dims::Dims;
        DT::DataType=joFloat,
        chunks::Vector{INT}=joDAdistributor_etc.default_chunks(dims,sort(workers(wpool))),
        name::String="joDAdistributor",
        ) where INT<:Integer
    prod(dims)>0 || throw(joDAdistributorException("joDAdistributor: 0 dimension in $(dims)"))
    length(dims)==length(chunks) || throw(joDAdistributorException("joDAdistributor: mismatch between # of dimensions $(length(dims)) and chunks $(length(chunks))"))
    procs = sort(workers(wpool))
    length(procs)==prod(chunks) || throw(joDAdistributorException("joDAdistributor: mismatch between # of partitions $(prod(chunks)) and workers $(length(procs))"))
    idxs,cuts = joDAdistributor_etc.idxs_cuts(dims,chunks)
    return joDAdistributor(name,dims,procs,chunks,idxs,cuts,DT)
end
joDAdistributor(dims::Dims;kwargs...) = joDAdistributor(WorkerPool(workers()),dims;kwargs...)

"""
    julia> joDAdistributor(wpool,dims,ddim;[DT,][parts,][name])
    julia> joDAdistributor(dims,ddim;[DT,][parts,][name])

Creates joDAdistributor type

# Signature

    joDAdistributor(wpool::WorkerPool,dims::Dims,ddim::Integer;
        DT::DataType=joFloat,
        parts::Union{Vector{Integer},Dims}=joDAdistributor_etc.balanced_partition(nworkers(wpool),dims[ddim]),
        name::String="joDAdistributor",)
    joDAdistributor(dims::Dims,ddim::Integer;kwargs...)

# Arguments

- `wpool`: WorkerPool instance - defaults to WorkerPool(workers())
- `dims`: tuple with array's dimensions
- `ddim`: dimansion to distribute over
- `DT`: DataType of array's elements
- `parts`: tuple/vector of the subarray's size on each worker in distributed dimension
- `name`: name of distributor

# Examples

- `joDAdistributor((3,40,5),2;DT=Int8)`: distribute 2nd dimension over 4 workers
- `joDAdistributor((3,40,5),2;DT=Int8,parts=(11,11,11,7))`: distribute 2nd dimension over 4 workers and specify parts

"""
function joDAdistributor(wpool::WorkerPool,dims::Dims,ddim::Integer;
        DT::DataType=joFloat,
        parts::Union{Vector{INT},Dims}=joDAdistributor_etc.balanced_partition(nworkers(wpool),dims[ddim]),
        name::String="joDAdistributor") where INT<:Integer
    nd=length(dims)
    prod(dims)>0 || throw(joDAdistributorException("joDAdistributor: 0 dimension in $(dims)"))
    ddim<=nd || throw(joDAdistributorException("joDAdistributor: distributed dimension ($ddim) > # of dimensions ($nd)"))
    sum(parts)==dims[ddim] || throw(joDAdistributorException("joDAdistributor: size of distributed dimension's parts does not sum up to its size"))
    myparts=([i==ddim ? (parts...,) : tuple(dims[i]) for i=1:nd]...,)
    cdims=convert(Dims,(sum.([myparts...],)...,))
    dims==cdims || throw(joDAdistributorException("joDAdistributor: something terrible happened in partition calculations - seek help from developer"))
    chunks=[length.([myparts...])...]
    procs = sort(workers(wpool))
    prod(chunks)==length(procs) || throw(joDAdistributorException("joDAdistributor: mismatch between # of partitions $(prod(chunks)) and workers $(length(procs))"))
    idxs,cuts = joDAdistributor_etc.idxs_cuts(cdims,myparts)
    return joDAdistributor(name,cdims,procs,chunks,idxs,cuts,DT)
end
joDAdistributor(dims::Dims,ddim::Integer;kwargs...) = joDAdistributor(WorkerPool(workers()),dims,ddim;kwargs...)

"""
    julia> joDAdistributor(wpool,parts;[name],[DT])
    julia> joDAdistributor(parts;[name],[DT])

Creates joDAdistributor type with ultimate distribution topology control

# Signature

    joDAdistributor(wpool::WorkerPool,parts::Tuple{Vararg{Tuple{Vararg{Integer}}}};
        DT::DataType=joFloat,
        procs::Vector{Integer}=workers(),
        name::String="joDAdistributor")
    joDAdistributor(parts::Tuple{Vararg{Tuple{Vararg{INT}}}};kwargs...)

# Arguments

- `wpool`: WorkerPool instance - defaults to WorkerPool(workers())
- `parts`: tuple of tuples with subarray's size on each worker
- `DT`: DataType of array's elements
- `name`: name of distributor

# Examples

- `joDAdistributor(((3,),(10,10,10,10),(5,));DT=Int8)`: distribute Int8 array (3,40,5) over 2nd dimension

"""
function joDAdistributor(wpool::WorkerPool,parts::Tuple{Vararg{Tuple{Vararg{INT}}}};
        DT::DataType=joFloat,
        name::String="joDAdistributor") where INT<:Integer
    dims=convert(Dims,(sum.([parts...],)...,))
    prod(dims)>0 || throw(joDAdistributorException("joDAdistributor: 0 dimension in $(dims)"))
    chunks=[length.([parts...])...]
    procs = sort(workers(wpool))
    prod(chunks)==length(procs)  || throw(joDAdistributorException("joDAdistributor: mismatch between # of partitions $(prod(chunks)) and workers $(length(procs))"))
    idxs,cuts = joDAdistributor_etc.idxs_cuts(dims,parts)
    return joDAdistributor(name,dims,procs,chunks,idxs,cuts,DT)
end
joDAdistributor(parts::Tuple{Vararg{Tuple{Vararg{INT}}}};kwargs...) where INT<:Integer =
    joDAdistributor(WorkerPool(workers()),parts;kwargs...)

