############################################################
## joLinearFunction - outer constructors

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

