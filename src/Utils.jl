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

export jo_complex_eltype

"""
Type of element of complex scalar

    jo_complex_eltype(a::Complex)

# Example

- jo_complex_eltype(1.+im*1.)

- jo_complex_eltype(zero(Complex{Float64}))

"""
jo_complex_eltype{T}(a::Complex{T}) = T
"""
Type of element of complex data type

    jo_complex_eltype(dt::DataType)

# Example

- jo_complex_eltype(Complex{Float32})

"""
function jo_complex_eltype(dt::DataType)
    dt<:Complex || throw(joUtilsException("Input type must be Complex"))
    a=zero(dt)
    return jo_complex_eltype(a)
end
