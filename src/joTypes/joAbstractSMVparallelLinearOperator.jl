############################################################
# joAbstractSMVparallelLinearOperator subtypes ##############
############################################################

############################################################
# joSMVLinearOperator #######################################

export joSMVLinearOperator, joSMVLinearOperatorException
export joSMVdistributedLinearOperator, joSMVdistributedLinearOperatorException
export joSMVdistributingLinearOperator, joSMVdistributingLinearOperatorException
export joSMVgatheringLinearOperator, joSMVgatheringLinearOperatorException

# type definition
"""
    joSMVLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joSMVLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractSMVparallelLinearOperator{DDT,RDT,N}
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
    joSMVdistributedLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joSMVdistributedLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractSMVparallelLinearOperator{DDT,RDT,N}
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
    joSMVdistributingLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joSMVdistributingLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractSMVparallelLinearOperator{DDT,RDT,N}
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
    joSMVgatheringLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators

"""
struct joSMVgatheringLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractSMVparallelLinearOperator{DDT,RDT,N}
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
struct joSMVLinearOperatorException <: Exception
    msg :: String
end
struct joSMVdistributedLinearOperatorException <: Exception
    msg :: String
end
struct joSMVdistributingLinearOperatorException <: Exception
    msg :: String
end
struct joSMVgatheringLinearOperatorException <: Exception
    msg :: String
end

# unions
const joSMVLinOpsUnion{D,R,N}=Union{joSMVLinearOperator{D,R,N},joSMVdistributedLinearOperator{D,R,N}} where {D,R,N}
const joSMVdistributeLinOpsUnion{D,R,N}=Union{joSAdistribute{D,R,N},joSMVdistributingLinearOperator{D,R,N}} where {D,R,N}
const joSMVgatherLinOpsUnion{D,R,N}=Union{joSAgather{D,R,N},joSMVgatheringLinearOperator{D,R,N}} where {D,R,N}
