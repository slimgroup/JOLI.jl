############################################################
# JOLI module ##############################################
############################################################

module JOLI

# what's being used
using Nullables
using Printf
using InteractiveUtils
using LinearAlgebra
using SparseArrays
using DistributedArrays
using IterativeSolvers
using InplaceOps
using FFTW
using NFFT

# what's imported from Base
import Base.eltype
import Base.show, Base.display
import Base.size, Base.length
import Base.real, Base.imag, Base.conj
import Base.transpose, Base.adjoint
import Base.isreal
import Base.*, Base.\, Base.+, Base.-
#import Base.(.*), Base.(.\), Base.(.+), Base.(.-)
import Base.hcat, Base.vcat, Base.hvcat
import Base.inv

# what's imported from LinearAlgebra
import LinearAlgebra.norm
import LinearAlgebra.issymmetric, LinearAlgebra.ishermitian
import LinearAlgebra.A_mul_B!, LinearAlgebra.At_mul_B!, LinearAlgebra.Ac_mul_B!
import LinearAlgebra.A_ldiv_B!, LinearAlgebra.At_ldiv_B!, LinearAlgebra.Ac_ldiv_B!
import LinearAlgebra.mul!, LinearAlgebra.ldiv!

# what's imported from DistributedArrays
import DistributedArrays: DArray, distribute, dzeros, dones, dfill, drand, drandn

# what's imported from IterativeSolvers
import IterativeSolvers.Adivtype

# what's imported from InplaceOps
#import InplaceOps.op_transpose, InplaceOps.op_adjoint
#import InplaceOps.Transpose, InplaceOps.CTranspose

# extra exported methods
export deltype, reltype
export elements, hasinverse, issquare, istall, iswide, iscomplex, islinear, isadjoint
export joLoosen

# constants
export joTol
global joTol = sqrt(eps())

# core operator implementations
include("joTypes.jl")
include("joTypesMiscMethods.jl")
include("joUtils.jl")
include("joExternalPackages.jl")
include("joAbstractOperator.jl")
include("joAbstractLinearOperator.jl")
include("joAbstractFosterLinearOperator.jl")
include("joLinearOperator.jl")
include("joMatrix.jl")
include("joLooseMatrix.jl")
include("joMatrixInplace.jl")
include("joLooseMatrixInplace.jl")
include("joLinearFunction.jl")
include("joLooseLinearFunction.jl")
include("joLinearFunctionInplace.jl")
include("joLooseLinearFunctionInplace.jl")

# derived operator code goes into those
include("joMatrixConstructors.jl")
include("joLinearFunctionConstructors.jl")
include("joLinearOperatorConstructors.jl")

end # module
