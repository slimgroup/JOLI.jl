############################################################
# joAbstractOperator #######################################
############################################################

export joAbstractOperator, joAbstractOperatorException

############################################################
## type definition

abstract type joAbstractOperator end

############################################################
## type exceptions

type joAbstractOperatorException <: Exception
    msg :: String
end

############################################################
# includes

include("joAbstractOperator/constructors.jl")
include("joAbstractOperator/base_functions.jl")
include("joAbstractOperator/extra_functions.jl")
