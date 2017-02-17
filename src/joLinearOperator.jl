############################################################
# joLinearOperator #########################################
############################################################

export joLinearOperator, joLinearOperatorException

############################################################
## type definition

"""
    joLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators
    !!! Use joMatrix and joLinearFunction constructors

"""
immutable joLinearOperator{EDT<:Number,DDT<:Number,RDT<:Number} <: joAbstractLinearOperator{EDT,DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function              # forward
    fop_T::Nullable{Function}  # transpose
    fop_CT::Nullable{Function} # conj transpose
    fop_C::Nullable{Function}  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_CT::Nullable{Function}
    iop_C::Nullable{Function}
end

############################################################
## type exceptions

type joLinearOperatorException <: Exception
    msg :: String
end

############################################################
# includes

include("joLinearOperator/constructors.jl")
include("joLinearOperator/base_functions.jl")
include("joLinearOperator/extra_functions.jl")
