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

    jo_complex_eltype(DT::DataType)

# Example

- jo_complex_eltype(Complex{Float32})

"""
function jo_complex_eltype(DT::DataType)
    DT<:Complex || throw(joUtilsException("Input type must be Complex"))
    a=zero(DT)
    return jo_complex_eltype(a)
end

export jo_convert_type, jo_convert_warn_set
global jo_convert_warn=true
"""
Set warning mode for jo_convert_type

    jo_convert_warn_set(flag::Bool)

# Example

- jo_convert_warn_set(false) turns of the warnings

"""
function jo_convert_warn_set(flag::Bool)
    global jo_convert_warn
    jo_convert_warn=flag
end

"""
Type of element of complex data type

    jo_convert_type(v::AbstractArray,DT::DataType)

# Limitations

- converting integer array to shorter representation will throw an error

- converting float/complex array to integer will throw an error

- converting from complex to float drops immaginary part and issues warning;
  use jo_convert_warn_set(false) to turn off the warning

# Example

- jo_convert_type(rand(3),Complex{Float32})

"""
function jo_convert_type{VT<:Integer}(vin::AbstractArray{VT},DT::DataType)
    DT==VT && return vin
    #println("jo_convert_type{VT<:Integer}")
    if DT<:Integer
        if typemax(DT)>typemax(VT)
            vout=convert(AbstractArray{DT},vin)
        else
            throw(joUtilsException("jo_convert_type: FATAL ERROR: refused conversion from $VT to $DT."))
        end
    else
        vout=convert(AbstractArray{DT},vin)
    end
    return vout
end
function jo_convert_type{VT<:AbstractFloat}(vin::AbstractArray{VT},DT::DataType)
    DT==VT && return vin
    #println("jo_convert_type{VT<:AbstractFloat}")
    if !(DT<:Integer)
        vout=convert(AbstractArray{DT},vin)
    else
        throw(joUtilsException("jo_convert_type: FATAL ERROR: refused conversion from $VT to $DT."))
    end
    return vout
end
function jo_convert_type{VT<:Complex}(vin::AbstractArray{VT},DT::DataType)
    DT==VT && return vin
    #println("jo_convert_type{VT<:Complex}")
    if DT<:Complex
        vout=convert(AbstractArray{DT},vin)
    elseif DT<:AbstractFloat
        jo_convert_warn && warn("jo_convert_type: WARNING: Inexact conversion from $VT to $DT. Dropping imaginary part.")
        vout=convert(AbstractArray{DT},real(vin))
    else
        throw(joUtilsException("jo_convert_type: FATAL ERROR: refused conversion from $VT to $DT."))
    end
    return vout
end
