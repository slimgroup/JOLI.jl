############################################################
# jo Types #################################################
############################################################

############################################################
# includes
include("joTypes/joMiscTypes.jl")
include("joTypes/joAbstractTypes.jl")
include("joTypes/joAbstractLinearOperator.jl")
    include("joTypes/joAbstractParallelableLinearOperator.jl")
include("joTypes/joAbstractFosterLinearOperator.jl")
    include("joTypes/joAbstractLinearOperatorInplace.jl")
include("joTypes/joPAsetup.jl")
include("joTypes/joAbstractSAparallelToggleOperator.jl")
include("joTypes/joAbstractSMVparallelLinearOperator.jl")
include("joTypes/joAbstractDAparallelToggleOperator.jl")
include("joTypes/joAbstractDMVparallelLinearOperator.jl")
