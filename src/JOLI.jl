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
import Base.hcat, Base.vcat
import Base.*, Base.\, Base.+, Base.-
import Base.(.*), Base.(.\), Base.(.+), Base.(.-)

# exported methods
export double

# constants
export joTol
joTol = 10e-12

# package for each operator code goes here
include("Utils.jl")
include("joAbstractOperator.jl")
include("joLinearOperator.jl")
include("joMatrix.jl")
include("joLinearFunction.jl")
include("joKron.jl")

end # module
