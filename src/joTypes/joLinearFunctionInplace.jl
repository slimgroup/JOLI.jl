############################################################
# joLinearFunctionInplace ##################################
############################################################

export joLinearFunctionInplace, joLinearFunctionInplaceException

# type definition
"""
joLinearFunctionInplace type

# TYPE PARAMETERS
- DDT::DataType : domain DataType
- RDT::DataType : range DataType

# FIELDS
- name::String : given name
- m::Integer : # of rows
- n::Integer : # of columns
- fop::Function : forward function
- fop_T::Nullable{Function} : transpose function
- fop_A::Nullable{Function} : adjoint function
- iop::Nullable{Function} : inverse for fop
- iop_T::Nullable{Function} : inverse for fop_T
- iop_A::Nullable{Function} : inverse for fop_A

"""
struct joLinearFunctionInplace{DDT<:Number,RDT<:Number} <: joAbstractLinearOperatorInplace{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function              # forward
    fop_T::Nullable{Function}  # transpose
    fop_A::Nullable{Function}  # adjoint
    fop_C::Nullable{Function}  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
end

# type exceptions
struct joLinearFunctionInplaceException <: Exception
    msg :: String
end

