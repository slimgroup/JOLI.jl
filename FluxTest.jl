using Flux
using JOLI
using JOLI4Flux

A = joGaussian(10,100)
eA = elements(A)

m = Conv((3, 3), 1=>1, pad=1, stride=1);

x = randn(10,10,1,1);

mx = m(x)
println(typeof(mx))
vmx = vec(mx)
println(typeof(vmx))

y = A * vec(m(x))
display(y);println()

