############################################################
## joAbstractLinearOperator - outer constructors

export joAddSolverAny, joAddSolverAll

# joAddSolver - outer constructor for adding solver to operator
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
"""
joAddSolver outer constructor

    joAddSolverAll(A::joAbstractLinearOperator{DDT,RDT},
        solver::Function,solver_T::Function,solver_CT::Function,solver_C::Function)

Create joLinearOperator with added specific solver(s) for \\(jo,[m]vec),
distinct for each form of the operator.

# Examples

    O=joAddSolverAll(O,
        (s,x)->my_solver(s,x),
        (s,x)->my_solver_T(s,x),
        (s,x)->my_solver_CT(s,x),
        (s,x)->my_solver_C(s,x))

    O=joAddSolverAll(O,
        (s,x)->my_solver(s,x),
        @joNF,
        (s,x)->my_solver_CT(s,x),
        @joNF)

    O=joAddSolverAll(O,
        (s,x)->my_solver(s,x),
        @joNF,
        @joNF,
        @joNF)

"""
joAddSolverAll(A::joAbstractLinearOperator{DDT,RDT},
    slvr::Function,slvr_T::Function,slvr_CT::Function,slvr_C::Function) where {DDT,RDT} =
        joLinearOperator{DDT,RDT}("("*A.name*"+solver)",A.m,A.n,
            v1->A*v1,
            v2->transpose(A)*v2,
            v3->adjoint(A)*v3,
            v4->conj(A)*v4,
            v5->slvr(A,v5),
            v6->slvr_T(transpose(A),v6),
            v7->slvr_CT(adjoint(A),v7),
            v8->slvr_C(conj(A),v8)
            )

