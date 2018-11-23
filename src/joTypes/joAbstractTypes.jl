############################################################
# abstract types hierarchy
#
# joAbstractOperator
# * joAbstractLinearOperator
#   * joAbstractParallelableLinearOperator
# * joAbstractFosterLinearOperator
#   * joAbstractLinearOperatorInplace
# * joAbstractParallelToggleOperator
# * joAbstractParallelLinearOperator
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
# joAbstractParallelableLinearOperator #####################

export joAbstractParallelableLinearOperator, joAbstractParallelableLinearOperatorException

# type definition
abstract type joAbstractParallelableLinearOperator{DDT<:Number,RDT<:Number} <: joAbstractLinearOperator{DDT,RDT} end

# type exception
struct joAbstractParallelableLinearOperatorException <: Exception
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

############################################################
# joAbstractParallelToggleOperator #########################

export joAbstractParallelToggleOperator, joAbstractParallelToggleOperatorException

# type definition
abstract type joAbstractParallelToggleOperator{DDT<:Number,RDT<:Number} <: joAbstractOperator end

# type exception
struct joAbstractParallelToggleOperatorException <: Exception
    msg :: String
end

############################################################
# joAbstractParallelLinearOperator #########################

export joAbstractParallelLinearOperator, joAbstractParallelLinearOperatorException

# type definition
abstract type joAbstractParallelLinearOperator{DDT<:Number,RDT<:Number} <: joAbstractOperator end

# type exception
struct joAbstractParallelLinearOperatorException <: Exception
    msg :: String
end

