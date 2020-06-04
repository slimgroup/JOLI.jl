using Distributed
@everywhere using Distributed
@everywhere using DistributedArrays
@everywhere using JOLI

import JOLI.joPAsetup_etc

println("workers: $(nworkers()) / $(workers())")

dims=(3,nworkers()+1,2)
dist=joPAsetup_etc.default_chunks(dims,workers())
dst=joPAsetup(dims,chunks=dist,DT=Int)

d=dzeros(dims...)
display(d); println()
d=dzeros(dims,workers())
display(d); println()
d=dzeros(dims,workers(),dist)
display(d); println()
d=dalloc(dims...)
display(d); println()
d=dalloc(Float32,dims...)
display(d); println()

println("....................")
display(dst); println()
d=dalloc(dst); display(d); println()
d=dzeros(dst); display(d); println()
d=dones(dst); display(d); println()
d=dfill(3.,dst); display(d); println()
d=dfill(3,dst;DT=Float32); display(d); println()
d=dfill(I->ones(dst.DT,map(length,I)),dst;DT=Float32); display(d); println()
d=drand(dst); display(d); println()
d=drand(dst;DT=Int8); display(d); println()
d=drand(dst;DT=Float16); display(d); println()
d=drandn(dst); display(d); println()
d=drandn(dst;DT=Float32); display(d); println()

println("....................")
d=distribute(rand(Int,dims...),dst); display(d); println()
d=Array(d);  display(d); println()

println("....................")
d=dalloc(joPAsetup(dims;DT=Int16)); display(d); println()
d=dalloc(joPAsetup(dims;DT=Float32)); display(d); println()
d=dalloc(joPAsetup(dims;chunks=dist,DT=Float64)); display(d); println()

