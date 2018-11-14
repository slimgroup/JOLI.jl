############################################################
# joDAdistribute/gather operators ##########################
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
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer
    joDAdistribute(wpool::WorkerPool,m::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(wpool),m);
        DT::DataType=joFloat) where INT<:Integer
    joDAdistribute(m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer
    joDAdistribute(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(wpool),nvc);
        DT::DataType=joFloat) where INT<:Integer

# Arguments

- `m`: length of the vector
- `nvc`: # of columns in multi-vector - if given then multi-vector is distributed over 2nd dimension
- `parts`: custom partitioning of distributed dimension
- `wpool`: custom WorkerPool
- `DT`: DataType for joDAdistributor

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
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(wpool),m);
        DT::DataType=joFloat) where INT<:Integer

    length(parts)==nworkers(wpool) || throw(joDAdistributorException("joDAdistribute: lenght(parts) does not much nworkers()"))
    sum(parts)==m || throw(joDAdistributorException("joDAdistribute: sum(parts) does not much m"))
    dst=joDAdistributor(wpool,(m,),1,parts=parts)
    return joLinearFunctionFwd(m,m,
        v1->distribute(v1,dst),
        v2->Array(v2),
        v3->Array(v3),
        v4->distribute(v4,dst),
        DT,DT,fMVok=true,name="joDAdistributeV")
end
joDAdistribute(m::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer = joDAdistribute(WorkerPool(workers()),m,parts;kwargs...)

function joDAdistribute(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(wpool),nvc);
        DT::DataType=joFloat) where INT<:Integer

    length(parts)==nworkers(wpool) || throw(joDAdistributorException("joDAdistribute: lenght(parts) does not much nworkers()"))
    sum(parts)==nvc || throw(joDAdistributorException("joDAdistribute: sum(parts) does not much nvc"))
    dst=joDAdistributor(wpool,(m,nvc),2,parts=parts)
    return joLinearFunctionFwd(m,m,
        v1->distribute(v1,dst),
        v2->Array(v2),
        v3->Array(v3),
        v4->distribute(v4,dst),
        DT,DT,fMVok=true,name="joDAdistributeMV:$nvc")
end
joDAdistribute(m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(),nvc);
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
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer
    joDAgather(wpool::WorkerPool,m::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(wpool),m);
        DT::DataType=joFloat) where INT<:Integer
    joDAgather(m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer
    joDAgather(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(wpool),nvc);
        DT::DataType=joFloat) where INT<:Integer

# Arguments

- `m`: length of the vector
- `nvc`: # of columns in multi-vector - if given then multi-vector is distributed over 2nd dimension
- `parts`: custom partitioning of distributed dimension
- `wpool`: custom WorkerPool
- `DT`: DataType for joDAdistributor

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
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(wpool),m);
        DT::DataType=joFloat) where INT<:Integer

    length(parts)==nworkers(wpool) || throw(joDAdistributorException("joDAgather: lenght(parts) does not much nworkers()"))
    sum(parts)==m || throw(joDAdistributorException("joDAgather: sum(parts) does not much m"))
    dst=joDAdistributor(wpool,(m,),1,parts=parts)
    return joLinearFunctionFwd(m,m,
        v1->Array(v1),
        v2->distribute(v2,dst),
        v3->distribute(v3,dst),
        v4->Array(v4),
        DT,DT,fMVok=true,name="joDAgatherV")
end
joDAgather(m::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer = joDAgather(WorkerPool(workers()),m,parts;kwargs...)

function joDAgather(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(wpool),nvc);
        DT::DataType=joFloat) where INT<:Integer

    length(parts)==nworkers(wpool) || throw(joDAdistributorException("joDAgather: lenght(parts) does not much nworkers()"))
    sum(parts)==nvc || throw(joDAdistributorException("joDAgather: sum(parts) does not much nvc"))
    dst=joDAdistributor(wpool,(m,nvc),2,parts=parts)
    return joLinearFunctionFwd(m,m,
        v1->Array(v1),
        v2->distribute(v2,dst),
        v3->distribute(v3,dst),
        v4->Array(v4),
        DT,DT,fMVok=true,name="joDAgatherMV:$nvc")
end
joDAgather(m::Integer,nvc::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer = joDAgather(WorkerPool(workers()),m,nvc,parts;kwargs...)

