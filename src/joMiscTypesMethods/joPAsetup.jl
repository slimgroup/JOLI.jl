############################################################
# joPAsetup constructors and methods #######################

############################################################
# joPAsetup constructors       #############################

# helper module
module joPAsetup_etc
    using Distributed
    function balanced_partition(nlabs::Integer,dsize::Integer)
        part = Vector{Int}(undef,nlabs)
        r::Int = rem(dsize,nlabs)
        c::Int = ceil(Int,dsize/nlabs)
        f::Int = floor(Int,dsize/nlabs)
        part[1:r]       .= c
        part[r+1:nlabs] .= f
        sum(part)==dsize || throw(joPAsetupException("joPAsetup: failed to properly partition $dsize to $nlabs workers"))
        return part
    end
    function balanced_partition_idxs(parts::Tuple{Vararg{INT}},dsize::Integer) where INT<:Integer
        vpart=collect(parts)
        nlabs=length(vpart)
        sum(vpart)==dsize || throw(joPAsetupException("joPAsetup: failed to properly partition $dsize to $nlabs workers"))
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
            sum(part)==dsize || throw(joPAsetupException("joPAsetup: failed to properly partition $dsize to $nlabs workers"))
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
using .joPAsetup_etc

"""
    julia> joPAsetup(in::DArray)

Get joPAsetup represeanting a given DArray

"""
function joPAsetup(DA::DArray)
    name=filter(x->!isspace(x),"DArray_$(DA.id)")
    dims=DA.dims
    procs=[DA.pids...,]
    chunks=map(i->length(i)-1,DA.cuts)
    idxs=DA.indices
    cuts=DA.cuts
    DT=eltype(DA)
    joPAsetup(name,dims,procs,chunks,idxs,cuts,DT)
end

"""
    julia> joPAsetup(wpool,dims;[DT,][chunks,][name])
    julia> joPAsetup(dims;[DT,][chunks,][name])

Creates joPAsetup type - basic distribution

# Signatures

    joPAsetup(wpool::WorkerPool,dims::Dims;
        DT::DataType=joFloat,
        chunks::Vector{Integer}=joPAsetup_etc.default_chunks(dims,sorted(workers(wpool))),
        name::String="joPAsetup";
    joPAsetup(dims::Dims;kwargs...)

# Arguments

- `wpool`: WorkerPool instance - defaults to WorkerPool(workers())
- `dims`: tuple with array's dimensions
- `DT`: DataType of array's elements
- `chunks`: vector of number of parts in each dimension
- `name`: name of distributor

# Examples

- `joPAsetup((3,40,5);DT=Int8)`: basic distributor for Int8 array (3,40,5)
- `joPAsetup((3,40,5);DT=Int8, chunks=[1,nworkers(),1])`: basic distributor for Int8 array (3,40,5) forcing distribution in 2nd dimension

"""
function joPAsetup(wpool::WorkerPool,dims::Dims;
        DT::DataType=joFloat,
        chunks::Vector{INT}=joPAsetup_etc.default_chunks(dims,sort(workers(wpool))),
        name::String="joPAsetup",
        ) where INT<:Integer
    prod(dims)>0 || throw(joPAsetupException("joPAsetup: 0 dimension in $(dims)"))
    length(dims)==length(chunks) || throw(joPAsetupException("joPAsetup: mismatch between # of dimensions $(length(dims)) and chunks $(length(chunks))"))
    procs = sort(workers(wpool))
    length(procs)==prod(chunks) || throw(joPAsetupException("joPAsetup: mismatch between # of partitions $(prod(chunks)) and workers $(length(procs))"))
    idxs,cuts = joPAsetup_etc.idxs_cuts(dims,chunks)
    return joPAsetup(name,dims,procs,chunks,idxs,cuts,DT)
end
joPAsetup(dims::Dims;kwargs...) = joPAsetup(WorkerPool(workers()),dims;kwargs...)

"""
    julia> joPAsetup(wpool,dims,ddim;[DT,][parts,][name])
    julia> joPAsetup(dims,ddim;[DT,][parts,][name])

Creates joPAsetup type

# Signature

    joPAsetup(wpool::WorkerPool,dims::Dims,ddim::Integer;
        DT::DataType=joFloat,
        parts::Union{Vector{Integer},Dims}=joPAsetup_etc.balanced_partition(nworkers(wpool),dims[ddim]),
        name::String="joPAsetup",)
    joPAsetup(dims::Dims,ddim::Integer;kwargs...)

# Arguments

- `wpool`: WorkerPool instance - defaults to WorkerPool(workers())
- `dims`: tuple with array's dimensions
- `ddim`: dimansion to distribute over
- `DT`: DataType of array's elements
- `parts`: tuple/vector of the subarray's size on each worker in distributed dimension
- `name`: name of distributor

# Examples

- `joPAsetup((3,40,5),2;DT=Int8)`: distribute 2nd dimension over 4 workers
- `joPAsetup((3,40,5),2;DT=Int8,parts=(11,11,11,7))`: distribute 2nd dimension over 4 workers and specify parts

"""
function joPAsetup(wpool::WorkerPool,dims::Dims,ddim::Integer;
        DT::DataType=joFloat,
        parts::Union{Vector{INT},Dims}=joPAsetup_etc.balanced_partition(nworkers(wpool),dims[ddim]),
        name::String="joPAsetup") where INT<:Integer
    nd=length(dims)
    prod(dims)>0 || throw(joPAsetupException("joPAsetup: 0 dimension in $(dims)"))
    ddim<=nd || throw(joPAsetupException("joPAsetup: distributed dimension ($ddim) > # of dimensions ($nd)"))
    sum(parts)==dims[ddim] || throw(joPAsetupException("joPAsetup: size of distributed dimension's parts does not sum up to its size"))
    myparts=([i==ddim ? (parts...,) : tuple(dims[i]) for i=1:nd]...,)
    cdims=convert(Dims,(sum.([myparts...],)...,))
    dims==cdims || throw(joPAsetupException("joPAsetup: something terrible happened in partition calculations - seek help from developer"))
    chunks=[length.([myparts...])...]
    procs = sort(workers(wpool))
    prod(chunks)==length(procs) || throw(joPAsetupException("joPAsetup: mismatch between # of partitions $(prod(chunks)) and workers $(length(procs))"))
    idxs,cuts = joPAsetup_etc.idxs_cuts(cdims,myparts)
    return joPAsetup(name,cdims,procs,chunks,idxs,cuts,DT)
