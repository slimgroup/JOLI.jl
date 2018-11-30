############################################################
# abstract types hierarchy
#
# joAbstractOperator
# * joAbstractLinearOperator
#   * joAbstractParallelableLinearOperator
# * joAbstractFosterLinearOperator
#   * joAbstractLinearOperatorInplace
# * joAbstractDAparallelOperator
#  * joAbstractDAparallelToggleOperator
#  * joAbstractDAparallelLinearOperator
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
abstract type joAbstractParallelableLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractLinearOperator{DDT,RDT} end

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
# joAbstractDAparallelOperator #############################

export joAbstractDAparallelOperator, joAbstractDAparallelOperatorException

# type definition
abstract type joAbstractDAparallelOperator{DDT<:Number,RDT<:Number,N} <: joAbstractOperator end

# type exception
struct joAbstractDAparallelOperatorException <: Exception
    msg :: String
end

############################################################
# joAbstractDAparallelToggleOperator #######################

export joAbstractDAparallelToggleOperator, joAbstractDAparallelToggleOperatorException

# type definition
abstract type joAbstractDAparallelToggleOperator{DDT<:Number,RDT<:Number,N} <: joAbstractDAparallelOperator{DDT,RDT,N} end

# type exception
struct joAbstractDAparallelToggleOperatorException <: Exception
    msg :: String
end

############################################################
# joAbstractDAparallelLinearOperator #######################

export joAbstractDAparallelLinearOperator, joAbstractDAparallelLinearOperatorException

# type definition
abstract type joAbstractDAparallelLinearOperator{DDT<:Number,RDT<:Number,N} <: joAbstractDAparallelOperator{DDT,RDT,N} end

# type exception
struct joAbstractDAparallelLinearOperatorException <: Exception
    msg :: String
end

