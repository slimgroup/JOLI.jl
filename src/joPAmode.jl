# operators
export joPAdistribute, joPAdistributedLinOp, joPAgather
global joPAdistribute       = joSAdistribute
global joPAdistributedLinOp = joSAdistributedLinOp
global joPAgather           = joSAgather
# utilities
export palloc, pzeros, pones, prand, prandn
global palloc   = salloc
global pzeros   = szeros
global pones    = sones
global prand    = srand
global prandn   = srandn
global PAmode = :SA

export jo_PAmode
"""
jo_PAmode - set and query parallel mode

jo_PAmode(verbose=false) - query parallel mode

jo_PAmode([ :SA | :DA ]; verbose=false) - set parallel mode to respectively shared or distributed arrays

"""
function jo_PAmode(;verbose::Bool=false)
    if PAmode==:SA
        verbose && println("Parallel mode is set to :$PAmode (shared arrays)")
    elseif PAmode==:DA
        verbose && println("Parallel mode is set to :$PAmode (distributed arrays)")
    else
        error("Unknown parallel mode $m")
    end
    return PAmode
end
function jo_PAmode(m::Symbol;verbose::Bool=false)
    if m==:SA
        global joPAdistribute       = joSAdistribute
        global joPAdistributedLinOp = joSAdistributedLinOp
        global joPAgather           = joSAgather
        global palloc   = salloc
        global pzeros   = szeros
        global pones    = sones
        global prand    = srand
        global prandn   = srandn
        global PAmode = :SA
        verbose && println("Parallel mode is set to :$PAmode (shared arrays)")
    elseif m==:DA
        global joPAdistribute       = joDAdistribute
        global joPAdistributedLinOp = joDAdistributedLinOp
        global joPAgather           = joDAgather
        global palloc   = dalloc
        global pzeros   = dzeros
        global pones    = dones
        global prand    = drand
        global prandn   = drandn
        global PAmode = :DA
        verbose && println("Parallel mode is set to :$PAmode (distributed arrays)")
    else
        error("Unknown parallel mode $m")
    end
    return nothing
end
