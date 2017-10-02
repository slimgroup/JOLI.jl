############################################################
## joLooseLinearFunction - outer constructors

export joLooseLinearFunctionAll, joLooseLinearFunctionT, joLooseLinearFunctionCT,
       joLooseLinearFunctionFwd, joLooseLinearFunctionFwdT, joLooseLinearFunctionFwdCT


"""
joLooseLinearFunction outer constructor

    joLooseLinearFunctionAll(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
        iop::Function,iop_T::Function,iop_CT::Function,iop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,iMVok::Bool=false,
        name::String="joLooseLinearFunctionAll")

Look up argument names in help to joLooseLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLooseLinearFunctionAll(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
    iop::Function,iop_T::Function,iop_CT::Function,iop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLooseLinearFunctionAll") =
        joLooseLinearFunction{DDT,RDT}(name,m,n,
            fop,fop_T,fop_CT,fop_C,fMVok,
            iop,iop_T,iop_CT,iop_C,iMVok
            )
"""
joLooseLinearFunction outer constructor

    joLooseLinearFunctionT(m::Integer,n::Integer,
        fop::Function,fop_T::Function, iop::Function,iop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,iMVok::Bool=false,
        name::String="joLooseLinearFunctionT")

Look up argument names in help to joLooseLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLooseLinearFunctionT(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLooseLinearFunctionT") =
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

    joLooseLinearFunctionCT(m::Integer,n::Integer,
        fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,iMVok::Bool=false,
        name::String="joLooseLinearFunctionCT")

Look up argument names in help to joLooseLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLooseLinearFunctionCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLooseLinearFunctionCT") =
        joLooseLinearFunction{DDT,RDT}(name,m,n,
            fop,
            v2->conj(fop_CT(conj(v2))),
            fop_CT,
            v4->conj(fop(conj(v4))),
            fMVok,
            iop,
            v6->conj(iop_CT(conj(v6))),
            iop_CT,
            v8->conj(iop(conj(v8))),
            iMVok
            )
"""
joLooseLinearFunction outer constructor

    joLooseLinearFunctionFwd(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,
        name::String="joLooseLinearFunctionAll")

Look up argument names in help to joLooseLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLooseLinearFunctionFwd(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLooseLinearFunctionAll") =
        joLooseLinearFunction{DDT,RDT}(name,m,n,
            fop,fop_T,fop_CT,fop_C,fMVok,
            @joNF, @joNF, @joNF, @joNF, false
            )
"""
joLooseLinearFunction outer constructor

    joLooseLinearFunctionFwdT(m::Integer,n::Integer,
        fop::Function,fop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,
        name::String="joLooseLinearFunctionFwdT")

Look up argument names in help to joLooseLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLooseLinearFunctionFwdT(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLooseLinearFunctionFwdT") =
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

    joLooseLinearFunctionFwdCT(m::Integer,n::Integer,
        fop::Function,fop_CT::Function,
        DDT::DataType,RDT::DataType=DDT;
        fMVok::Bool=false,
        name::String="joLooseLinearFunctionFwdCT")

Look up argument names in help to joLooseLinearFunction type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joLooseLinearFunctionFwdCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLooseLinearFunctionFwdCT") =
        joLooseLinearFunction{DDT,RDT}(name,m,n,
            fop,
            v2->conj(fop_CT(conj(v2))),
            fop_CT,
            v4->conj(fop(conj(v4))),
            fMVok,
            @joNF, @joNF, @joNF, @joNF, false
            )

joLoosen{DDT,RDT}(A::joLinearFunction{DDT,RDT}) =
    joLooseLinearFunction{DDT,RDT}("joLoosen("*A.name*")",A.m,A.n,
        v1->A.fop(v1),
        v2->get(A.fop_T)(v2),
        v3->get(A.fop_CT)(v3),
        v4->get(A.fop_C)(v4),
        A.fMVok,
        v5->get(A.iop)(v5),
        v6->get(A.iop_T)(v6),
        v7->get(A.iop_CT)(v7),
        v8->get(A.iop_C)(v8),
        A.iMVok
        )

