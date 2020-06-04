using JOLI
using DistributedArrays

for i=1:9
    part=JOLI.joPAsetup_etc.balanced_partition(i,99)
    println(part[1])
    println(part[2])
    DApart=DistributedArrays.defaultdist(99,i)
    println(DApart)
end

showall(DistributedArrays.defaultdist((2,3,4),workers())); println()
showall(JOLI.joPAsetup_etc.default_distribution((2,3,4),workers())); println()
showall(JOLI.joPAsetup_etc.default_distribution((3,4,2),workers())); println()
showall(JOLI.joPAsetup_etc.default_distribution((4,2,3),workers())); println()

println("-")
dims=(3,nworkers()*4,2)
display(dims); println()
dist=[1,1,nworkers()]
display(dist); println()
println("- joPAsetup")
dst=joPAsetup(dims,workers(),dist,DT=Int)
showall(dst);
println("- DAdistributor")
idxs,cuts = DistributedArrays.chunk_idxs(dims,dist)
display(idxs); println()
display(cuts); println()
println("- joPAsetup")
idxs,cuts = JOLI.joPAsetup_etc.idxs_cuts(dims,dist)
display(idxs); println()
display(cuts); println()
println("- joPAsetup")
mydist=((3,),(nworkers(),nworkers(),nworkers(),nworkers()),(2,))
display(mydist); println()
idxs,cuts = JOLI.joPAsetup_etc.idxs_cuts(dims,mydist)
display(idxs); println()
display(cuts); println()
dst=joPAsetup(dims,workers(),dist,DT=Int)
showall(dst); println()
dst=joPAsetup(mydist;DT=Int)
showall(dst); println()
myparts=(nworkers(),nworkers(),nworkers(),nworkers())
dst=joPAsetup(dims,2,myparts;DT=Int8)
showall(dst); println()

