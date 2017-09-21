############################################################
# joAbstractLinearOperator #################################
############################################################

export joAbstractLinearOperator, joAbstractLinearOperatorException

############################################################
## type definition

abstract type joAbstractLinearOperator{DDT<:Number,RDT<:Number} <: joAbstractOperator end

############################################################
## type exceptions

type joAbstractLinearOperatorException <: Exception
    msg :: String
end

############################################################
# includes

include("joAbstractLinearOperator/IterativeSolversSupport.jl")
include("joAbstractLinearOperator/InplaceOpsSupport.jl")
