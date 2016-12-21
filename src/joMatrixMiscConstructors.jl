############################################################
# joMatrix - miscaleneous constructor-only operators #######
############################################################

# identity operators: joDirac
include("MatrixMiscConstructors/joDirac.jl")

# identity operators: joEye
include("MatrixMiscConstructors/joEye.jl")

# diagonal operators: joDiag
include("MatrixMiscConstructors/joDiag.jl")

# matrix of ones
include("MatrixMiscConstructors/joOnes.jl")

# matrix of zeros
include("MatrixMiscConstructors/joZeros.jl")

# vector conversion operators: joReal joImag joConj
include("MatrixMiscConstructors/joVecConvert.jl")

