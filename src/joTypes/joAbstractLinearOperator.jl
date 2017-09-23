############################################################
# joAbstractLinearOperator #################################
############################################################

export joAbstractLinearOperator, joAbstractLinearOperatorException

# type definition
abstract type joAbstractLinearOperator{DDT<:Number,RDT<:Number} <: joAbstractOperator end

# type exception
type joAbstractLinearOperatorException <: Exception
    msg :: String
end

