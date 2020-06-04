#cache=joinpath(ENV["HOME"],".julia","compiled","v$(VERSION.major).$(VERSION.minor)","JOLI")
#isdir(cache) && rm(cache,force=true,recursive=true)

using Distributed
@everywhere using Distributed
@everywhere using SparseArrays
@everywhere using SharedArrays
@everywhere using LinearAlgebra
@everywhere using JOLI

println("....................")
println("workers: $(nworkers()) / $(workers())")

dims1=(nworkers()+1,nworkers()+1)
dims2=(nworkers()+3,nworkers()+3)
nvc2=nworkers()+5
println((dims1,dims2,nvc2))

dst1=joPAsetup((dims1[2],)); display(dst1); println()
dst2=joPAsetup((dims2[2],nvc2)); display(dst2); println()

println("... joSAdistribute ...")
D1=joSAdistribute(dims1[2]);show(D1);show(D1')
D2=joSAdistribute(dims2[2],nvc2);show(D2);show(D2')

println("... joSAgather ...")
G1=joSAgather(dims1[2]);show(G1);show(G1')
G2=joSAgather(dims2[2],nvc2);show(G2);show(G2')

@info ".. compare ..."
println("isequal:",(isequal(D1.PAs_out,G1.PAs_in),isequal(D2.PAs_out,G2.PAs_in),isequal(D1.PAs_out,G2.PAs_in),isequal(D2.PAs_out,G1.PAs_in)))
println("isapprox:",(isapprox(D1.PAs_out,G1.PAs_in),isapprox(D2.PAs_out,G2.PAs_in),isapprox(D1.PAs_out,G2.PAs_in),isapprox(D2.PAs_out,G1.PAs_in)))

@info "on rand direct"
v=rand(dims1[2])
println(D1'*(D1*v)==v," <- vector")
v=rand(dims2[2],nvc2)
println(D2'*(D2*v)==v," <- multi-vector")

@info "on srand direct"
v=srand(dst1)
println(G1'*(G1*v)==v," <- vector")
v=srand(dst2)
println(G2'*(G2*v)==v," <- multi-vector")

@info "distribute MV before"
W=nworkers()
M=W+1; N=W+1; NVC=2*nworkers()-1
OL=joGaussian(M,N+1);
OM=joGaussian(M+1,N+1);
OR=joGaussian(M+1,N);
O=OL*OM*OR
DL=joSAdistributedLinOp(OL,NVC);
DM=joSAdistributedLinOp(OM,NVC);
DR=joSAdistributedLinOp(OR,NVC);
DO=DL*DM*DR; show(DO)
A=joSAdistributedLinOp(O,NVC); show(A)
D=joSAdistribute(size(O,2),NVC); show(D)
G=joSAgather(size(O,1),NVC); show(G)
vn=rand(size(O,2),NVC)
vm=O*vn
avn=O'*vm
println(isapprox(G*(A*(D*vn)),vm)," <- G*(A*(D*vn))");
println(isapprox(G*(DO*(D*vn)),vm)," <- G*(DO*(D*vn))");
println(isapprox(D'*(A'*(G'*vm)),avn)," <- D'*(A'*(G'*vm))");
println(isapprox(D'*(DO'*(G'*vm)),avn)," <- D'*(DO'*(G'*vm))");
GAD=G*A*D;
show(GAD); 
println(isapprox(GAD*vn,vm)," <- GAD*vn");
show(GAD'); 
println(isapprox(GAD'*vm,avn)," <- GAD'*vm");
GAD=G*DO*D;
show(GAD); 
println(isapprox(GAD*vn,vm)," <- GAD*vn")
show(GAD'); 
println(isapprox(GAD'*vm,avn)," <- GAD'*vm")
println("...")

@info "gather MV before tall"
M=6; N=4; NVC=9*nworkers()+1
A=joGaussian(M,N)
G=joSAgather(N,NVC)
D=joSAdistribute(M,NVC)
DAG=D*A*G
show(DAG);
show(DAG');
v=srand(joPAsetup((N,NVC)))
sv=A*Array(v)
println(isapprox(DAG*v,sv)," <- DAG*v")
v=srand(joPAsetup((M,NVC)))
sv=A'*Array(v)
println(isapprox(DAG'*v,sv)," <- DAG'*v")
println("...")

@info "gather MV before wide"
M=4; N=6; NVC=9*nworkers()+1
A=joGaussian(M,N)
G=joSAgather(N,NVC)
D=joSAdistribute(M,NVC)
DAG=D*A*G
show(DAG)
show(DAG');
v=srand(joPAsetup((N,NVC)))
sv=A*Array(v)
println(isapprox(DAG*v,sv)," <- DAG*v")
v=srand(joPAsetup((M,NVC)))
sv=A'*Array(v)
println(isapprox(DAG'*v,sv)," <- DAG'*v")

#@assert false "controlled stop:)"
