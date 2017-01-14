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

export complex_eltype

"""
Type of element of complex scalar

    complex_eltype(a::Complex)

# Example

- complex_eltype(1.+im*1.)

- complex_eltype(zero(Complex{Float64}))

"""
complex_eltype{T}(a::Complex{T}) = T
