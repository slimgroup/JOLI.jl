############################################################
# joAbstractOperator #######################################
############################################################

export joAbstractOperator, joAbstractLinearOperator, joAbstractOperatorException

############################################################
## type definition

abstract joAbstractOperator
abstract joAbstractLinearOperator{EDT<:Number,DDT<:Number,RDT<:Number} <: joAbstractOperator

type joAbstractOperatorException <: Exception
    msg :: String
end

############################################################
## type exceptions

type joAbstractLinearOperatorException <: Exception
    msg :: String
end

############################################################
# includes

include("joAbstractOperator/constructors.jl")
include("joAbstractOperator/base_functions.jl")
include("joAbstractOperator/extra_functions.jl")
