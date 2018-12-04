############################################################
# joPAsetup/distribute/gather constructors ###########
############################################################

############################################################
# joPAsetup constructors #############################

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
# joDAdistribute/gather constructors #######################
############################################################

export joDAdistribute
"""
    julia> joDAdistribute(m [,parts]; [DT])
    julia> joDAdistribute(wpool, m [,parts]; [DT])
    julia> joDAdistribute(m, nvc [,parts]; [DT])
    julia> joDAdistribute(wpool, m, nvc [,parts]; [DT])

defines operator to distribute serial vector into DistributedArrays' vector

# Signature

    joDAdistribute(m::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer
    joDAdistribute(wpool::WorkerPool,m::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(wpool),m);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer
    joDAdistribute(m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer
    joDAdistribute(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(wpool),nvc);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer

# Arguments

- `m`: length of the vector
- `nvc`: # of columns in multi-vector - if given then multi-vector is distributed over 2nd dimension
- `parts`: custom partitioning of distributed dimension
- `wpool`: custom WorkerPool
- `DT`: DataType for joPAsetup
- `glcean`: clean DArray after gathering

# Notes

- no type conversions are attempted at the moment (i.e. DT is used as for any other JOLI operator)
- adjoint/transpose of the joDAdistribute will gather distributed vector into serial vector

# Examples

- `joDAdistribute(5)`: distribute vector of lenght 5 into default WorkerPool
- `joDAdistribute(5,2)`: distribute multi-vector of lenght 5 with 2 columns into default WorkerPool
- `joDAdistribute(5)'`: gather vector of lenght 5
- `joDAdistribute(5,2)'`: gather multi-vector of lenght 5 with 2 columns

"""
function joDAdistribute(wpool::WorkerPool,m::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(wpool),m);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer

    length(parts)==nworkers(wpool) || throw(joPAsetupException("joDAdistribute: lenght(parts) does not much nworkers()"))
    sum(parts)==m || throw(joPAsetupException("joDAdistribute: sum(parts) does not much m"))
    dst=joPAsetup(wpool,(m,),1,parts=parts)
    return joDAdistribute{DT,DT,1}("joDAdistributeV",m,m,1,
        v1->distribute(v1,dst),
        v2->Array(v2),
        v3->Array(v3),
        v4->distribute(v4,dst),
        @joNF, @joNF, @joNF, @joNF,
        dst,gclean)
end
joDAdistribute(m::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer = joDAdistribute(WorkerPool(workers()),m,parts;kwargs...)

function joDAdistribute(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(wpool),nvc);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer

    length(parts)==nworkers(wpool) || throw(joPAsetupException("joDAdistribute: lenght(parts) does not much nworkers()"))
    sum(parts)==nvc || throw(joPAsetupException("joDAdistribute: sum(parts) does not much nvc"))
    dst=joPAsetup(wpool,(m,nvc),2,parts=parts)
    return joDAdistribute{DT,DT,2}("joDAdistributeMV:$nvc",m,m,nvc,
        v1->distribute(v1,dst),
        v2->Array(v2),
        v3->Array(v3),
        v4->distribute(v4,dst),
        @joNF, @joNF, @joNF, @joNF,
        dst,gclean)
end
joDAdistribute(m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer = joDAdistribute(WorkerPool(workers()),m,nvc,parts;kwargs...)

export joDAgather
"""
    julia> joDAgather(m [,parts]; [DT])
    julia> joDAgather(wpool, m [,parts]; [DT])
    julia> joDAgather(m, nvc [,parts]; [DT])
    julia> joDAgather(wpool, m, nvc [,parts]; [DT])

defines operator to gather DistributedArrays' vector into serial vector

# Signature

    joDAgather(m::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer
    joDAgather(wpool::WorkerPool,m::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(wpool),m);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer
    joDAgather(m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer
    joDAgather(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(wpool),nvc);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer

# Arguments

- `m`: length of the vector
- `nvc`: # of columns in multi-vector - if given then multi-vector is distributed over 2nd dimension
- `parts`: custom partitioning of distributed dimension
- `wpool`: custom WorkerPool
- `DT`: DataType for joPAsetup
- `glcean`: clean DArray after gathering

# Notes

- no type conversions are attempted at the moment (i.e. DT is used as for any other JOLI operator)
- adjoint/transpose of the joDAgather will distribute serial vector into DistributedArrays' vector

# Examples

- `joDAgather(5)`: gather vector of lenght 5
- `joDAgather(5,2)`: gather multi-vector of lenght 5 with 2 columns
- `joDAgather(5)'`: distribute vector of lenght 5 into default WorkerPool
- `joDAgather(5,2)'`: distribute multi-vector of lenght 5 with 2 columns into default WorkerPool

"""
function joDAgather(wpool::WorkerPool,m::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(wpool),m);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer

    length(parts)==nworkers(wpool) || throw(joPAsetupException("joDAgather: lenght(parts) does not much nworkers()"))
    sum(parts)==m || throw(joPAsetupException("joDAgather: sum(parts) does not much m"))
    dst=joPAsetup(wpool,(m,),1,parts=parts)
    return joDAgather{DT,DT,1}("joDAgatherV",m,m,1,
        v1->Array(v1),
        v2->distribute(v2,dst),
        v3->distribute(v3,dst),
        v4->Array(v4),
        @joNF, @joNF, @joNF, @joNF,
        dst,gclean)
end
joDAgather(m::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer = joDAgather(WorkerPool(workers()),m,parts;kwargs...)

function joDAgather(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(wpool),nvc);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer

    length(parts)==nworkers(wpool) || throw(joPAsetupException("joDAgather: lenght(parts) does not much nworkers()"))
    sum(parts)==nvc || throw(joPAsetupException("joDAgather: sum(parts) does not much nvc"))
    dst=joPAsetup(wpool,(m,nvc),2,parts=parts)
    return joDAgather{DT,DT,2}("joDAgatherMV:$nvc",m,m,nvc,
        v1->Array(v1),
        v2->distribute(v2,dst),
        v3->distribute(v3,dst),
        v4->Array(v4),
        @joNF, @joNF, @joNF, @joNF,
        dst,gclean)
end
joDAgather(m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joPAsetup_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer = joDAgather(WorkerPool(workers()),m,nvc,parts;kwargs...)

