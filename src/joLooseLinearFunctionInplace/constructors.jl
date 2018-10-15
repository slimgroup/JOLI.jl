############################################################
## joLooseLinearFunctionInplace - outer constructors

export joLooseLinearFunctionInplaceAll, joLooseLinearFunctionInplaceT, joLooseLinearFunctionInplaceCT,
       joLooseLinearFunctionInplaceFwd, joLooseLinearFunctionInplaceFwdT, joLooseLinearFunctionInplaceFwdCT


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

    joLooseLinearFunctionInplaceT(m::Integer,n::Integer,
        fop::Function,fop_T::Function, iop::Function,iop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplaceT")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplaceT(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceT") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, fop_T, @joNF, @joNF,
            iop, iop_T, @joNF, @joNF
            )
"""
joLooseLinearFunctionInplace outer constructor

    joLooseLinearFunctionInplaceCT(m::Integer,n::Integer,
        fop::Function,fop_A::Function, iop::Function,iop_A::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplaceCT")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplaceCT(m::Integer,n::Integer,
    fop::Function,fop_A::Function, iop::Function,iop_A::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceCT") =
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

    joLooseLinearFunctionInplaceFwdT(m::Integer,n::Integer,
        fop::Function,fop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplaceFwdT")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplaceFwdT(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceFwdT") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, fop_T, @joNF, @joNF,
            @joNF, @joNF, @joNF, @joNF
            )
"""
joLooseLinearFunctionInplace outer constructor

    joLooseLinearFunctionInplaceFwdCT(m::Integer,n::Integer,
        fop::Function,fop_A::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplaceFwdCT")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplaceFwdCT(m::Integer,n::Integer,
    fop::Function,fop_A::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceFwdCT") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, @joNF, fop_A, @joNF,
            @joNF, @joNF, @joNF, @joNF
            )

