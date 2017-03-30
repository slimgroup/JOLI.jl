############################################################
## joLinearFunction - outer constructors

"""
joLinearFunction outer constructor

    joLinearFunctionAll(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
        iop::Function,iop_T::Function,iop_CT::Function,iop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionAll")

Look up argument names in help to joLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLinearFunctionAll(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
    iop::Function,iop_T::Function,iop_CT::Function,iop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionAll") =
        joLinearFunction{DDT,RDT}(name,m,n,
            fop,fop_T,fop_CT,fop_C,
            iop,iop_T,iop_CT,iop_C
            )
"""
joLinearFunction outer constructor

    joLinearFunctionT(m::Integer,n::Integer,
        fop::Function,fop_T::Function, iop::Function,iop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionT")

Look up argument names in help to joLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLinearFunctionT(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionT") =
        joLinearFunction{DDT,RDT}(name,m,n,
            fop,
            fop_T,
            v3->conj(fop_T(conj(v3))),
            v4->conj(fop(conj(v4))),
            iop,
            iop_T,
            v7->conj(iop_T(conj(v7))),
            v8->conj(iop(conj(v8)))
            )
"""
joLinearFunction outer constructor

    joLinearFunctionCT(m::Integer,n::Integer,
        fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionCT")

Look up argument names in help to joLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLinearFunctionCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionCT") =
        joLinearFunction{DDT,RDT}(name,m,n,
            fop,
            v2->conj(fop_CT(conj(v2))),
            fop_CT,
            v4->conj(fop(conj(v4))),
            iop,
            v6->conj(iop_CT(conj(v6))),
            iop_CT,
            v8->conj(iop(conj(v8)))
            )
"""
joLinearFunction outer constructor

    joLinearFunctionFwdT(m::Integer,n::Integer,
        fop::Function,fop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionFwdT")

Look up argument names in help to joLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLinearFunctionFwdT(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionFwdT") =
        joLinearFunction{DDT,RDT}(name,m,n,
            fop,
            fop_T,
            v3->conj(fop_T(conj(v3))),
            v4->conj(fop(conj(v4))),
            @joNF, @joNF, @joNF, @joNF
            )
"""
joLinearFunction outer constructor

    joLinearFunctionFwdCT(m::Integer,n::Integer,
        fop::Function,fop_CT::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionFwdCT")

Look up argument names in help to joLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLinearFunctionFwdCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionFwdCT") =
        joLinearFunction{DDT,RDT}(name,m,n,
            fop,
            v2->conj(fop_CT(conj(v2))),
            fop_CT,
            v4->conj(fop(conj(v4))),
            @joNF, @joNF, @joNF, @joNF
            )

