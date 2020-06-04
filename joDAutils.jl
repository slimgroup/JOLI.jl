using Distributed
@everywhere using Distributed
@everywhere using DistributedArrays
@everywhere using LinearAlgebra
@everywhere using JOLI

# map(i->reverse(dst.idxs[i]),1:length(dst.idxs))

println("workers: $(nworkers()) / $(workers())")

dims=(nworkers()+2,nworkers()+1)#,2

println("....................")
dst=joPAsetup(dims,2); display(dst); println()
tdst=transpose(dst); display(tdst); println()
display(dzeros(dst)); println()
display(dones(tdst)); println()
d=drand(dst); display(d); println()

println("....................")
dst=joPAsetup(dims); display(dst); println("dst")
d=drand(dst);
ddst=joPAsetup(d); display(ddst); println("ddst")
trdst=transpose(dst); display(trdst); println("trdst")
ctrd=copy(transpose(d)); display(ctrd); println("ctrd")
ctrddst=joPAsetup(ctrd); display(ctrddst); println("ctrddst")
Ctrd=dcopy(transpose(d)); display(Ctrd); println("Ctrd+")
ctrd=dcopy(transpose(d),trdst); display(ctrd); println("ctrd+")
ctrddst=joPAsetup(ctrd); display(ctrddst); println("ctrddst+")

#println("....................")
#println(fieldnames(typeof(dst)))
#for f in fieldnames(typeof(dst))
    #println("dst: ",f," :$(getfield(dst,f))");
    #display(getfield(dst,f))
    #println()
#end

#println("....................")
#println(fieldnames(typeof(d)))
#for f in fieldnames(typeof(d))
    #println("d: ",f);
    #display(getfield(d,f))
    #println()
#end

#println("dims   :",d.dims)
#chunks=map(i->length(i)-1,d.cuts)
#println("chunks :",chunks)
#println("workers:",d.pids)
#for i=1:length(d.pids)
    #println(" ranges:",(d.pids[i],d.indices[i]))
#end
