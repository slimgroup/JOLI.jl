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
    DT<:Complex || throw(joUtilsException("jo_complex_eltype: Input type must be Complex"))
    a=zero(DT)
    return jo_complex_eltype(a)
end

export jo_check_type_match, jo_type_mismatch_error_set
global jo_type_mismatch_warn=false
global jo_type_mismatch_error=true
"""
Toggle between warning and error for type mismatch

    jo_type_mismatch_error_set(flag::Bool)

# Examples

- jo_type_mismatch_error_set(true) turns on error

- jo_type_mismatch_error_set(false) reverts to warnings

"""
function jo_type_mismatch_error_set(flag::Bool)
    global jo_type_mismatch_warn
    global jo_type_mismatch_error
    if flag
        jo_type_mismatch_warn=false
        jo_type_mismatch_error=true
    else
        jo_type_mismatch_warn=true
        jo_type_mismatch_error=false
    end
    return
end
function jo_type_mismatch_warn_set(flag::Bool)
    global jo_type_mismatch_warn
    println("Very, very bad idea! You are a sneaky fellow.")
    jo_type_mismatch_warn=flag
    return
end
"""
Check type match

    jo_check_type_match(DT1::DataType,DT2::DataType,where::String)

The bahaviour of the function while types do not match depends on
values of jo_type_mismatch_warn and jo_type_mismatch_error flags.
Use jo_type_mismatch_error_set to toggle those flags from warning
mode to error mode.

# EXAMPLE

- jo_check_type_match(Float32,Float64,"my session")

"""
function jo_check_type_match(DT1::DataType,DT2::DataType,where::String)
    if !(DT1==DT2)
        jo_type_mismatch_error && throw(joUtilsException("type mismatch: $DT1 vs. $DT2 in $where"))
        jo_type_mismatch_warn && warn("type mismatch: $DT1 vs. $DT2 in $where")
    end
    return
end

export jo_convert, jo_convert_warn_set
global jo_convert_warn=true
"""
Set warning mode for jo_convert

    jo_convert_warn_set(flag::Bool)

# Example

- jo_convert_warn_set(false) turns of the warnings

"""
function jo_convert_warn_set(flag::Bool)
    global jo_convert_warn
    jo_convert_warn=flag
    return
end

"""
Type of element of complex data type

    jo_convert(v::AbstractArray,DT::DataType)

# Limitations

- converting integer array to shorter representation will throw an error

- converting float/complex array to integer will throw an error

- converting from complex to float drops immaginary part and issues warning;
  use jo_convert_warn_set(false) to turn off the warning

# Example

- jo_convert(rand(3),Complex{Float32})

"""
function jo_convert{VT<:Integer}(vin::AbstractArray{VT},DT::DataType)
    DT==VT && return vin
    #println("jo_convert{VT<:Integer}")
    if DT<:Integer
        if typemax(DT)>typemax(VT)
            vout=convert(AbstractArray{DT},vin)
        else
            throw(joUtilsException("jo_convert: Refused conversion from $VT to $DT."))
        end
    else
        vout=convert(AbstractArray{DT},vin)
    end
    return vout
end
function jo_convert{VT<:AbstractFloat}(vin::AbstractArray{VT},DT::DataType)
    DT==VT && return vin
    #println("jo_convert{VT<:AbstractFloat}")
    if !(DT<:Integer)
        vout=convert(AbstractArray{DT},vin)
    else
        throw(joUtilsException("jo_convert: Refused conversion from $VT to $DT."))
    end
    return vout
end
function jo_convert{VT<:Complex}(vin::AbstractArray{VT},DT::DataType)
    DT==VT && return vin
    #println("jo_convert{VT<:Complex}")
    if DT<:Complex
        vout=convert(AbstractArray{DT},vin)
    elseif DT<:AbstractFloat
        jo_convert_warn && warn("jo_convert: Inexact conversion from $VT to $DT. Dropping imaginary part.")
        vout=convert(AbstractArray{DT},real(vin))
    else
        throw(joUtilsException("jo_convert: Refused conversion from $VT to $DT."))
    end
    return vout
end
