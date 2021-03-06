############################################################
# joAbstractFosterLinearOperator subtypes ##################
############################################################

############################################################
# joLooseMatrix #################################################

export joLooseMatrix, joLooseMatrixException

# type definition
"""
joLooseMatrix type

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
struct joLooseMatrix{DDT<:Number,RDT<:Number} <: joAbstractFosterLinearOperator{DDT,RDT}
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
struct joLooseMatrixException <: Exception
    msg :: String
end

############################################################
# joLooseLinearFunction ####################################

export joLooseLinearFunction, joLooseLinearFunctionException

# type definition
"""
joLooseLinearFunction type

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
struct joLooseLinearFunction{DDT<:Number,RDT<:Number} <: joAbstractFosterLinearOperator{DDT,RDT}
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

# type exceptions
struct joLooseLinearFunctionException <: Exception
    msg :: String
end

