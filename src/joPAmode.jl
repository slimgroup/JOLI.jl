# operators
export joPAdistribute, joPMVdistributedLinOp, joPAgather
global joPAdistribute        = joSAdistribute
global joPMVdistributedLinOp = joSMVdistributedLinOp
global joPAgather            = joSAgather
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
        global joPAdistribute        = joSAdistribute
        global joPMVdistributedLinOp = joSMVdistributedLinOp
        global joPAgather            = joSAgather
        global palloc   = salloc
        global pzeros   = szeros
        global pones    = sones
        global prand    = srand
        global prandn   = srandn
    elseif m==:DA
        global joPAdistribute        = joDAdistribute
        global joPMVdistributedLinOp = joDMVdistributedLinOp
        global joPAgather            = joDAgather
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
