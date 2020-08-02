using Distributed
using JOLI

M=8
N=10
NVC=12
jo_PAmode(:SA)
println("PA mode: ",jo_PAmode())

println("...")
A=joGaussian(M,N)
show(A)
ps=joPAsetup((N,NVC))
show(ps)

println("...")
pA=joPAdistributedLinOp(A,NVC)
show(pA)
pin=pA.PAs_in
show(pin)
pout=pA.PAs_out
show(pout)
println(isequal(ps,pin))

println("...")
println(JOLI.joPAsetup_etc.parts(pin,1))
println(JOLI.joPAsetup_etc.parts(pin,2))

println("...")
wpool=WorkerPool(pin.procs)
nvc=pin.dims[2]
parts=JOLI.joPAsetup_etc.parts(pin,2)
ps2=joPAsetup(wpool,(A.m,nvc),parts=parts,2,DT=reltype(A),name=pin.name)
show(ps2)
println(isequal(pout,ps2))

println("...")

pA2=joPAdistributedLinOp(A,ps)
show(pA2)
