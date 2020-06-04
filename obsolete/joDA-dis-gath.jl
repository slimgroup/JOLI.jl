using Distributed
@everywhere using Distributed
@everywhere using DistributedArrays
@everywhere using LinearAlgebra
@everywhere using JOLI

#  joLinearFunctionFwd(m::Integer,n::Integer,
#      fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
#      DDT::DataType,RDT::DataType=DDT;
#      fMVok::Bool=false,
#      name::String="joLinearFunctionFwd")

# what is it: joDAdistribute

## helper module
module joDAdistribute_etc
    using JOLI

end
using .joDAdistribute_etc


println("....................")
println("workers: $(nworkers()) / $(workers())")

dims1=(nworkers()+1,nworkers()+1)
dims2=(nworkers()+3,nworkers()+3)
nvc2=nworkers()+5
println((dims1,dims2,nvc2))

dst1=joPAsetup((dims1[2],)); display(dst1); println()
dst2=joPAsetup((dims2[2],nvc2)); display(dst2); println()

println("... joDAdistribute ...")
D1=joDAdistribute(dims1[2]);show(D1);println()
D2=joDAdistribute(dims2[2],nvc2);show(D2);println()

display(D1'*D1*rand(dims1[2]));println("vector")
display(D2'*D2*rand(dims2[2],nvc2));println("multi-vector")

println("... joDAgather ...")
G1=joDAgather(dims1[2]);show(G1);println()
G2=joDAgather(dims2[2],nvc2);show(G2);println()

display(G1'*G1*drand(dims1[2]));println("vector")
display(G2'*G2*drand(dims2[2],nvc2));println("multi-vector")

@info "gather V before"
M=4; N=6;
A=joEye(M,N)
G=joDAgather(N)
D=joDAdistribute(M)
DAG=D*A*G
v=drand(N)
display(v)
display(DAG*v)
v=drand(M)
display(v)
display(DAG'*v)
@info "gather MV before"
M=2; N=3; NVC=3
A=joEye(M,N)
G=joDAgather(N,NVC)
D=joDAdistribute(M,NVC)
DAG=D*A*G
v=drand(joPAsetup((N,NVC)))
display(v)
display(DAG*v)
v=drand(joPAsetup((M,NVC)))
display(v)
display(DAG'*v)

#@info "distribute before"
#M=4; N=6;
#A=joEye(M,N)
#D=joDAdistribute(N)
#G=joDAgather(M)
#GAD=G*A*D
#v=rand(N)
#display(v)
#display(GAD*v)
#v=rand(M)
#display(v)
#display(GAD'*v)

