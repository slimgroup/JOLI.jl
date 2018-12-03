############################################################
# joAbstractFosterLinearOperatorInplace subtypes ###########
############################################################

############################################################
# joMatrixInplace ##########################################

export joMatrixInplace, joMatrixInplaceException

# type definition
"""
joMatrixInplace type

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
struct joMatrixInplace{DDT<:Number,RDT<:Number} <: joAbstractLinearOperatorInplace{DDT,RDT}
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
struct joMatrixInplaceException <: Exception
    msg :: String
end

############################################################
# joLooseMatrixInplace #####################################

export joLooseMatrixInplace, joLooseMatrixInplaceException

# type definition
"""
joLooseMatrixInplace type

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
- iop::Nullable{Function} : inverse for fop
- iop_T::Nullable{Function} : inverse for fop_T
- iop_A::Nullable{Function} : inverse for fop_A

"""
struct joLooseMatrixInplace{DDT<:Number,RDT<:Number} <: joAbstractLinearOperatorInplace{DDT,RDT}
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
struct joLooseMatrixInplaceException <: Exception
    msg :: String
end

############################################################
# joLinearFunctionInplace ##################################

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

############################################################
# joLooseLinearFunctionInplace #############################

export joLooseLinearFunctionInplace, joLooseLinearFunctionInplaceException

# type definition
"""
joLooseLinearFunctionInplace type

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
struct joLooseLinearFunctionInplace{DDT<:Number,RDT<:Number} <: joAbstractLinearOperatorInplace{DDT,RDT}
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
struct joLooseLinearFunctionInplaceException <: Exception
    msg :: String
end

