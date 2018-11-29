############################################################
# joAbstractParallelLinearOperator subtypes ################
############################################################

############################################################
# joDALinearOperator #######################################

export joDALinearOperator, joDALinearOperatorException
export joDAdistributingLinearOperator, joDAdistributingLinearOperatorException
export joDAgatheringLinearOperator, joDAgatheringLinearOperatorException

# type definition
"""
    joDALinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joDALinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractParallelLinearOperator{DDT,RDT,N}
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
    dst_in::joDAdistributor    # input distributor
    dst_out::joDAdistributor   # output distributor
    fclean::Bool               # clean input vector post forward
    rclean::Bool               # clean input vector post reverse
end
"""
    joDAdistributingLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joDAdistributingLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractParallelLinearOperator{DDT,RDT,N}
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
    dst_out::joDAdistributor   # output distributor
    gclean::Bool               # clean input vector post gathering
end
"""
    joDAgatheringLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joDAgatheringLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractParallelLinearOperator{DDT,RDT,N}
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
    dst_in::joDAdistributor       # input distributor
    gclean::Bool               # clean input vector post gathering
end

# type exception
struct joDALinearOperatorException <: Exception
    msg :: String
end
struct joDAditributingLinearOperatorException <: Exception
    msg :: String
end
struct joDAgatheringLinearOperatorException <: Exception
    msg :: String
end

