############################################################
# joAbstractDAparallelLinearOperator subtypes ##############
############################################################

############################################################
# joDALinearOperator #######################################

export joDALinearOperator, joDALinearOperatorException
export joDAdistributedLinearOperator, joDAdistributedLinearOperatorException
export joDAdistributingLinearOperator, joDAdistributingLinearOperatorException
export joDAgatheringLinearOperator, joDAgatheringLinearOperatorException

# type definition
"""
    joDALinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joDALinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractDAparallelLinearOperator{DDT,RDT,N}
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
    joDAdistributedLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joDAdistributedLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractDAparallelLinearOperator{DDT,RDT,N}
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
    joDAdistributingLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joDAdistributingLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractDAparallelLinearOperator{DDT,RDT,N}
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
    joDAgatheringLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joDAgatheringLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractDAparallelLinearOperator{DDT,RDT,N}
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
struct joDALinearOperatorException <: Exception
    msg :: String
end
struct joDAdistributedLinearOperatorException <: Exception
    msg :: String
end
struct joDAdistributingLinearOperatorException <: Exception
    msg :: String
end
struct joDAgatheringLinearOperatorException <: Exception
    msg :: String
end

# unions
const joDALinOpsUnion{D,R,N}=Union{joDALinearOperator{D,R,N},joDAdistributedLinearOperator{D,R,N}} where {D,R,N}
const joDAdistributeLinOpsUnion{D,R,N}=Union{joDAdistribute{D,R,N},joDAdistributingLinearOperator{D,R,N}} where {D,R,N}
const joDAgatherLinOpsUnion{D,R,N}=Union{joDAgather{D,R,N},joDAgatheringLinearOperator{D,R,N}} where {D,R,N}
