############################################################
# joAbstractLinearOperator subtypes ########################
############################################################

############################################################
# joLinearOperator #########################################

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
    fop_A::Nullable{Function}  # adjoint
    fop_C::Nullable{Function}  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
end

# type exception
struct joLinearOperatorException <: Exception
    msg :: String
end

############################################################
# joMatrix #################################################

export joMatrix, joMatrixException

# type definition
"""
joMatrix type

# TYPE PARAMETERS
- DDT::DataType : domain DataType
- RDT::DataType : range DataType

# FIELDS
- name::String : given name
- m::Integer : # of rows
- n::Integer : # of columns
- fop::Function : forward matrix
- fop_T::Function : transpose matrix
- fop_A::Function : adjoint matrix
- fop_C::Function : conj matrix
- iop::Nullable{Function} : inverse for fop
- iop_T::Nullable{Function} : inverse for fop_T
- iop_A::Nullable{Function} : inverse for fop_A
- iop_C::Nullable{Function} : inverse for fop_C

"""
struct joMatrix{DDT<:Number,RDT<:Number} <: joAbstractLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function    # forward
    fop_T::Function  # transpose
    fop_A::Function  # adjoint
    fop_C::Function  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
end

# type exception
struct joMatrixException <: Exception
    msg :: String
end

############################################################
# joLinearFunction #########################################

export joLinearFunction, joLinearFunctionException

# type definition
"""
joLinearFunction type

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
- fop_C::Nullable{Function} : conj function
- fMVok : whether fops are rady to handle mvec
- iop::Nullable{Function} : inverse for fop
- iop_T::Nullable{Function} : inverse for fop_T
- iop_A::Nullable{Function} : inverse for fop_A
- iop_C::Nullable{Function} : inverse for fop_C
- iMVok::Bool : whether iops are rady to handle mvec

"""
struct joLinearFunction{DDT<:Number,RDT<:Number} <: joAbstractLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function              # forward
    fop_T::Nullable{Function}  # transpose
    fop_A::Nullable{Function}  # adjoint
    fop_C::Nullable{Function}  # conj
    fMVok::Bool                # forward can do mvec
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    iMVok::Bool
end

# type exception
struct joLinearFunctionException <: Exception
    msg :: String
end

