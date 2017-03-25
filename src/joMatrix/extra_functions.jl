############################################################
## joMatrix - extra functions

# elements(jo)
elements{DDT,RDT}(A::joMatrix{DDT,RDT}) = A*speye(DDT,A.n)

