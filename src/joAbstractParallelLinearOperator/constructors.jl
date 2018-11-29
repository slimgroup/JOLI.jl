############################################################
## joAbstractParallelLinearOperator - outer constructors
############################################################

#export

# outer constructors
"""
    julia> joDALinearOperator(A,nvc; [parts] [,fclean] [,rclean])

Create a linear operator working on 2D DAaray in multi-vector (over 2nd dimension) mode.

# Signature

    function joDALinearOperator(wpool::WorkerPool,A::joAbstractLinearOperator{DDT,RDT},nvc::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(wpool),nvc);
        fclean::Bool=false,rclean::Bool=false) where {DDT<:Number,RDT<:Number,INT<:Integer}
    joDALinearOperator(A::joAbstractLinearOperator{ADDT,ARDT},nvc::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(),nvc);
        fclean::Bool=false,rclean::Bool=false) where {ADDT<:Number,ARDT<:Number,INT<:Integer}

# Arguments

- `A`: joAbstractLinearOperator type
- `nvc`: number of columns in multi-vector
- `parts`: custom partitioning of 2nd diemnsion 
- `fclean`: close DArray after forward operation
- `rclean`: close DArray after forward operation in transpose/adjoint mode

# Examples

- `joDALinearOperator(A,30)`: operator taht will apply A to distributed multivector with 30 columns

# Notes

- nvc must be >= then # of workers in the WorkerPool

"""
function joDALinearOperator(wpool::WorkerPool,A::joAbstractLinearOperator{DDT,RDT},nvc::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(wpool),nvc);
        fclean::Bool=false,rclean::Bool=false) where {DDT<:Number,RDT<:Number,INT<:Integer}

    length(parts)==nworkers(wpool) || throw(joDALinearOperatorException("joDALinearOperator: lenght(parts) does not much nworkers()"))
    sum(parts)==nvc || throw(joDALinearOperatorException("joDALinearOperator: sum(parts) does not much nvc"))

    idst=joDAdistributor(wpool,(A.n,nvc),2,parts=parts)
    odst=joDAdistributor(wpool,(A.m,nvc),2,parts=parts)
    return joDALinearOperator{DDT,RDT,2}("joDALinearOperator($(A.name))",A.m,A.n,nvc,
               v1->A*v1,
               v2->transpose(A)*v2,
               v3->adjoint(A)*v3,
               v4->conj(A)*v4,
               @joNF, @joNF, @joNF, @joNF,
               idst,odst,fclean,rclean)
end
joDALinearOperator(A::joAbstractLinearOperator{ADDT,ARDT},nvc::Integer,
        parts::Vector{INT}=JOLI.joDAdistributor_etc.balanced_partition(nworkers(),nvc);
        fclean::Bool=false,rclean::Bool=false) where {ADDT<:Number,ARDT<:Number,INT<:Integer} =
        joDALinearOperator(WorkerPool(workers()),A,nvc,fclean=fclean,rclean=rclean)

############################################################
## joAddSolver{Any,All}

# exported in joAbstractOperator/constructors.jl

# joAddSolver - outer constructor for adding solver to operator
#joAddSolverAny(A::joDALinearOperator{DDT,RDT},slvr::Function) where {DDT,RDT} =
#end
#joAddSolverAll(A::joDALinearOperator{DDT,RDT},
#    slvr::Function,slvr_T::Function,slvr_A::Function,slvr_C::Function) where {DDT,RDT} =
#end

