############################################################
# joSA-distribute/gather constructors            ###########
############################################################

############################################################
# joSAdistribute/gather constructors #######################

export joSAdistribute
"""
    julia> joSAdistribute(m [,parts]; [DT])
    julia> joSAdistribute(wpool, m [,parts]; [DT])
    julia> joSAdistribute(m, nvc [,parts]; [DT])
    julia> joSAdistribute(wpool, m, nvc [,parts]; [DT])
    julia> joSAdistribute(dst)
    julia> joSAdistribute(SA)

defines operator to distribute serial vector into DistributedArrays' vector

# Signature

    joSAdistribute(m::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer
    joSAdistribute(wpool::WorkerPool,m::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),m);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer
    joSAdistribute(m::Integer,nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer
    joSAdistribute(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),nvc);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer
    joSAdistribute(dst::joPAsetup;gclean::Bool=false)
    joSAdistribute(A::joSMVdistributedLinearOperator;gclean::Bool=false)

# Arguments

- `m`: length of the vector
- `nvc`: # of columns in multi-vector - if given then multi-vector is distributed over 2nd dimension
- `parts`: custom partitioning of distributed dimension
- `wpool`: custom WorkerPool
- `DT`: DataType for joPAsetup
- `dst`: joPAsetup
- `SA`: joSMVdistributedLinearOperator
- `glcean`: clean SArray after gathering

# Notes

- no type conversions are attempted at the moment (i.e. DT is used as for any other JOLI operator)
- adjoint/transpose of the joSAdistribute will gather distributed vector into serial vector

# Examples

- `joSAdistribute(5)`: distribute vector of lenght 5 into default WorkerPool
- `joSAdistribute(5,2)`: distribute multi-vector of lenght 5 with 2 columns into default WorkerPool
- `joSAdistribute(5)'`: gather vector of lenght 5
- `joSAdistribute(5,2)'`: gather multi-vector of lenght 5 with 2 columns

"""
function joSAdistribute(wpool::WorkerPool,m::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),m);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer

    length(parts)==nworkers(wpool) || throw(joPAsetupException("joSAdistribute: lenght(parts) does not much nworkers()"))
    sum(parts)==m || throw(joPAsetupException("joSAdistribute: sum(parts) does not much m"))
    dst=joPAsetup(wpool,(m,),1,parts=parts)
    return joSAdistribute{DT,DT,1}("joSAdistributeV",m,m,1,
        v1->scatter(v1,dst),
        v2->sdata(v2),
        v3->sdata(v3),
        v4->scatter(v4,dst),
        @joNF, @joNF, @joNF, @joNF,
        dst,gclean)
end
joSAdistribute(m::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer = joSAdistribute(WorkerPool(workers()),m,parts;kwargs...)

function joSAdistribute(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),nvc);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer

    length(parts)==nworkers(wpool) || throw(joPAsetupException("joSAdistribute: lenght(parts) does not much nworkers()"))
    sum(parts)==nvc || throw(joPAsetupException("joSAdistribute: sum(parts) does not much nvc"))
    dst=joPAsetup(wpool,(m,nvc),2,parts=parts)
    return joSAdistribute{DT,DT,2}("joSAdistributeMV:$nvc",m,m,nvc,
        v1->scatter(v1,dst),
        v2->sdata(v2),
        v3->sdata(v3),
        v4->scatter(v4,dst),
        @joNF, @joNF, @joNF, @joNF,
        dst,gclean)
