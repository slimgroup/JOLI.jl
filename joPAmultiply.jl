using Distributed
@everywhere using Distributed
@everywhere using BenchmarkTools
@everywhere using JOLI

@everywhere using LinearAlgebra
#THR=1;
#@everywhere LinearAlgebra.BLAS.set_num_threads(1)
#@info "using $THR threads on each worker"

M1=4096
M2=64
NVC=1024*nworkers()

echo=show
#echo=display

#A=joGaussian(M1,M1)
#A=joDFT(m,planned=false)
A=joKron(joDFT(M2,planned=false)',joDFT(M2,planned=false))
SA=joSAdistributedLinOp(A,NVC)
DA=joDAdistributedLinOp(A,NVC)
SAd=joSAdistribute(SA)
DAd=joDAdistribute(DA)
gSA=joSAgather(SA)
gDA=joDAgather(DA)

in=rand(size(A,2),NVC)
sin=SAd*in
din=DAd*in

@time A*in
@time SA*sin
@time DA*din
@time SA*SAd*in
@time DA*DAd*in
@time gSA*SA*SAd*in
@time gDA*DA*DAd*in

echo(@benchmark A*in);println(" <- A*in")
echo(@benchmark SA*sin);println(" <- SA*sin")
echo(@benchmark DA*din);println(" <- DA*din")
echo(@benchmark SA*SAd*in);println(" <- SA*SAd*in")
echo(@benchmark DA*DAd*in);println(" <- DA*DAd*in")
echo(@benchmark gSA*SA*SAd*in);println(" <- gSA*SA*SAd*in")
echo(@benchmark gDA*DA*DAd*in);println(" <- gDA*DA*DAd*in")

nothing
