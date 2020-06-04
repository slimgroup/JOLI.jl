using BenchmarkTools
using LinearAlgebra

get_blas_threads() = ccall((:openblas_get_num_threads64_, Base.libblas_name), Cint, ())

rand(1000,1000)*rand(1000,1000);
display(@benchmark rand(1000,1000)*rand(1000,1000);)
