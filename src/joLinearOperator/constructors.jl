############################################################
## joLinearOperator - outer constructors

"""
joNumber outer constructor

    joNumber(num,A::joAbstractLinearOperator{DDT,RDT})

Create joNumber with types matching the given operator.

"""
joNumber{NT<:Number,DDT,RDT}(num::NT,A::joAbstractLinearOperator{DDT,RDT}) =
    joNumber{DDT,RDT}(jo_convert(DDT,num),jo_convert(RDT,num))
"""
joNumber outer constructor

    joNumber(num)

Create joNumber with types matching given number

"""
joNumber{NT<:Number}(num::NT) = joNumber{NT,NT}(num,num)

