############################################################
# joMatrix - miscaleneous constructor-only operators #######
############################################################

# identity operators: joDirac
include("joMatrixConstructors/joDirac.jl")

# identity operators: joEye
include("joMatrixConstructors/joEye.jl")

# diagonal operators: joDiag
include("joMatrixConstructors/joDiag.jl")

# matrix of ones
include("joMatrixConstructors/joOnes.jl")

# matrix of zeros
include("joMatrixConstructors/joZeros.jl")

# matrix of constants
include("joMatrixConstructors/joConstants.jl")

# vector conversion operators: joReal joImag joConj
include("joMatrixConstructors/joVecConvert.jl")

# sinc interpolation
include("joMatrixConstructors/joSincInterp.jl")

# 1D linear interpolation
include("joMatrixConstructors/joLinInterp1D.jl")
