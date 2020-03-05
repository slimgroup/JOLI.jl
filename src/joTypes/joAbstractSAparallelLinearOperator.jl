############################################################
# joAbstractSAparallelLinearOperator subtypes ##############
############################################################

############################################################
# joSALinearOperator #######################################

export joSALinearOperator, joSALinearOperatorException
export joSAdistributedLinearOperator, joSAdistributedLinearOperatorException
export joSAdistributingLinearOperator, joSAdistributingLinearOperatorException
export joSAgatheringLinearOperator, joSAgatheringLinearOperatorException

# type definition
"""
joSALinearOperator is glueing type & constructor

!!! Do not use it to create the operators

"""
struct joSALinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractSAparallelLinearOperator{DDT,RDT,N}
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
joSAdistributedLinearOperator is glueing type & constructor

!!! Do not use it to create the operators

"""
struct joSAdistributedLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractSAparallelLinearOperator{DDT,RDT,N}
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
joSAdistributingLinearOperator is glueing type & constructor

!!! Do not use it to create the operators

"""
struct joSAdistributingLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractSAparallelLinearOperator{DDT,RDT,N}
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
joSAgatheringLinearOperator is glueing type & constructor

!!! Do not use it to create the operators

"""
struct joSAgatheringLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractSAparallelLinearOperator{DDT,RDT,N}
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
struct joSALinearOperatorException <: Exception
    msg :: String
end
struct joSAdistributedLinearOperatorException <: Exception
    msg :: String
end
struct joSAdistributingLinearOperatorException <: Exception
    msg :: String
end
struct joSAgatheringLinearOperatorException <: Exception
    msg :: String
end

# unions
const joSALinOpsUnion{D,R,N}=Union{joSALinearOperator{D,R,N},joSAdistributedLinearOperator{D,R,N}} where {D,R,N}
const joSAdistributeLinOpsUnion{D,R,N}=Union{joSAdistribute{D,R,N},joSAdistributingLinearOperator{D,R,N}} where {D,R,N}
const joSAgatherLinOpsUnion{D,R,N}=Union{joSAgather{D,R,N},joSAgatheringLinearOperator{D,R,N}} where {D,R,N}
