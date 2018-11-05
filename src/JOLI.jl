############################################################
# JOLI module ##############################################
############################################################

module JOLI

# what's being used
using DistributedArrays
using IterativeSolvers
using InplaceOps
using NFFT
using Wavelets

# what's imported from Base
import Base.eltype
import Base.show, Base.showall, Base.display
import Base.size, Base.length
import Base.full
import Base.norm, Base.vecnorm
import Base.real, Base.imag, Base.conj
import Base.transpose, Base.ctranspose
import Base.isreal, Base.issymmetric, Base.ishermitian
import Base.*, Base.\, Base.+, Base.-
import Base.(.*), Base.(.\), Base.(.+), Base.(.-)
import Base.hcat, Base.vcat, Base.hvcat
import Base.inv
import Base.A_mul_B!, Base.At_mul_B!, Base.Ac_mul_B!
import Base.A_ldiv_B!, Base.At_ldiv_B!, Base.Ac_ldiv_B!

# what's imported from DistributedArrays
import DistributedArrays: DArray, distribute, dzeros, dones, dfill, drand, drandn

# what's imported from IterativeSolvers
import IterativeSolvers.Adivtype
# discarded IterativeSolvers.Amultype

# what's imported from InplaceOps
import InplaceOps.op_transpose, InplaceOps.op_ctranspose
import InplaceOps.Transpose, InplaceOps.CTranspose
import InplaceOps.mul!, InplaceOps.ldiv!

# extra exported methods
export deltype, reltype
export elements, hasinverse, issquare, istall, iswide, iscomplex, islinear, isadjoint
export joLoosen

# constants
export joTol
global joTol = sqrt(eps())

# package for each operator code goes here
include("joTypes.jl")
include("joTypesMiscMethods.jl")
include("joUtils.jl")
include("joExternalPackages.jl")
include("joAbstractOperator.jl")
include("joAbstractLinearOperator.jl")
include("joAbstractFosterLinearOperator.jl")
include("joAbstractLinearOperatorInplace.jl")
include("joLinearOperator.jl")
include("joMatrix.jl")
include("joLooseMatrix.jl")
include("joMatrixInplace.jl")
include("joLooseMatrixInplace.jl")
include("joLinearFunction.jl")
include("joLooseLinearFunction.jl")
include("joLinearFunctionInplace.jl")
include("joLooseLinearFunctionInplace.jl")
include("joMatrixConstructors.jl")
include("joLinearFunctionConstructors.jl")
include("joLinearOperatorConstructors.jl")

# contributed domain-specific operators go here
include("contrib/Seismic.jl")

end # module
