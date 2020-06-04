using JOLI
using LinearAlgebra

A=joMatrix(rand(3,4))
display(elements(A));println()
display(JOLI.joHelpers_etc.elements_helper(A));println()
display(A[:,1]);println()
display(A[:,1:3]);println()
#display(A[:,1:2:5])

A=joDFT(4)
display(elements(A));println()
display(JOLI.joHelpers_etc.elements_helper(A));println()
display(A[:,1]);println()
display(A[:,1:3]);println()
#display(A[:,1:2:5])

