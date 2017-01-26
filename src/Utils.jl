############################################################
# Utilities ################################################
############################################################

type joUtilsException <: Exception
    msg :: String
end

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
"""
Type of element of complex data type

    complex_eltype(dt::DataType)

# Example

- complex_eltype(Complex{Float32})

"""
function complex_eltype(dt::DataType)
    dt<:Complex || throw(joUtilsException("Input type must be Complex"))
    a=zero(dt)
    return complex_eltype(a)
end
