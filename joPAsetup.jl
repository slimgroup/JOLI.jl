using Distributed
@everywhere using Distributed
@everywhere using DistributedArrays
@everywhere using LinearAlgebra
@everywhere using JOLI

import JOLI.joPAsetup_etc

println("workers: $(nworkers()) / $(workers())")
wpool=WorkerPool(workers())

DIMS=((nworkers()+1,nworkers()-1),
      (nworkers(),nworkers()+1))

for dims in DIMS
    println("... basic ... $(dims)")
    dst=joPAsetup(dims); display(dst); println()
    println("... basic wpool ... $(dims)")
    dst=joPAsetup(wpool,dims); display(dst); println()
    println("... basic wpool chanks ... $(dims)")
    dst=joPAsetup(wpool,dims,chunks=[1,nworkers()]); display(dst); println()
    println("... ddim ... $(dims)")
    dst=joPAsetup(dims,1); display(dst); println()
    println("... ddim wpool ... $(dims)")
    dst=joPAsetup(wpool,dims,2); display(dst); println()
    println("... ddim wpool parts ... $(dims)")
    dst=joPAsetup(wpool,dims,2,parts=joPAsetup_etc.balanced_partition(nworkers(),dims[2])); display(dst); println()
    println("... ultimate ... $(dims)")
    dst=joPAsetup(((dims[1],),(joPAsetup_etc.balanced_partition(nworkers(),dims[2])...,))); display(dst); println()
    println("... ultimate wpool ... $(dims)")
    dst=joPAsetup(wpool,((joPAsetup_etc.balanced_partition(nworkers(),dims[1])...,),(dims[2],))); display(dst); println()
end
