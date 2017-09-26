############################################################
# joLooseMatrix #################################################
############################################################

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
- fop_CT::Function : conj transpose matrix
- fop_C::Function : conj matrix
- iop::Nullable{Function} : inverse for fop
- iop_T::Nullable{Function} : inverse for fop_T
- iop_CT::Nullable{Function} : inverse for fop_CT
- iop_C::Nullable{Function} : inverse for fop_C

"""
struct joLooseMatrix{DDT<:Number,RDT<:Number} <: joAbstractFosterLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function    # forward
    fop_T::Function  # transpose
    fop_CT::Function # conj transpose
    fop_C::Function  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_CT::Nullable{Function}
    iop_C::Nullable{Function}
end

# type exception
type joLooseMatrixException <: Exception
    msg :: String
end

