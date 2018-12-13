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

export jo_PAmode
"""

"""
function jo_PAmode(m::Symbol)
    if m==:SA
        global joPAdistribute       = joSAdistribute
        global joPAdistributedLinOp = joSAdistributedLinOp
        global joPAgather           = joSAgather
        global palloc   = salloc
        global pzeros   = szeros
        global pones    = sones
        global prand    = srand
        global prandn   = srandn
    elseif m==:DA
        global joPAdistribute       = joDAdistribute
        global joPAdistributedLinOp = joDAdistributedLinOp
        global joPAgather           = joDAgather
        global palloc   = dalloc
        global pzeros   = dzeros
        global pones    = dones
        global prand    = drand
        global prandn   = drandn
    else
        error("Unknown parallel mode $m")
    end
    nothing
end
