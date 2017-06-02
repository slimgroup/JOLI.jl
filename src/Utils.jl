############################################################
# Utilities ################################################
############################################################

type joUtilsException <: Exception
    msg :: String
end

############################################################
## macros ##################################################

export @joNF

"""
Nullable{Function} macro for null function

    @joNF
"""
macro joNF()
    return :(Nullable{Function}())
end

"""
Nullable{Function} macro for given function

    @joNF ... | @joNF(...)
"""
macro joNF(fun::Expr)
    return :(Nullable{Function}($fun))
end

############################################################
## dafault iterative solver ################################
global jo_default_iterative_solver = (A,v)->gmres(A,v)[1]
export jo_default_iterative_solver_set
"""
Set default iterative solver for \(jo,vec)

    jo_default_iterative_solver_set(f::Function)

Where f must take two arguments (op,vec) and return vec.

# Example (using IterativeSolvers)
- jo_default_iterative_solver_set((A,v)->lsqr(A,v)[1])

"""
function jo_default_iterative_solver_set(f::Function)
    global jo_default_iterative_solver
    jo_default_iterative_solver = (A,b)->f(A,b)
end

############################################################
## complex precision type ##################################

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

############################################################
## type checks #############################################

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

############################################################
## type conversion utlis ###################################

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
Convert vector to new type

    jo_convert(DT::DataType,v::AbstractArray,warning::Bool=true)

# Limitations
- converting integer array to shorter representation will throw an error
- converting float/complex array to integer will throw an error
- converting from complex to float drops immaginary part and issues warning;
  use jo_convert_warn_set(false) to turn off the warning

# Example
- jo_convert(Complex{Float32},rand(3))

"""
function jo_convert{VT<:Integer}(DT::DataType,vin::AbstractArray{VT},warning::Bool=true)
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
function jo_convert{VT<:AbstractFloat}(DT::DataType,vin::AbstractArray{VT},warning::Bool=true)
    DT==VT && return vin
    #println("jo_convert{VT<:AbstractFloat}")
    if !(DT<:Integer)
        vout=convert(AbstractArray{DT},vin)
    else
        throw(joUtilsException("jo_convert: Refused conversion from $VT to $DT."))
    end
    return vout
end
function jo_convert{VT<:Complex}(DT::DataType,vin::AbstractArray{VT},warning::Bool=true)
    DT==VT && return vin
    #println("jo_convert{VT<:Complex}")
    if DT<:Complex
        vout=convert(AbstractArray{DT},vin)
    elseif DT<:AbstractFloat
        (warning && jo_convert_warn) && warn("jo_convert: Inexact conversion from $VT to $DT. Dropping imaginary part.")
        vout=convert(AbstractArray{DT},real(vin))
    else
        throw(joUtilsException("jo_convert: Refused conversion from $VT to $DT."))
    end
    return vout
end
"""
Convert number to new type

    jo_convert(DT::DataType,n::Number,warning::Bool=true)

# Limitations
- converting integer number to shorter representation will throw an error
- converting float/complex number to integer will throw an error
- converting from complex to float drops immaginary part and issues warning;
  use jo_convert_warn_set(false) to turn off the warning

# Example
- jo_convert(Complex{Float32},rand())

"""
function jo_convert{NT<:Integer}(DT::DataType,nin::NT,warning::Bool=true)
    DT==NT && return nin
    #println("jo_convert{NT<:Integer}")
    if DT<:Integer
        if typemax(DT)>typemax(NT)
            nout=convert(DT,nin)
        else
            throw(joUtilsException("jo_convert: Refused conversion from $NT to $DT."))
        end
    else
        nout=convert(DT,nin)
    end
    return nout
end
function jo_convert{NT<:AbstractFloat}(DT::DataType,nin::NT,warning::Bool=true)
    DT==NT && return nin
    #println("jo_convert{NT<:AbstractFloat}")
    if !(DT<:Integer)
        nout=convert(DT,nin)
    else
        throw(joUtilsException("jo_convert: Refused conversion from $NT to $DT."))
    end
    return nout
end
function jo_convert{NT<:Complex}(DT::DataType,nin::NT,warning::Bool=true)
    DT==NT && return nin
    #println("jo_convert{NT<:Complex}")
    if DT<:Complex
        nout=convert(DT,nin)
    elseif DT<:AbstractFloat
        (warning && jo_convert_warn) && warn("jo_convert: Inexact conversion from $NT to $DT. Dropping imaginary part.")
        nout=convert(DT,real(nin))
    else
        throw(joUtilsException("jo_convert: Refused conversion from $NT to $DT."))
    end
    return nout
end
