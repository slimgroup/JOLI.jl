############################################################
# joAbstractFosterLinearOperator ###########################
############################################################

export joAbstractFosterLinearOperator, joAbstractFosterLinearOperatorException

# type definition
abstract type joAbstractFosterLinearOperator{DDT<:Number,RDT<:Number} <: joAbstractOperator end

# type exception
type joAbstractFosterLinearOperatorException <: Exception
    msg :: String
end

