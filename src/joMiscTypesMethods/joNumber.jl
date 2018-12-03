############################################################
# joNumber methods #########################################
############################################################

## constructors
"""
joNumber outer constructor

    joNumber(num)

Create joNumber with types matching given number

"""
joNumber(num::NT) where {NT<:Number} = joNumber{NT,NT}(num,num)
"""
joNumber outer constructor

    joNumber(num,A::joAbstractLinearOperator{DDT,RDT})

Create joNumber with types matching the given operator.

"""
joNumber(num::NT,A::joAbstractLinearOperator{DDT,RDT}) where {NT<:Number,DDT,RDT} =
    joNumber(jo_convert(DDT,num),jo_convert(RDT,num)) # where {DDT,RDT}

## other functions
-(n::joNumber{DDT,RDT}) where {DDT,RDT} = joNumber(-n.ddt,-n.rdt) # where {DDT,RDT}
inv(n::joNumber{DDT,RDT}) where {DDT,RDT} = joNumber(inv(n.ddt),inv(n.rdt)) # where {DDT,RDT}

