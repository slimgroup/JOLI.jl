############################################################
# Utilities ################################################
############################################################

struct joUtilsException <: Exception
    msg :: String
end


############################################################
## jo_eye/speye/full #######################################
export jo_eye, jo_speye, jo_full
"""
return identity array

    jo_eye(m::Integer,n::Integer=m)
    jo_eye(DT::DataType,m::Integer,n::Integer=m)

"""
@inline jo_eye(m::Integer,n::Integer=m) = Matrix{joFloat}(LinearAlgebra.I,m,n)
@inline jo_eye(DT::DataType,m::Integer,n::Integer=m) = Matrix{DT}(LinearAlgebra.I,m,n)
"""
return sparse identity array

    jo_speye(m::Integer,n::Integer=m)
    jo_speye(DT::DataType,m::Integer,n::Integer=m)

"""
@inline jo_speye(m::Integer,n::Integer=m) = sparse(one(joFloat)*LinearAlgebra.I,m,n)
@inline jo_speye(DT::DataType,m::Integer,n::Integer=m) = sparse(one(DT)*LinearAlgebra.I,m,n)
"""
return full array

    jo_full(A::AbstractArray)

"""
@inline jo_full(A::AbstractArray) = Array(A)

############################################################
## jo_method_error #########################################
function jo_method_error(O::joAbstractOperator,s::String)
    op_type=typeof(O)
    op_name=O.name
    @info "JOLI method error for operator:" op_name op_type
    throw(joUtilsException(s))
end
function jo_method_error(L,R,s::String)
    left_type=typeof(L)
    left_name=typeof(L)<:joAbstractOperator ? L.name : "non-JOLI"
    right_type=typeof(R)
    right_name=typeof(R)<:joAbstractOperator ? R.name : "non-JOLI"
    @info "JOLI method error for combination:" left_name left_type right_name right_type
    throw(joUtilsException(s))
end
function jo_method_error(L,M,R,s::String)
    left_type=typeof(L)
    left_name=typeof(L)<:joAbstractOperator ? L.name : "non-JOLI"
    mid_type=typeof(M)
    mid_name=typeof(M)<:joAbstractOperator ? M.name : "non-JOLI"
    right_type=typeof(R)
    right_name=typeof(R)<:joAbstractOperator ? R.name : "non-JOLI"
    @info "JOLI method error for combination:" left_name left_type mid_name mid_type right_name right_type
    throw(joUtilsException(s))
end

############################################################
## type tree ###############################################
export jo_type_tree
"""
Show type tree of JOLI operators, or any type with editional Type argument.

    jo_type_tree()
    jo_type_tree(Number)
"""
function jo_type_tree(top::Type=joAbstractOperator;bl::String="* ",in::String="  ",super::Bool=true)
    super ? println(bl,top," <: ",supertype(top)) : println(bl,top)
    ts = subtypes(top)
    if length(ts) > 0
        for t in ts
            T=Base.unwrap_unionall(t)
            type_tree(T;bl=in*bl,in=in,super=false)
        end
    end
end

############################################################
## default types ###########################################
export joInt, joFloat, joComplex
global joInt=Int64
global joFloat=Float64
global joComplex=ComplexF64
export jo_joInt_set, jo_joFloat_set, jo_joComplex_set, jo_jo32bit_set, jo_jo64bit_set, jo_joTypes_get
"""
set default integer type joInt

    function jo_joInt_set(DT::DataType=joInt)

"""
function jo_joInt_set(DT::DataType=joInt)
    global joInt=DT
    return joInt
end
"""
set default float type joFloat

    function jo_joFloat_set(DT::DataType=joFloat)

"""
function jo_joFloat_set(DT::DataType=joFloat)
    global joFloat=DT
    return joFloat
end
"""
set default complex type joComplex

    function jo_joComplex_set(DT::DataType=joComplex)

"""
function jo_joComplex_set(DT::DataType=joComplex)
    global joComplex=DT
    return joComplex
end
"""
set default type joInt, joFloat, joComplex to 32 bit

    function jo_jo32bit_set()

"""
function jo_jo32bit_set()
    global joInt=Int32
    global joFloat=Float32
    global joComplex=ComplexF32
    global joTol=sqrt(eps(Float32))
    return joInt, joFloat, joComplex
end
"""
set default type joInt, joFloat, joComplex to 64 bit

    function jo_jo64bit_set()

"""
function jo_jo64bit_set()
    global joInt=Int64
    global joFloat=Float64
    global joComplex=ComplexF64
    global joTol=sqrt(eps(Float64))
    return joInt, joFloat, joComplex
end

