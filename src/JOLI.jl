############################################################
# JOLI module ##############################################
############################################################

module JOLI

# what's being used
using Nullables
using Printf
using Random
using InteractiveUtils
using Distributed
using SparseArrays
using SharedArrays
using DistributedArrays
using LinearAlgebra
using InplaceOps
using IterativeSolvers
using FFTW
using NFFT
using Wavelets

# what's imported from Base
import Base.eltype
import Base.show, Base.display
import Base.size, Base.length
import Base.real, Base.imag, Base.conj
import Base.transpose, Base.adjoint
import Base.isreal
import Base.*, Base.\, Base.+, Base.-
import Base.Broadcast.broadcasted # Base.(.*), Base.(.\), Base.(.+), Base.(.-)
import Base.hcat, Base.vcat, Base.hvcat
import Base.inv

# what's imported from LinearAlgebra
import LinearAlgebra.norm
import LinearAlgebra.issymmetric, LinearAlgebra.ishermitian
import LinearAlgebra.mul!, LinearAlgebra.ldiv!

# what's imported from DistributedArrays
import DistributedArrays: DArray, distribute, dzeros, dones, dfill, drand, drandn

# what's imported from IterativeSolvers
import IterativeSolvers.Adivtype

# extra exported methods
export deltype, reltype
export elements, hasinverse, issquare, istall, iswide, iscomplex, islinear, isadjoint
export joLoosen

# array unions
const LocalVector{T}=Union{Vector{T},SubArray{T,1,dA},
                           AbstractSparseVector{T}} where {T,dA<:Array{T}}
const LocalMatrix{T}=Union{Matrix{T},SubArray{T,2,dA},#Diagonal{T,dA},Transpose{T},Adjoint{T},
                           AbstractSparseMatrix{T}} where {T,dA<:Array{T}}
const LocalVecOrMat{T}=Union{LocalVector{T},LocalMatrix{T}} where T
const LocalArray{T}=Union{Array{T},SubArray{T,dA},
                          AbstractSparseArray{T}} where {T,dA<:Array{T}}

# constants
export joTol
global joTol = sqrt(eps())

# core operator implementations
include("joTypes.jl")
include("joMiscTypesMethods.jl")
include("joUtils.jl")
include("joExternalPackages.jl")
include("joParallelToggles.jl")
include("joAbstractOperator.jl")
include("joAbstractLinearOperator.jl")
include("joAbstractFosterLinearOperator.jl")
include("joMatrixInplace.jl")
include("joLooseMatrixInplace.jl")
include("joLinearFunctionInplace.jl")
include("joLooseLinearFunctionInplace.jl")

# derived operator code goes into those
include("joMatrixConstructors.jl")
include("joLinearFunctionConstructors.jl")
include("joLinearOperatorConstructors.jl")
include("joMixedConstructors.jl")

# contributed domain-specific operators go here
include("contrib/Seismic.jl")

end # module
