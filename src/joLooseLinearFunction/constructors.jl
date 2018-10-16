############################################################
## joLooseLinearFunction - outer constructors

export joLooseLinearFunctionAll, joLooseLinearFunction_T, joLooseLinearFunction_A,
       joLooseLinearFunctionFwd, joLooseLinearFunctionFwd_T, joLooseLinearFunctionFwd_A


"""
joLooseLinearFunction outer constructor

    joLooseLinearFunctionAll(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
        iop::Function,iop_T::Function,iop_A::Function,iop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,iMVok::Bool=false,
        name::String="joLooseLinearFunctionAll")

Look up argument names in help to joLooseLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLooseLinearFunctionAll(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
    iop::Function,iop_T::Function,iop_A::Function,iop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLooseLinearFunctionAll") =
        joLooseLinearFunction{DDT,RDT}(name,m,n,
            fop,fop_T,fop_A,fop_C,fMVok,
            iop,iop_T,iop_A,iop_C,iMVok
            )
"""
joLooseLinearFunction outer constructor

    joLooseLinearFunction_T(m::Integer,n::Integer,
        fop::Function,fop_T::Function, iop::Function,iop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,iMVok::Bool=false,
        name::String="joLooseLinearFunction_T")

Look up argument names in help to joLooseLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLooseLinearFunction_T(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLooseLinearFunction_T") =
        joLooseLinearFunction{DDT,RDT}(name,m,n,
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
joLooseLinearFunction outer constructor

    joLooseLinearFunction_A(m::Integer,n::Integer,
        fop::Function,fop_A::Function, iop::Function,iop_A::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,iMVok::Bool=false,
        name::String="joLooseLinearFunction_A")

Look up argument names in help to joLooseLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLooseLinearFunction_A(m::Integer,n::Integer,
    fop::Function,fop_A::Function, iop::Function,iop_A::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLooseLinearFunction_A") =
        joLooseLinearFunction{DDT,RDT}(name,m,n,
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
joLooseLinearFunction outer constructor

    joLooseLinearFunctionFwd(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,
        name::String="joLooseLinearFunctionAll")

Look up argument names in help to joLooseLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLooseLinearFunctionFwd(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLooseLinearFunctionAll") =
        joLooseLinearFunction{DDT,RDT}(name,m,n,
            fop,fop_T,fop_A,fop_C,fMVok,
            @joNF, @joNF, @joNF, @joNF, false
            )
"""
joLooseLinearFunction outer constructor

    joLooseLinearFunctionFwd_T(m::Integer,n::Integer,
        fop::Function,fop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,
        name::String="joLooseLinearFunctionFwd_T")

Look up argument names in help to joLooseLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLooseLinearFunctionFwd_T(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLooseLinearFunctionFwd_T") =
        joLooseLinearFunction{DDT,RDT}(name,m,n,
            fop,
            fop_T,
            v3->conj(fop_T(conj(v3))),
            v4->conj(fop(conj(v4))),
            fMVok,
            @joNF, @joNF, @joNF, @joNF, false
            )
"""
joLooseLinearFunction outer constructor

    joLooseLinearFunctionFwd_A(m::Integer,n::Integer,
        fop::Function,fop_A::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,
        name::String="joLooseLinearFunctionFwd_A")

Look up argument names in help to joLooseLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLooseLinearFunctionFwd_A(m::Integer,n::Integer,
    fop::Function,fop_A::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLooseLinearFunctionFwd_A") =
        joLooseLinearFunction{DDT,RDT}(name,m,n,
            fop,
            v2->conj(fop_A(conj(v2))),
            fop_A,
            v4->conj(fop(conj(v4))),
            fMVok,
            @joNF, @joNF, @joNF, @joNF, false
            )

joLoosen(A::joLinearFunction{DDT,RDT}) where {DDT,RDT} =
    joLooseLinearFunction{DDT,RDT}("joLoosen("*A.name*")",A.m,A.n,
        v1->A.fop(v1),
        v2->get(A.fop_T)(v2),
        v3->get(A.fop_A)(v3),
        v4->get(A.fop_C)(v4),
        A.fMVok,
        v5->get(A.iop)(v5),
        v6->get(A.iop_T)(v6),
        v7->get(A.iop_A)(v7),
        v8->get(A.iop_C)(v8),
        A.iMVok
        )

