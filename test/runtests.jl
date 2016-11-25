using Base.Test
using JOLI

# write your own tests here
tic()
include("test_joMatrixSingle.jl")
include("test_joMatrixProduct.jl")
include("test_joLinearFunctionSingle.jl")
include("test_joLinearFunctionProduct.jl")
include("test_joLinearFunctionAndMatrixProduct.jl")
include("test_joKron.jl")
println("\nTest Total elapsed time: ",round(toq(),1),"s")
