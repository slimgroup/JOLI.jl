############################################################
## joMatrix - extra functions

# double(jo)
double{DDT,RDT}(A::joMatrix{DDT,RDT}) = A*speye(DDT,A.n)

