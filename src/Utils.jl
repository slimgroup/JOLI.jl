############################################################
# macros ###################################################
############################################################

export @NF

# Nullable{Function} wrapper
macro NF()
    return :(Nullable{Function}())
end

# Nullable{Function} wrapper
macro NF(fun::Expr)
    return :(Nullable{Function}($fun))
end

