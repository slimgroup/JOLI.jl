############################################################
# JOLI module ##############################################
############################################################

module JOLI

# what's being used

# what's imported
import Base.eltype
import Base.show, Base.showall, Base.display
import Base.size, Base.length
import Base.full
import Base.norm, Base.vecnorm
import Base.transpose, Base.ctranspose, Base.conj
import Base.isreal, Base.issymmetric, Base.ishermitian
import Base.*, Base.\, Base.+, Base.-
import Base.(.*), Base.(.\), Base.(.+), Base.(.-)
import Base.hcat, Base.vcat

# extra exported methods
export double, iscomplex, isinvertible, islinear, isadjoint

# constants
export joTol
joTol = 10e-12

# package for each operator code goes here
include("Utils.jl")
include("joAbstractOperator.jl")
include("joLinearOperator.jl")
include("joMatrix.jl")
include("joMatrixMiscConstructors.jl")
include("joLinearFunction.jl")
include("joLinearFunctionMiscConstructors.jl")
include("joKron.jl")

end # module