end
joPAsetup(dims::Dims,ddim::Integer;kwargs...) = joPAsetup(WorkerPool(workers()),dims,ddim;kwargs...)

"""
    julia> joPAsetup(wpool,parts;[name],[DT])
    julia> joPAsetup(parts;[name],[DT])

Creates joPAsetup type with ultimate distribution topology control

# Signature

    joPAsetup(wpool::WorkerPool,parts::Tuple{Vararg{Tuple{Vararg{Integer}}}};
        DT::DataType=joFloat,
        procs::Vector{Integer}=workers(),
        name::String="joPAsetup")
    joPAsetup(parts::Tuple{Vararg{Tuple{Vararg{INT}}}};kwargs...)

# Arguments

- `wpool`: WorkerPool instance - defaults to WorkerPool(workers())
- `parts`: tuple of tuples with subarray's size on each worker
- `DT`: DataType of array's elements
- `name`: name of distributor

# Examples

- `joPAsetup(((3,),(10,10,10,10),(5,));DT=Int8)`: distribute Int8 array (3,40,5) over 2nd dimension

"""
function joPAsetup(wpool::WorkerPool,parts::Tuple{Vararg{Tuple{Vararg{INT}}}};
        DT::DataType=joFloat,
        name::String="joPAsetup") where INT<:Integer
    dims=convert(Dims,(sum.([parts...],)...,))
    prod(dims)>0 || throw(joPAsetupException("joPAsetup: 0 dimension in $(dims)"))
    chunks=[length.([parts...])...]
    procs = sort(workers(wpool))
    prod(chunks)==length(procs)  || throw(joPAsetupException("joPAsetup: mismatch between # of partitions $(prod(chunks)) and workers $(length(procs))"))
    idxs,cuts = joPAsetup_etc.idxs_cuts(dims,parts)
    return joPAsetup(name,dims,procs,chunks,idxs,cuts,DT)
end
joPAsetup(parts::Tuple{Vararg{Tuple{Vararg{INT}}}};kwargs...) where INT<:Integer =
    joPAsetup(WorkerPool(workers()),parts;kwargs...)


############################################################
## joPAsetup - overloaded Base functions

# show(jo)
show(A::joPAsetup) = println((typeof(A),A.name,A.DT,A.dims))

# display(jo)
function display(d::joPAsetup)
    println("joPAsetup: ",d.name)
    println(" DataType: ",d.DT)
    println(" Dims    : ",d.dims)
    println(" Chunks  : ",d.chunks)
    println(" Workers : ",d.procs)
    for i=1:length(d.procs)
        @printf "  Worker/ranges: %3d " d.procs[i]
        println(d.idxs[i])
    end
end

# transpose(jo)
function transpose(in::joPAsetup)
    dims=reverse(in.dims)
    length(dims)==2 || throw(joPAsetupException("joPAsetup: transpose(joPAsetup) makes sense only for 2D distributed arrays"))
    nlabs=length(in.procs)
    ddim=findfirst(i->i>1,in.chunks)
    ldim=findlast(i->i>1,in.chunks)
    ddim==ldim || throw(joPAsetupException("joPAsetup: cannot transpose and array with more then one distributed dimension"))
    parts=joPAsetup_etc.balanced_partition(nlabs,dims[ddim])
    return joPAsetup(dims,ddim,DT=in.DT,parts=parts,name="transpose($(in.name))")
end

# isequal(jo,jo)
function isequal(a::joPAsetup,b::joPAsetup)
    (a.name  == b.name  ) || return false
    (a.dims  == b.dims  ) || return false
    (a.procs == b.procs ) || return false
    (a.chunks== b.chunks) || return false
    (a.idxs  == b.idxs  ) || return false
    (a.cuts  == b.cuts  ) || return false
    (a.DT    == b.DT    ) || return false
    return true
end

# isapprox(jo,jo)
function isapprox(a::joPAsetup,b::joPAsetup)
    (a.dims  == b.dims  ) || return false
    (a.procs == b.procs ) || return false
    (a.chunks== b.chunks) || return false
    (a.idxs  == b.idxs  ) || return false
    (a.cuts  == b.cuts  ) || return false
    return true
end

############################################################
## joPAsetup - extra functions

# isequiv
function isequiv(d::joPAsetup,a::SharedArray)
    (d.procs == vec(a.pids)) || return false
    (d.dims  == size(a)  ) || return false
    return true
end
function isequiv(d::joPAsetup,a::DArray)
    (d.procs == vec(a.pids)) || return false
    (d.idxs  == a.indices  ) || return false
    return true
end

