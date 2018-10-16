############################################################
## joLinearFunctionInplace - outer constructors

export joLinearFunctionInplaceAll, joLinearFunctionInplace_T, joLinearFunctionInplace_A,
       joLinearFunctionInplaceFwd, joLinearFunctionInplaceFwd_T, joLinearFunctionInplaceFwd_A


"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplaceAll(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
        iop::Function,iop_T::Function,iop_A::Function,iop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplaceAll")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplaceAll(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
    iop::Function,iop_T::Function,iop_A::Function,iop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceAll") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop,fop_T,fop_A,fop_C,
            iop,iop_T,iop_A,iop_C
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplace_T(m::Integer,n::Integer,
        fop::Function,fop_T::Function, iop::Function,iop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplace_T")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplace_T(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplace_T") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, fop_T, @joNF, @joNF,
            iop, iop_T, @joNF, @joNF
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplace_A(m::Integer,n::Integer,
        fop::Function,fop_A::Function, iop::Function,iop_A::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplace_A")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplace_A(m::Integer,n::Integer,
    fop::Function,fop_A::Function, iop::Function,iop_A::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplace_A") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, @joNF, fop_A, @joNF,
            iop, @joNF, iop_A, @joNF
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplaceFwd(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplaceAll")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplaceFwd(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceAll") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop,fop_T,fop_A,fop_C,
            @joNF, @joNF, @joNF, @joNF
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplaceFwd_T(m::Integer,n::Integer,
        fop::Function,fop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplaceFwd_T")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplaceFwd_T(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceFwd_T") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, fop_T, @joNF, @joNF,
            @joNF, @joNF, @joNF, @joNF
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplaceFwd_A(m::Integer,n::Integer,
        fop::Function,fop_A::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplaceFwd_A")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplaceFwd_A(m::Integer,n::Integer,
    fop::Function,fop_A::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceFwd_A") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, @joNF, fop_A, @joNF,
            @joNF, @joNF, @joNF, @joNF
            )

