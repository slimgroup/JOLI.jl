using Base.Test
using JOLI

jo_type_mismatch_error_set(false)
#JOLI.jo_type_mismatch_warn_set(false)

# write your own tests here
tic()
include("test_joMatrixSingle.jl")
include("test_joMatrixProduct.jl")
include("test_joMatrixSum.jl")
include("test_joMatrixDifference.jl")
include("test_joLinearFunctionSingle.jl")
include("test_joLinearFunctionProduct.jl")
include("test_joLinearFunctionSum.jl")
include("test_joLinearFunctionDifference.jl")
include("test_joLinearFunctionAndMatrixProduct.jl")
include("test_joLinearFunctionAndMatrixSum.jl")
include("test_joLinearFunctionAndMatrixDifference.jl")
include("test_joMatrixCons.jl")
include("test_joDFT.jl")
include("test_joDCT.jl")
include("test_joCurvelet2D.jl")
include("test_joKron.jl")
include("test_joCoreBlock.jl")
include("test_joBlockDiag.jl")
include("test_joDict.jl")
include("test_joStack.jl")
println("\nTest Total elapsed time: ",round(toq(),1),"s")
