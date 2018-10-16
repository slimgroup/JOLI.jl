############################################################
## joLooseLinearFunctionInplace - outer constructors

export joLooseLinearFunctionInplaceAll, joLooseLinearFunctionInplace_T, joLooseLinearFunctionInplace_A,
       joLooseLinearFunctionInplaceFwd, joLooseLinearFunctionInplaceFwd_T, joLooseLinearFunctionInplaceFwd_A


"""
joLooseLinearFunctionInplace outer constructor

    joLooseLinearFunctionInplaceAll(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
        iop::Function,iop_T::Function,iop_A::Function,iop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplaceAll")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplaceAll(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
    iop::Function,iop_T::Function,iop_A::Function,iop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceAll") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop,fop_T,fop_A,fop_C,
            iop,iop_T,iop_A,iop_C
            )
"""
joLooseLinearFunctionInplace outer constructor

    joLooseLinearFunctionInplace_T(m::Integer,n::Integer,
        fop::Function,fop_T::Function, iop::Function,iop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplace_T")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplace_T(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplace_T") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, fop_T, @joNF, @joNF,
            iop, iop_T, @joNF, @joNF
            )
"""
joLooseLinearFunctionInplace outer constructor

    joLooseLinearFunctionInplace_A(m::Integer,n::Integer,
        fop::Function,fop_A::Function, iop::Function,iop_A::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplace_A")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplace_A(m::Integer,n::Integer,
    fop::Function,fop_A::Function, iop::Function,iop_A::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplace_A") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, @joNF, fop_A, @joNF,
            iop, @joNF, iop_A, @joNF
            )
"""
joLooseLinearFunctionInplace outer constructor

    joLooseLinearFunctionInplaceFwd(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplaceAll")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplaceFwd(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceAll") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop,fop_T,fop_A,fop_C,
            @joNF, @joNF, @joNF, @joNF
            )
"""
joLooseLinearFunctionInplace outer constructor

    joLooseLinearFunctionInplaceFwd_T(m::Integer,n::Integer,
        fop::Function,fop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplaceFwd_T")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplaceFwd_T(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceFwd_T") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, fop_T, @joNF, @joNF,
            @joNF, @joNF, @joNF, @joNF
            )
"""
joLooseLinearFunctionInplace outer constructor

    joLooseLinearFunctionInplaceFwd_A(m::Integer,n::Integer,
        fop::Function,fop_A::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplaceFwd_A")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplaceFwd_A(m::Integer,n::Integer,
    fop::Function,fop_A::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceFwd_A") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, @joNF, fop_A, @joNF,
            @joNF, @joNF, @joNF, @joNF
            )

