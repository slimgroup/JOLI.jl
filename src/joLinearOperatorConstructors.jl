############################################################
# joLinearOperator - subtype operators #####################
############################################################

# joKron
include("joLinearOperatorConstructors/joKron.jl")

# joCoreBlock
include("joLinearOperatorConstructors/joCoreBlock.jl")
# joCoreBlock derivatives: joBlockDiag joDict joStack joBlock
include("joLinearOperatorConstructors/joCoreBlockConstructors.jl")

############################################################
# joLinearOperator - constructor-only operators ############
############################################################

