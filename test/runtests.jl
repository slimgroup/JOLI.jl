using Test
using Libdl
using LinearAlgebra
using SparseArrays
using InplaceOps
using FFTW
using Wavelets
using PyCall
using JOLI

jo_type_mismatch_error_set(false)
#JOLI.jo_type_mismatch_warn_set(false)
verbose=false

# write your own tests here
stime=time()
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
include("test_joInplaceOps.jl")
include("test_joMatrixCons.jl")
include("test_joKron.jl")
include("test_joCoreBlock.jl")
include("test_joBlock.jl")
include("test_joBlockDiag.jl")
include("test_joDict.jl")
include("test_joStack.jl")
include("test_joDFT.jl")
include("test_joNFFT.jl")
include("test_joDCT.jl")
include("test_joDWT.jl")
include("test_joRomberg.jl")
include("test_joSWT.jl")
include("test_joSincInterp.jl")
include("test_joCurvelet2D.jl")
include("test_joCurvelet2DnoFFT.jl")
include("test_joExtend.jl")
include("test_joGaussian.jl")
include("test_joOuterProd.jl")
include("test_joJRM.jl")
etime=time()
dtime=etime-stime
println("\nTest Total elapsed time: ",round(dtime,digits=1),"s")
