############################################################
## joAbstractLinearOperator - outer constructors
############################################################

############################################################
## joMatrix

"""
joMatrix outer constructor

    joMatrix(array::Union{AbstractMatrix,AbstractQ};
             DDT::DataType=eltype(array),
             RDT::DataType=promote_type(eltype(array),DDT),
             name::String="joMatrix")

Look up argument names in help to joMatrix type.

# Example
- joMatrix(rand(4,3)) # implicit domain and range
- joMatrix(rand(4,3);DDT=Float32) # implicit range
- joMatrix(rand(4,3);DDT=Float32,RDT=Float64)
- joMatrix(rand(4,3);name="my matrix") # adding name

# Notes
- if DDT:<Real for complex matrix then imaginary part will be neglected for transpose/adjoint operator
- if RDT:<Real for complex matrix then imaginary part will be neglected for forward/conjugate operator

"""
function joMatrix(array::Union{AbstractMatrix{EDT},AbstractQ{EDT}};
    DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),name::String="joMatrix") where {EDT}

        (typeof(array)<:DArray || typeof(array)<:SharedArray) && @warn "Creating joMatrix from non-local array like $(typeof(array)) is likely going to have adverse impact on JOLI's health. Please, avoid it."

        return joMatrix{DDT,RDT}(name,size(array,1),size(array,2),
            v1->jo_convert(RDT,array*v1,false),
            v2->jo_convert(DDT,transpose(array)*v2,false),
            v3->jo_convert(DDT,adjoint(array)*v3,false),
            v4->jo_convert(RDT,conj(array)*v4,false),
            v5->jo_convert(DDT,array\v5,false),
            v6->jo_convert(RDT,transpose(array)\v6,false),
            v7->jo_convert(RDT,adjoint(array)\v7,false),
            v8->jo_convert(DDT,conj(array)\v8,false)
            )
end

############################################################
## joLinearFunction

export joLinearFunctionAll, joLinearFunction_T, joLinearFunction_A,
       joLinearFunctionFwd, joLinearFunctionFwd_T, joLinearFunctionFwd_A

# outer constructors

"""
joLinearFunction outer constructor

    joLinearFunctionAll(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
        iop::Function,iop_T::Function,iop_A::Function,iop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,iMVok::Bool=false,
        name::String="joLinearFunctionAll")

Look up argument names in help to joLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLinearFunctionAll(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
    iop::Function,iop_T::Function,iop_A::Function,iop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLinearFunctionAll") =
        joLinearFunction{DDT,RDT}(name,m,n,
            fop,fop_T,fop_A,fop_C,fMVok,
            iop,iop_T,iop_A,iop_C,iMVok
            )
"""
joLinearFunction outer constructor

    joLinearFunction_T(m::Integer,n::Integer,
        fop::Function,fop_T::Function, iop::Function,iop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,iMVok::Bool=false,
        name::String="joLinearFunction_T")

