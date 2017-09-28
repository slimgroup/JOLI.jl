############################################################
## joLinearFunctionInplace - outer constructors

export joLinearFunctionInplaceAll, joLinearFunctionInplaceT, joLinearFunctionInplaceCT,
       joLinearFunctionInplaceFwd, joLinearFunctionInplaceFwdT, joLinearFunctionInplaceFwdCT


"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplaceAll(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_CT::Function,
        iop::Function,iop_T::Function,iop_CT::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplaceAll")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplaceAll(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,
    iop::Function,iop_T::Function,iop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceAll") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop,fop_T,fop_CT,
            iop,iop_T,iop_CT
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplaceT(m::Integer,n::Integer,
        fop::Function,fop_T::Function, iop::Function,iop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplaceT")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplaceT(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceT") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop,
            fop_T,
            @joNF,
            iop,
            iop_T,
            @joNF
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplaceCT(m::Integer,n::Integer,
        fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplaceCT")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplaceCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceCT") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop,
            @joNF,
            fop_CT,
            iop,
            @joNF,
            iop_CT
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplaceFwd(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_CT::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplaceAll")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplaceFwd(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceAll") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop,fop_T,fop_CT,
            @joNF, @joNF, @joNF
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplaceFwdT(m::Integer,n::Integer,
        fop::Function,fop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplaceFwdT")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplaceFwdT(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceFwdT") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop,
            fop_T,
            @joNF,
            @joNF, @joNF, @joNF
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplaceFwdCT(m::Integer,n::Integer,
        fop::Function,fop_CT::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplaceFwdCT")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplaceFwdCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceFwdCT") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop,
            @joNF,
            fop_CT,
            @joNF, @joNF, @joNF
            )

