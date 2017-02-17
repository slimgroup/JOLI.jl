############################################################
## joMatrix - extra functions

# double(jo)
double{EDT,DDT,RDT}(A::joMatrix{EDT,DDT,RDT}) = A*speye(DDT,A.n)

