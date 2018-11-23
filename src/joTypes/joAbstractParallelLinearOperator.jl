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
struct joDALinearOperator{DDT<:Number,RDT<:Number} <: joAbstractParallelLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function              # forward
    fop_T::Nullable{Function}  # transpose
    fop_A::Nullable{Function}  # adjoint
    fop_C::Nullable{Function}  # conj
    fdst::joDAdistributor      # forward distributor
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    idst::joDAdistributor
end
"""
    joDAdistributingLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joDAdistributingLinearOperator{DDT<:Number,RDT<:Number} <: joAbstractParallelLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function              # forward
    fop_T::Nullable{Function}  # transpose
    fop_A::Nullable{Function}  # adjoint
    fop_C::Nullable{Function}  # conj
    fdst::joDAdistributor      # forward distributor
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    idst::joDAdistributor
end
"""
    joDAgatheringLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joDAgatheringLinearOperator{DDT<:Number,RDT<:Number} <: joAbstractParallelLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function              # forward
    fop_T::Nullable{Function}  # transpose
    fop_A::Nullable{Function}  # adjoint
    fop_C::Nullable{Function}  # conj
    fdst::joDAdistributor      # forward distributor
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    idst::joDAdistributor
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

