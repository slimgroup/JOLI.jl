@everywhere using JOLI
@everywhere using DistributedArrays

dims=(2,2,nworkers())
dst=joPAsetup(dims)
showall(dst); println()

a=rand(dims...)
display(a); println()
A=distribute(a)
display(A); println()
Ad=distribute(a,dst)
display(Ad); println()
ad=convert(Array, Ad)
display(ad-a); println()
display(convert(Array, Ad-A)); println()
println(Ad==A)