end
joSAdistribute(m::Integer,nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer = joSAdistribute(WorkerPool(workers()),m,nvc,parts;kwargs...)
function joSAdistribute(dst::joPAsetup;gclean::Bool=false)
    m=dst.dims[1]
    nvc=dst.dims[2]
    DT=dst.DT
    return joSAdistribute{DT,DT,2}("joSAdistributeMV:$nvc",m,m,nvc,
        v1->scatter(v1,dst),
        v2->sdata(v2),
        v3->sdata(v3),
        v4->scatter(v4,dst),
        @joNF, @joNF, @joNF, @joNF,
        dst,gclean)
end
joSAdistribute(A::joSMVdistributedLinearOperator;gclean::Bool=false) = joSAdistribute(A.PAs_in,gclean=gclean)

export joSAgather
"""
    julia> joSAgather(m [,parts]; [DT])
    julia> joSAgather(wpool, m [,parts]; [DT])
    julia> joSAgather(m, nvc [,parts]; [DT])
    julia> joSAgather(wpool, m, nvc [,parts]; [DT])
    julia> joSAgather(dst)
    julia> joSAgather(SA)

defines operator to gather DistributedArrays' vector into serial vector

# Signature

    joSAgather(m::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer
    joSAgather(wpool::WorkerPool,m::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),m);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer
    joSAgather(m::Integer,nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer
    joSAgather(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),nvc);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer
    joSAgather(dst::joPAsetup;gclean::Bool=false)
    joSAgather(A::joSMVdistributedLinearOperator;gclean::Bool=false)

# Arguments

- `m`: length of the vector
- `nvc`: # of columns in multi-vector - if given then multi-vector is distributed over 2nd dimension
- `parts`: custom partitioning of distributed dimension
- `wpool`: custom WorkerPool
- `DT`: DataType for joPAsetup
- `glcean`: clean SArray after gathering
- `dst`: joPAsetup
- `SA`: joSMVdistributedLinearOperator

# Notes

- no type conversions are attempted at the moment (i.e. DT is used as for any other JOLI operator)
- adjoint/transpose of the joSAgather will distribute serial vector into DistributedArrays' vector

# Examples

- `joSAgather(5)`: gather vector of lenght 5
- `joSAgather(5,2)`: gather multi-vector of lenght 5 with 2 columns
- `joSAgather(5)'`: distribute vector of lenght 5 into default WorkerPool
- `joSAgather(5,2)'`: distribute multi-vector of lenght 5 with 2 columns into default WorkerPool

"""
function joSAgather(wpool::WorkerPool,m::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),m);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer

    length(parts)==nworkers(wpool) || throw(joPAsetupException("joSAgather: lenght(parts) does not much nworkers()"))
    sum(parts)==m || throw(joPAsetupException("joSAgather: sum(parts) does not much m"))
    dst=joPAsetup(wpool,(m,),1,parts=parts)
    return joSAgather{DT,DT,1}("joSAgatherV",m,m,1,
        v1->sdata(v1),
        v2->scatter(v2,dst),
        v3->scatter(v3,dst),
        v4->sdata(v4),
        @joNF, @joNF, @joNF, @joNF,
        dst,gclean)
end
joSAgather(m::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),m);
        kwargs...) where INT<:Integer = joSAgather(WorkerPool(workers()),m,parts;kwargs...)

function joSAgather(wpool::WorkerPool,m::Integer,nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),nvc);
        DT::DataType=joFloat,gclean::Bool=false) where INT<:Integer

    length(parts)==nworkers(wpool) || throw(joPAsetupException("joSAgather: lenght(parts) does not much nworkers()"))
    sum(parts)==nvc || throw(joPAsetupException("joSAgather: sum(parts) does not much nvc"))
    dst=joPAsetup(wpool,(m,nvc),2,parts=parts)
    return joSAgather{DT,DT,2}("joSAgatherMV:$nvc",m,m,nvc,
        v1->sdata(v1),
        v2->scatter(v2,dst),
        v3->scatter(v3,dst),
        v4->sdata(v4),
        @joNF, @joNF, @joNF, @joNF,
        dst,gclean)
end
joSAgather(m::Integer,nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),nvc);
        kwargs...) where INT<:Integer = joSAgather(WorkerPool(workers()),m,nvc,parts;kwargs...)
function joSAgather(dst::joPAsetup;gclean::Bool=false)
    m=dst.dims[1]
    nvc=dst.dims[2]
    DT=dst.DT
    return joSAgather{DT,DT,2}("joSAgatherMV:$nvc",m,m,nvc,
        v1->sdata(v1),
        v2->scatter(v2,dst),
        v3->scatter(v3,dst),
        v4->sdata(v4),
        @joNF, @joNF, @joNF, @joNF,
        dst,gclean)
end
joSAgather(A::joSMVdistributedLinearOperator;gclean::Bool=false) = joSAgather(A.PAs_out,gclean=gclean)

