using JOLI
using LinearAlgebra
using BenchmarkTools

get_blas_threads() = ccall((:openblas_get_num_threads64_, Base.libblas_name), Cint, ())

A=joDCT(32)
B=joDCT(32)
AB=joKron(A,B)
println(("jlThreads/ompThreads",Threads.nthreads(),get_blas_threads()))
display(@benchmark elements(AB)); println()

A=joGaussian(32)
B=joGaussian(32)
AB=joKron(A,B)
println(("jlThreads/ompThreads",Threads.nthreads(),get_blas_threads()))
display(@benchmark elements(AB)); println()
