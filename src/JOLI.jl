############################################################
# JOLI module ##############################################
############################################################

"""
Julia Operator LIbrary (JOLI) is a package for creating
algebraic operators (currently linear only) and use them
in a way that tries to mimic the mathematical formulas of
basics algebra.

The package was created in SLIM group at the University of
British Columbia for their work in seismic imaging and modelling.

JOLI has a collection of methods that allow creating and
use of element-free operators, operators created from explicit
Matrices, and composing all of those into complex formulas that
are not explicitly executed until they act on the Vector or Matrix.
'*', '+', '-' and etc... operations are supported in any mathematically
valid combination of operators and vectors as long as vector is on the
right side of the operator. Composite operators can be
defined before they are used to act on vectors.

JOLI operators support operations like adjoint, transpose,
and conjugate for element-free operators provided that enough
functionality is provided when constructing JOLI operator.

JOLI operators support and enforce consistency of domain and range
data types for operators with both vectors acted upon and created
by operators. JOLI also has the functionality that allows easily to
switch precision of computations using global type definitions.

Contrary to other linear-operators Julia packages, JOLI operators act on
matrices as if those were column-wise collections of vectors. I.e.
JOLI operator does not treat explicit matrix on left side of '*' as
another operator, and will act on it immediately. Such behaviour
is convenient for implementation of Kronecker product.

"""
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
using DistributedArrays.SPMD
using LinearAlgebra
using InplaceOps
using IterativeSolvers
using FFTW
using NFFT
using Wavelets
using PyCall
using SpecialFunctions
using SpecialFunctions.ChainRulesCore

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
import Base.isequal, Base.isapprox
import Base.getindex


# what's imported from LinearAlgebra
import LinearAlgebra.norm, LinearAlgebra.AbstractQ
import LinearAlgebra.issymmetric, LinearAlgebra.ishermitian
import LinearAlgebra.mul!, LinearAlgebra.ldiv!

# what's imported from DistributedArrays
import DistributedArrays: DArray, distribute, dzeros, dones, dfill, drand, drandn
import DistributedArrays.SPMD: scatter

# what's imported from IterativeSolvers
import IterativeSolvers.Adivtype

# what's imported from ChainRulesCore
import  SpecialFunctions.ChainRulesCore.rrule

# extra exported methods
export deltype, reltype
export elements, hasinverse, issquare, istall, iswide, iscomplex, islinear, isadjoint, isequiv

# local array unions for serial operators
const LocalVector{T}=Union{Vector{T},SubArray{T,1,dA},
                           AbstractSparseVector{T}} where {T,dA<:Array{T}}
const LocalMatrix{T}=Union{Matrix{T},SubArray{T,2,dA},Transpose{T,Matrix{T}},Adjoint{T,Matrix{T}},
                           AbstractSparseMatrix{T}} where {T,dA<:Array{T}}
const LocalVecOrMat{T}=Union{LocalVector{T},LocalMatrix{T}} where T
const LocalArray{T}=Union{Array{T},SubArray{T,dA},
                          AbstractSparseArray{T}} where {T,dA<:Array{T}}

# constants
export joTol
global joTol = sqrt(eps())

###############################
# core operator implementations
###############################

# all type definitions
include("joTypes.jl")

# front matters other then types
include("joMiscTypesMethods.jl")
include("joUtils.jl")
include("joExternalPackages.jl")

# top abstract type
include("joAbstractOperator.jl")

# serial operators foundation
include("joAbstractLinearOperator.jl")
include("joAbstractFosterLinearOperator.jl")
include("joAbstractLinearOperatorInplace.jl")

# parallel operators foundation
include("joAbstractSAparallelToggleOperator.jl")
include("joAbstractDAparallelToggleOperator.jl")
include("joAbstractSAparallelLinearOperator.jl")
include("joAbstractDAparallelLinearOperator.jl")
include("joPAmode.jl")

# derived operator code goes into those
include("joMatrixConstructors.jl")
include("joLinearFunctionConstructors.jl")
include("joLinearOperatorConstructors.jl")
include("joMixedConstructors.jl")


# ChainRules
include("rrule.jl")

end # module
