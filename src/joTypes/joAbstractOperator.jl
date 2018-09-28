############################################################
# joAbstractOperator #######################################
############################################################

export joAbstractOperator, joAbstractOperatorException

# type definition
abstract type joAbstractOperator end

# type exception
struct joAbstractOperatorException <: Exception
    msg :: String
end

