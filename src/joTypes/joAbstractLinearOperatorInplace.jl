############################################################
# joAbstractLinearOperatorInplace ##########################
############################################################

export joAbstractLinearOperatorInplace, joAbstractLinearOperatorInplaceException

# type definition
abstract type joAbstractLinearOperatorInplace{DDT<:Number,RDT<:Number} <: joAbstractFosterLinearOperator{DDT,RDT} end

# type exception
type joAbstractLinearOperatorInplaceException <: Exception
    msg :: String
end

