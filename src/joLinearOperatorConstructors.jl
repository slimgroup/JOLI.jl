############################################################
# joLinearOperator - miscaleneous constructor-only operators 
############################################################

# joKron
include("joLinearOperatorConstructors/joKron.jl")

# joCoreBlock
include("joLinearOperatorConstructors/joCoreBlock.jl")
# joCoreBlock derivatives: joBlock joBlockDiag joDict joStack
include("joLinearOperatorConstructors/joBlockConstructors.jl")

