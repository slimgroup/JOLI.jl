using JOLI
using LinearAlgebra

A=joMatrix(rand(4,4))
display(elements(A))
display(JOLI.joHelpers_etc.elements_helper(A))
println(norm(elements(A)-JOLI.joHelpers_etc.elements_helper(A)))

A=joMatrix(rand(4,5))
display(elements(A))
display(JOLI.joHelpers_etc.elements_helper(A))
println(norm(elements(A)-JOLI.joHelpers_etc.elements_helper(A)))

A=joMatrix(rand(5,4))
display(elements(A))
display(JOLI.joHelpers_etc.elements_helper(A))
println(norm(elements(A)-JOLI.joHelpers_etc.elements_helper(A)))

A=joDFT(4)
display(elements(A))
display(JOLI.joHelpers_etc.elements_helper(A))
println(norm(elements(A)-JOLI.joHelpers_etc.elements_helper(A)))
