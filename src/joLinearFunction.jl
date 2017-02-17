############################################################
# joLinearFunction #########################################
############################################################

export joLinearFunction, joLinearFunctionAll, joLinearFunctionT, joLinearFunctionCT,
       joLinearFunctionFwdT, joLinearFunctionFwdCT, joLinearFunctionException

############################################################
## type definition

immutable joLinearFunction{ODT<:Number} <: joAbstractLinearOperator{ODT}
    name::String
    m::Integer
    n::Integer
    fop::Function              # forward
    fop_T::Nullable{Function}  # transpose
    fop_CT::Nullable{Function} # conj transpose
    fop_C::Nullable{Function}  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_CT::Nullable{Function}
    iop_C::Nullable{Function}
end

############################################################
## type exceptions

type joLinearFunctionException <: Exception
    msg :: String
end

############################################################
# includes

include("joLinearFunction/constructors.jl")
include("joLinearFunction/base_functions.jl")
include("joLinearFunction/extra_functions.jl")