"""
get default types joInt, joFloat, joComplex

    function jo_joTypes_get()

"""
jo_joTypes_get() = (joInt, joFloat, joComplex)

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
## dafault iterative solver for square operator ############
global jo_iterative_solver4square = (A,v)->gmres(A,v)
export jo_iterative_solver4square_set
"""
Set default iterative solver for \\(jo,vec) and square jo

    jo_iterative_solver4square_set(f::Function)

Where f must take two arguments (jo,vec) and return vec.

# Example (using IterativeSolvers)
- jo_iterative_solver4square_set((A,v)->gmres(A,v))

"""
function jo_iterative_solver4square_set(f::Function)
    global jo_iterative_solver4square
    jo_iterative_solver4square = (A,b)->f(A,b)
end

############################################################
## dafault iterative solver for tall operator ##############
global jo_iterative_solver4tall = @joNF
export jo_iterative_solver4tall_set
"""
Set default iterative solver for \\(jo,vec) and tall jo

    jo_iterative_solver4tall_set(f::Function)

Where f must take two arguments (jo,vec) and return vec.

# Example
- jo_iterative_solver4tall_set((A,v)->tall_solve(A,v))

"""
function jo_iterative_solver4tall_set(f::Function)
    global jo_iterative_solver4tall
    jo_iterative_solver4tall = (A,b)->f(A,b)
end

############################################################
## dafault iterative solver for wide operator ##############
global jo_iterative_solver4wide = @joNF
export jo_iterative_solver4wide_set
"""
Set default iterative solver for \\(jo,vec) and wide jo

    jo_iterative_solver4wide_set(f::Function)

Where f must take two arguments (jo,vec) and return vec.

# Example
- jo_iterative_solver4wide_set((A,v)->wide_solve(A,v))

"""
function jo_iterative_solver4wide_set(f::Function)
    global jo_iterative_solver4wide
    jo_iterative_solver4wide = (A,b)->f(A,b)
end

############################################################
## smart precision type ####################################
export jo_precision_type
"""
Type of the real number or element type of complex number.

# Example
- jo_precision_type(1.)
- jo_precision_type(1+im*3.)
"""
jo_precision_type(x::Tx) where {ITx<:Number, Tx<:Union{Complex{ITx}, ITx}} = ITx

############################################################
## complex precision type ##################################
export jo_complex_eltype
"""
Type of element of complex scalar

    jo_complex_eltype(a::Complex)

# Example
- jo_complex_eltype(1.+im*1.)
- jo_complex_eltype(zero(ComplexF64))

"""
jo_complex_eltype(a::Complex{T}) where {T} = T
"""
Type of element of complex data type

    jo_complex_eltype(DT::DataType)

# Example
- jo_complex_eltype(ComplexF32)

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
- jo_type_mismatch_error_set(false) turns on warnings instead of errors
- jo_type_mismatch_error_set(true) reverts to errors

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
    @warn "Very, very bad idea! You are a sneaky fellow."
    @warn "Function jo_type_mismatch_warn_set is deprecated and will be removed in the future."
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
        jo_type_mismatch_warn && @warn "type mismatch: $DT1 vs. $DT2 in $where" 
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
- jo_convert(ComplexF32,rand(3))

"""
function jo_convert(DT::DataType,vin::AbstractArray{VT},warning::Bool=true) where {VT<:Integer}
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
function jo_convert(DT::DataType,vin::AbstractArray{VT},warning::Bool=true) where {VT<:AbstractFloat}
    DT==VT && return vin
    #println("jo_convert{VT<:AbstractFloat}")
    if !(DT<:Integer)
        vout=convert(AbstractArray{DT},vin)
    else
        throw(joUtilsException("jo_convert: Refused conversion from $VT to $DT."))
    end
    return vout
end
function jo_convert(DT::DataType,vin::AbstractArray{VT},warning::Bool=true) where {VT<:Complex}
    DT==VT && return vin
    #println("jo_convert{VT<:Complex}")
    if DT<:Complex
        vout=convert(AbstractArray{DT},vin)
    elseif DT<:AbstractFloat
        (warning && jo_convert_warn) && @warn "jo_convert: Inexact conversion from $VT to $DT. Dropping imaginary part."
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
- jo_convert(ComplexF32,rand())

"""
function jo_convert(DT::DataType,nin::NT,warning::Bool=true) where {NT<:Integer}
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
function jo_convert(DT::DataType,nin::NT,warning::Bool=true) where {NT<:AbstractFloat}
    DT==NT && return nin
    #println("jo_convert{NT<:AbstractFloat}")
    if !(DT<:Integer)
        nout=convert(DT,nin)
    else
        throw(joUtilsException("jo_convert: Refused conversion from $NT to $DT."))
    end
    return nout
end
function jo_convert(DT::DataType,nin::NT,warning::Bool=true) where {NT<:Complex}
    DT==NT && return nin
    #println("jo_convert{NT<:Complex}")
    if DT<:Complex
        nout=convert(DT,nin)
    elseif DT<:AbstractFloat
        (warning && jo_convert_warn) && @warn "jo_convert: Inexact conversion from $NT to $DT. Dropping imaginary part."
        nout=convert(DT,real(nin))
    else
        throw(joUtilsException("jo_convert: Refused conversion from $NT to $DT."))
    end
    return nout
end
