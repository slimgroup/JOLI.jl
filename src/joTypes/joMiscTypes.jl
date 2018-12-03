############################################################
## joNumber
############################################################

export joNumber

# type definition
"""
joNumber type

A number type to use for jo operations with number

# TYPE PARAMETERS
- DDT::DataType : domain DataType
- RDT::DataType : range DataType

# FIELDS
- ddt::DDT : number to use when acting on vector to return domain vector
- rdt::RDT : number to use when acting on vector to return range vector

"""
struct joNumber{DDT<:Number,RDT<:Number}
    ddt::DDT
    rdt::RDT
end

