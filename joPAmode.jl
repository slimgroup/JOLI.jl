using Distributed
@everywhere using Distributed
@everywhere using BenchmarkTools
@everywhere using LinearAlgebra
@everywhere using JOLI

try
    jo_PAmode(Symbol(ARGS[1]))
catch
    @error "joPAmode.jl requires SA or DA as first argument" ARGS
    exit(1)
end

@everywhere LinearAlgebra.BLAS.set_num_threads(1)
@info "using 1 threads on each worker"

M1=1024
M2=32
NVC=128*nworkers()

echo=show
#echo=display

#A=joGaussian(M1,M1)
#A=joDFT(m,planned=false)
A=joKron(joDFT(M2,planned=false)',joDFT(M2,planned=false))
#PA=joPMVdistributedLinOp(A,NVC)
PA=joPAdistributedLinOp(A,NVC)
show(PA)
PAd=joPAdistribute(PA)
show(PAd)
gPA=joPAgather(PA)
show(gPA)
show(PA*PAd)
show(gPA*PA*PAd)

in=rand(size(A,2),NVC)
@time pin=PAd*in
@time OS=A*in
@time OP=gPA*PA*PAd*in
println(("Serial-Parallel norm:",norm(OS-OP)))
@time dummy=PA*PAd*in
@time dummy=PA*pin
@time dummy=gPA*PA*pin

#echo(@benchmark PAd*in);println(" <- PAd*in")
echo(@benchmark A*in);println(" <- A*in")
echo(@benchmark gPA*PA*PAd*in);println(" <- gPA*PA*PAd*in")
#echo(@benchmark PA*PAd*in);println(" <- PA*PAd*in")
echo(@benchmark PA*pin);println(" <- PA*pin")
#echo(@benchmark gPA*PA*pin);println(" <- gPA*PA*pin")

nothing
