using JOLI # remove when done
using FFTW

A=joRomberg(5,5)
elements(A)
A*randn(25,2)
adjoint(A)*rand(25,2)
transpose(A)*rand(25,2)
conj(A)*rand(25,2)
(isadjoint(A)[1],islinear(A)[1])

