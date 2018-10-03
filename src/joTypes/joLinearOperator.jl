############################################################
# joLinearOperator #########################################
############################################################

export joLinearOperator, joLinearOperatorException

# type definition
"""
    joLinearOperator is glueing type & constructor

    !!! Do not use it to create the operators
    !!! Use joMatrix and joLinearFunction constructors

"""
struct joLinearOperator{DDT<:Number,RDT<:Number} <: joAbstractLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function              # forward
    fop_T::Nullable{Function}  # transpose
    fop_CT::Nullable{Function} # adjoint
    fop_C::Nullable{Function}  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_CT::Nullable{Function}
    iop_C::Nullable{Function}
end

# type exception
struct joLinearOperatorException <: Exception
    msg :: String
end

