############################################################
# joDA-distribute/gather constructors            ###########
############################################################

############################################################
# joDAdistribute/gather constructors #######################

export joDAdistribute
"""
    julia> joDAdistribute(m [,parts]; [DT])
    julia> joDAdistribute(wpool, m [,parts]; [DT])
    julia> joDAdistribute(m, nvc [,parts]; [DT])
    julia> joDAdistribute(wpool, m, nvc [,parts]; [DT])
    julia> joDAdistribute(dst)
    julia> joDAdistribute(DA)

defines operator to distribute serial vector into DistributedArrays' vector

# Signature

    joDAdistribute(m::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer
    joDAdistribute(wpool::WorkerPool,m::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),m);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer
    joDAdistribute(m::Integer,nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer
    joDAdistribute(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),nvc);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer
    joDAdistribute(dst::joPAsetup;gclean::Bool=false)
    joDAdistribute(A::joDAdistributedLinearOperator;gclean::Bool=false)

# Arguments

- `m`: length of the vector
- `nvc`: # of columns in multi-vector - if given then multi-vector is distributed over 2nd dimension
- `parts`: custom partitioning of distributed dimension
- `wpool`: custom WorkerPool
- `DT`: DataType for joPAsetup
- `dst`: joPAsetup
- `DA`: joDAdistributedLinearOperator
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
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),m);
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
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer = joDAdistribute(WorkerPool(workers()),m,parts;kwargs...)

function joDAdistribute(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),nvc);
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
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer = joDAdistribute(WorkerPool(workers()),m,nvc,parts;kwargs...)
function joDAdistribute(dst::joPAsetup;gclean::Bool=false)
    m=dst.dims[1]
    nvc=dst.dims[2]
    DT=dst.DT
    return joDAdistribute{DT,DT,2}("joDAdistributeMV:$nvc",m,m,nvc,
        v1->distribute(v1,dst),
        v2->Array(v2),
        v3->Array(v3),
        v4->distribute(v4,dst),
        @joNF, @joNF, @joNF, @joNF,
        dst,gclean)
end
joDAdistribute(A::joDAdistributedLinearOperator;gclean::Bool=false) = joDAdistribute(A.PAs_in,gclean=gclean)

export joDAgather
"""
    julia> joDAgather(m [,parts]; [DT])
    julia> joDAgather(wpool, m [,parts]; [DT])
    julia> joDAgather(m, nvc [,parts]; [DT])
    julia> joDAgather(wpool, m, nvc [,parts]; [DT])
    julia> joDAgather(dst)
    julia> joDAgather(DA)

defines operator to gather DistributedArrays' vector into serial vector

# Signature

    joDAgather(m::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer
    joDAgather(wpool::WorkerPool,m::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),m);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer
    joDAgather(m::Integer,nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer
    joDAgather(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),nvc);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer
    joDAgather(dst::joPAsetup;gclean::Bool=false)
    joDAgather(A::joDAdistributedLinearOperator;gclean::Bool=false)

# Arguments

- `m`: length of the vector
- `nvc`: # of columns in multi-vector - if given then multi-vector is distributed over 2nd dimension
- `parts`: custom partitioning of distributed dimension
- `wpool`: custom WorkerPool
- `DT`: DataType for joPAsetup
- `dst`: joPAsetup
- `DA`: joDAdistributedLinearOperator
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
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),m);
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
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer = joDAgather(WorkerPool(workers()),m,parts;kwargs...)

function joDAgather(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),nvc);
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
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer = joDAgather(WorkerPool(workers()),m,nvc,parts;kwargs...)
function joDAgather(dst::joPAsetup;gclean::Bool=false)
    m=dst.dims[1]
    nvc=dst.dims[2]
    DT=dst.DT
    return joDAgather{DT,DT,2}("joDAgatherMV:$nvc",m,m,nvc,
        v1->Array(v1),
        v2->distribute(v2,dst),
        v3->distribute(v3,dst),
        v4->Array(v4),
        @joNF, @joNF, @joNF, @joNF,
        dst,gclean)
end
joDAgather(A::joDAdistributedLinearOperator;gclean::Bool=false) = joDAgather(A.PAs_out,gclean=gclean)