Look up argument names in help to joLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLinearFunction_T(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLinearFunction_T") =
        joLinearFunction{DDT,RDT}(name,m,n,
            fop,
            fop_T,
            v3->conj(fop_T(conj(v3))),
            v4->conj(fop(conj(v4))),
            fMVok,
            iop,
            iop_T,
            v7->conj(iop_T(conj(v7))),
            v8->conj(iop(conj(v8))),
            iMVok
            )
"""
joLinearFunction outer constructor

    joLinearFunction_A(m::Integer,n::Integer,
        fop::Function,fop_A::Function, iop::Function,iop_A::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,iMVok::Bool=false,
        name::String="joLinearFunction_A")

Look up argument names in help to joLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLinearFunction_A(m::Integer,n::Integer,
    fop::Function,fop_A::Function, iop::Function,iop_A::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLinearFunction_A") =
        joLinearFunction{DDT,RDT}(name,m,n,
            fop,
            v2->conj(fop_A(conj(v2))),
            fop_A,
            v4->conj(fop(conj(v4))),
            fMVok,
            iop,
            v6->conj(iop_A(conj(v6))),
            iop_A,
            v8->conj(iop(conj(v8))),
            iMVok
            )
"""
joLinearFunction outer constructor

    joLinearFunctionFwd(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,
        name::String="joLinearFunctionFwd")

Look up argument names in help to joLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLinearFunctionFwd(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLinearFunctionFwd") =
        joLinearFunction{DDT,RDT}(name,m,n,
            fop,fop_T,fop_A,fop_C,fMVok,
            @joNF, @joNF, @joNF, @joNF, false
            )
"""
joLinearFunction outer constructor

    joLinearFunctionFwd_T(m::Integer,n::Integer,
        fop::Function,fop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,
        name::String="joLinearFunctionFwd_T")

Look up argument names in help to joLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLinearFunctionFwd_T(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLinearFunctionFwd_T") =
        joLinearFunction{DDT,RDT}(name,m,n,
            fop,
            fop_T,
            v3->conj(fop_T(conj(v3))),
            v4->conj(fop(conj(v4))),
            fMVok,
            @joNF, @joNF, @joNF, @joNF, false
            )
"""
joLinearFunction outer constructor

    joLinearFunctionFwd_A(m::Integer,n::Integer,
        fop::Function,fop_A::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,
        name::String="joLinearFunctionFwd_A")

Look up argument names in help to joLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLinearFunctionFwd_A(m::Integer,n::Integer,
    fop::Function,fop_A::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLinearFunctionFwd_A") =
        joLinearFunction{DDT,RDT}(name,m,n,
            fop,
            v2->conj(fop_A(conj(v2))),
            fop_A,
            v4->conj(fop(conj(v4))),
            fMVok,
            @joNF, @joNF, @joNF, @joNF, false
            )

############################################################
## joAddSolver{Any,All}

# exported in joAbstractOperator/constructors.jl

# joAddSolver - outer constructor for adding solver to operator
export joAddSolverAny
"""
joAddSolver outer constructor

    joAddSolverAny(A::joAbstractLinearOperator{DDT,RDT},solver::Function)

Create joLinearOperator with added solver for \\(jo,[m]vec),
same for each form of the operator

# Example (for all forms of O)
    
    O=joAddSolverAny(O,(s,x)->my_solver(s,x))

"""
joAddSolverAny(A::joAbstractLinearOperator{DDT,RDT},slvr::Function) where {DDT,RDT} =
        joLinearOperator{DDT,RDT}("("*A.name*"+solver)",A.m,A.n,
            v1->A*v1,
            v2->transpose(A)*v2,
            v3->adjoint(A)*v3,
            v4->conj(A)*v4,
            v5->slvr(A,v5),
            v6->slvr(transpose(A),v6),
            v7->slvr(adjoint(A),v7),
            v8->slvr(conj(A),v8)
            )
export joAddSolverAll
"""
joAddSolver outer constructor

    joAddSolverAll(A::joAbstractLinearOperator{DDT,RDT},
        solver::Function,solver_T::Function,solver_A::Function,solver_C::Function)

Create joLinearOperator with added specific solver(s) for \\(jo,[m]vec),
distinct for each form of the operator.

# Examples

    O=joAddSolverAll(O,
        (s,x)->my_solver(s,x),
        (s,x)->my_solver_T(s,x),
        (s,x)->my_solver_A(s,x),
        (s,x)->my_solver_C(s,x))

    O=joAddSolverAll(O,
        (s,x)->my_solver(s,x),
        @joNF,
        (s,x)->my_solver_A(s,x),
        @joNF)

    O=joAddSolverAll(O,
        (s,x)->my_solver(s,x),
        @joNF,
        @joNF,
        @joNF)

"""
joAddSolverAll(A::joAbstractLinearOperator{DDT,RDT},
    slvr::Function,slvr_T::Function,slvr_A::Function,slvr_C::Function) where {DDT,RDT} =
        joLinearOperator{DDT,RDT}("("*A.name*"+solver)",A.m,A.n,
            v1->A*v1,
            v2->transpose(A)*v2,
            v3->adjoint(A)*v3,
            v4->conj(A)*v4,
            v5->slvr(A,v5),
            v6->slvr_T(transpose(A),v6),
            v7->slvr_A(adjoint(A),v7),
            v8->slvr_C(conj(A),v8)
            )

