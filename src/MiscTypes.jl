############################################################
# Misc Types ###############################################
############################################################

############################################################
## joNumber
export joNumber
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
"""
joNumber outer constructor

    joNumber(num)

Create joNumber with types matching given number

"""
joNumber{NT<:Number}(num::NT) = joNumber{NT,NT}(num,num)
-{DDT,RDT}(n::joNumber{DDT,RDT}) = joNumber{DDT,RDT}(-n.ddt,-n.rdt)
inv{DDT,RDT}(n::joNumber{DDT,RDT}) = joNumber{DDT,RDT}(inv(n.ddt),inv(n.rdt))

