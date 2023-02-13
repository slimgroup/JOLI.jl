############################################################
## joAbstractSAparallelLinearOperator - outer constructors
############################################################

#export

# outer constructors
export joSAdistributedLinOp
"""
    julia> joSAdistributedLinOp(A,psin; [,fclean] [,rclean])

Create a linear operator working on 2D SharedArray in multi-vector (over 2nd dimension) mode.

# Signature

    function joSAdistributedLinOp(A::joAbstractLinearOperator{DDT,RDT},psin::joPAsetup,
        fclean::Bool=false,rclean::Bool=false) where {DDT<:Number,RDT<:Number,INT<:Integer}

# Arguments

- `A`: joAbstractLinearOperator type
- `psin`: parallel setup from jpPAsetup
- `fclean`: close SharedArray after forward operation
- `rclean`: close SharedArray after forward operation in transpose/adjoint mode

# Examples

- `ps=joPAsetup((12,30))`: define parallel setup for operator with 12 columns and multi-vector with 30 columns
- `joSAdistributedLinOp(A,ps)`: operator that will apply A to distributed multi-vector with 30 columns

# Notes

- nvc of joPAsetup must be >= then # of workers in the WorkerPool
- DT in joPAsetup will be overwritten by DDT of the operator

"""
function joSAdistributedLinOp(A::joAbstractLinearOperator{DDT,RDT},psin::joPAsetup,
        fclean::Bool=false,rclean::Bool=false) where {DDT<:Number,RDT<:Number}

    psin.chunks[1]==1 || throw(joSAdistributedLinearOperatorException("joSAdistributedLinearOperator: invalid joPAsetup - must not be distributed in 1st dimension"))
    A.n==psin.dims[1]  || throw(joSAdistributedLinearOperatorException("joSAdistributedLinearOperator: invalid joPAsetup - 1st dimension off joPAsetup does not match size(A,2)"))

    wpool=WorkerPool(psin.procs)
    nvc=psin.dims[2]
    parts=joPAsetup_etc.parts(psin,2)
    idst=joPAsetup(wpool,(A.n,nvc),2,parts=parts,DT=DDT)
    odst=joPAsetup(wpool,(A.m,nvc),2,parts=parts,DT=RDT)
    return joSAdistributedLinearOperator{DDT,RDT,2}("joSAdistributedLinearOperator($(A.name))",A.m,A.n,nvc,
               v1->A*v1,
               v2->transpose(A)*v2,
               v3->adjoint(A)*v3,
               v4->conj(A)*v4,
               @joNF, @joNF, @joNF, @joNF,
               idst,odst,fclean,rclean)
end
"""
    julia> joSAdistributedLinOp(A,nvc; [parts] [,fclean] [,rclean])

Create a linear operator working on 2D SharedArray in multi-vector (over 2nd dimension) mode.

# Signature

    function joSAdistributedLinOp(wpool::WorkerPool,A::joAbstractLinearOperator{DDT,RDT},nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),nvc);
        fclean::Bool=false,rclean::Bool=false) where {DDT<:Number,RDT<:Number,INT<:Integer}
    joSAdistributedLinOp(A::joAbstractLinearOperator{ADDT,ARDT},nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),nvc);
        fclean::Bool=false,rclean::Bool=false) where {ADDT<:Number,ARDT<:Number,INT<:Integer}

# Arguments

- `A`: joAbstractLinearOperator type
- `nvc`: number of columns in multi-vector
- `parts`: custom partitioning of 2nd diemnsion 
- `fclean`: close SharedArray after forward operation
- `rclean`: close SharedArray after forward operation in transpose/adjoint mode

# Examples

- `joSAdistributedLinOp(A,30)`: operator that will apply A to distributed multivector with 30 columns

# Notes

- nvc must be >= then # of workers in the WorkerPool

"""
function joSAdistributedLinOp(wpool::WorkerPool,A::joAbstractLinearOperator{DDT,RDT},nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(wpool),nvc);
        fclean::Bool=false,rclean::Bool=false) where {DDT<:Number,RDT<:Number,INT<:Integer}

    length(parts)==nworkers(wpool) || throw(joSAdistributedLinearOperatorException("joSAdistributedLinearOperator: lenght(parts) does not much nworkers()"))
    sum(parts)==nvc || throw(joSAdistributedLinearOperatorException("joSAdistributedLinearOperator: sum(parts) does not much nvc"))

    idst=joPAsetup(wpool,(A.n,nvc),2,parts=parts,DT=DDT)
    odst=joPAsetup(wpool,(A.m,nvc),2,parts=parts,DT=RDT)
    return joSAdistributedLinearOperator{DDT,RDT,2}("joSAdistributedLinearOperator($(A.name))",A.m,A.n,nvc,
               v1->A*v1,
               v2->transpose(A)*v2,
               v3->adjoint(A)*v3,
               v4->conj(A)*v4,
               @joNF, @joNF, @joNF, @joNF,
               idst,odst,fclean,rclean)
end
joSAdistributedLinOp(A::joAbstractLinearOperator{ADDT,ARDT},nvc::Integer,
        parts::Vector{INT}=joPAsetup_etc.balanced_partition(nworkers(),nvc);
        fclean::Bool=false,rclean::Bool=false) where {ADDT<:Number,ARDT<:Number,INT<:Integer} =
        joSAdistributedLinOp(WorkerPool(workers()),A,nvc,fclean=fclean,rclean=rclean)

############################################################
## joAddSolver{Any,All}

# exported in joAbstractOperator/constructors.jl

# joAddSolver - outer constructor for adding solver to operator
#joAddSolverAny(A::joSAdistributedLinOp{DDT,RDT},slvr::Function) where {DDT,RDT} =
#end
#joAddSolverAll(A::joSAdistributedLinOp{DDT,RDT},
#    slvr::Function,slvr_T::Function,slvr_A::Function,slvr_C::Function) where {DDT,RDT} =
#end

