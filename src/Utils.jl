############################################################
# Utilities ################################################
############################################################

############################################################
## macros ##################################################

export @NF

"""
Nullable{Function} macro for null function

    @NF
"""
macro NF()
    return :(Nullable{Function}())
end

"""
Nullable{Function} macro for given function

    @NF ... | @NF(...)
"""
macro NF(fun::Expr)
    return :(Nullable{Function}($fun))
end

