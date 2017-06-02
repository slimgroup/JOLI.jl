############################################################
# JOLI module ##############################################
############################################################

module JOLI

# what's being used
using IterativeSolvers
using NFFT

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

# what's imported from IterativeSolvers
import IterativeSolvers.Adivtype, IterativeSolvers.Amultype

# extra exported methods
export deltype, reltype
export elements, hasinverse, issquare, iscomplex, islinear, isadjoint

# constants
export joTol
joTol = 10e-12

# package for each operator code goes here
include("MiscTypes.jl")
include("Utils.jl")
include("joAbstractOperator.jl")
include("joLinearOperator.jl")
include("joMatrix.jl")
include("joLinearFunction.jl")
include("joMatrixConstructors.jl")
include("joLinearFunctionConstructors.jl")
include("joLinearOperatorConstructors.jl")

end # module
