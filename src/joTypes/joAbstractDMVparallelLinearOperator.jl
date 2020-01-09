############################################################
# joAbstractDMVparallelLinearOperator subtypes ##############
############################################################

############################################################
# joDMVLinearOperator #######################################

export joDMVLinearOperator, joDMVLinearOperatorException
export joDMVdistributedLinearOperator, joDMVdistributedLinearOperatorException
export joDMVdistributingLinearOperator, joDMVdistributingLinearOperatorException
export joDMVgatheringLinearOperator, joDMVgatheringLinearOperatorException

# type definition
"""
    joDMVLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joDMVLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractDMVparallelLinearOperator{DDT,RDT,N}
    name::String
    m::Integer
    n::Integer
    nvc::Integer
    fop::Function              # forward
    fop_T::Nullable{Function}  # transpose
    fop_A::Nullable{Function}  # adjoint
    fop_C::Nullable{Function}  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    PAs_in::joPAsetup    # input distributor
    PAs_out::joPAsetup   # output distributor
    fclean::Bool         # clean input vector post forward
    rclean::Bool         # clean input vector post reverse
end
"""
    joDMVdistributedLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joDMVdistributedLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractDMVparallelLinearOperator{DDT,RDT,N}
    name::String
    m::Integer
    n::Integer
    nvc::Integer
    fop::Function              # forward
    fop_T::Nullable{Function}  # transpose
    fop_A::Nullable{Function}  # adjoint
    fop_C::Nullable{Function}  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    PAs_in::joPAsetup   # input distributor
    PAs_out::joPAsetup  # output distributor
    fclean::Bool        # clean input vector post forward
    rclean::Bool        # clean input vector post reverse
end
"""
    joDMVdistributingLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joDMVdistributingLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractDMVparallelLinearOperator{DDT,RDT,N}
    name::String
    m::Integer
    n::Integer
    nvc::Integer
    fop::Function              # forward
    fop_T::Nullable{Function}  # transpose
    fop_A::Nullable{Function}  # adjoint
    fop_C::Nullable{Function}  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    PAs_out::joPAsetup  # output distributor
    gclean::Bool        # clean input vector post gathering
end
"""
    joDMVgatheringLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joDMVgatheringLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractDMVparallelLinearOperator{DDT,RDT,N}
    name::String
    m::Integer
    n::Integer
    nvc::Integer
    fop::Function              # forward
    fop_T::Nullable{Function}  # transpose
    fop_A::Nullable{Function}  # adjoint
    fop_C::Nullable{Function}  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    PAs_in::joPAsetup  # input distributor
    gclean::Bool       # clean input vector post gathering
end

# type exception
struct joDMVLinearOperatorException <: Exception
    msg :: String
end
struct joDAdistrributedLinearOperatorException <: Exception
    msg :: String
end
struct joDMVdistributingLinearOperatorException <: Exception
    msg :: String
end
struct joDMVgatheringLinearOperatorException <: Exception
    msg :: String
end

# unions
const joDMVLinOpsUnion{D,R,N}=Union{joDMVLinearOperator{D,R,N},joDMVdistributedLinearOperator{D,R,N}} where {D,R,N}
const joDMVdistributeLinOpsUnion{D,R,N}=Union{joDAdistribute{D,R,N},joDMVdistributingLinearOperator{D,R,N}} where {D,R,N}
const joDMVgatherLinOpsUnion{D,R,N}=Union{joDAgather{D,R,N},joDMVgatheringLinearOperator{D,R,N}} where {D,R,N}
