############################################################
## joLinearOperator - outer constructors

############################################################
## joNumber - extra constructor with joAbstractLinearOperator
"""
joNumber outer constructor

    joNumber(num,A::joAbstractLinearOperator{DDT,RDT})

Create joNumber with types matching the given operator.

"""
joNumber{NT<:Number,DDT,RDT}(num::NT,A::joAbstractLinearOperator{DDT,RDT}) =
    joNumber{DDT,RDT}(jo_convert(DDT,num),jo_convert(RDT,num))
