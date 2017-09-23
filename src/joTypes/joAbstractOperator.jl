############################################################
# joAbstractOperator #######################################
############################################################

export joAbstractOperator, joAbstractOperatorException

# type definition
abstract type joAbstractOperator end

# type exception
type joAbstractOperatorException <: Exception
    msg :: String
end

