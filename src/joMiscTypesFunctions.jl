############################################################
# Misc Types Functions #####################################
############################################################

############################################################
## joNumber
"""
joNumber outer constructor

    joNumber(num)

Create joNumber with types matching given number

"""
joNumber{NT<:Number}(num::NT) = joNumber{NT,NT}(num,num)
# other functions
-{DDT,RDT}(n::joNumber{DDT,RDT}) = joNumber{DDT,RDT}(-n.ddt,-n.rdt)
inv{DDT,RDT}(n::joNumber{DDT,RDT}) = joNumber{DDT,RDT}(inv(n.ddt),inv(n.rdt))

