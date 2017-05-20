############################################################
# joLinearFunction - miscaleneous constructor-only operators 
############################################################

# FFT operators: joDFT
include("joLinearFunctionConstructors/joDFT.jl")

# DCT operators: joDCT
include("joLinearFunctionConstructors/joDCT.jl")

# CurveLab operators: joCurvelet2D joCurvelet2DnoFFT
include("joLinearFunctionConstructors/joCurvelet2D.jl")
include("joLinearFunctionConstructors/joCurvelet2DnoFFT.jl")

# Padding/extension operators: joExtension
include("joLinearFunctionConstructors/joExtension.jl")
