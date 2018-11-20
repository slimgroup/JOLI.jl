############################################################
# abstract types hierarchy
#
# joAbstractOperator
# * joAbstractLinearOperator
# * joAbstractFosterLinearOperator
#   * joAbstractLinearOperatorInplace
#   
############################################################

############################################################
# joAbstractOperator #######################################

export joAbstractOperator, joAbstractOperatorException

# type definition
abstract type joAbstractOperator end

# type exception
struct joAbstractOperatorException <: Exception
    msg :: String
end

############################################################
# joAbstractLinearOperator #################################

export joAbstractLinearOperator, joAbstractLinearOperatorException

# type definition
abstract type joAbstractLinearOperator{DDT<:Number,RDT<:Number} <: joAbstractOperator end

# type exception
struct joAbstractLinearOperatorException <: Exception
    msg :: String
end

############################################################
# joAbstractFosterLinearOperator ###########################

export joAbstractFosterLinearOperator, joAbstractFosterLinearOperatorException

# type definition
abstract type joAbstractFosterLinearOperator{DDT<:Number,RDT<:Number} <: joAbstractOperator end

# type exception
struct joAbstractFosterLinearOperatorException <: Exception
    msg :: String
end

############################################################
# joAbstractLinearOperatorInplace ##########################

export joAbstractLinearOperatorInplace, joAbstractLinearOperatorInplaceException

# type definition
abstract type joAbstractLinearOperatorInplace{DDT<:Number,RDT<:Number} <: joAbstractFosterLinearOperator{DDT,RDT} end

# type exception
struct joAbstractLinearOperatorInplaceException <: Exception
    msg :: String
end

