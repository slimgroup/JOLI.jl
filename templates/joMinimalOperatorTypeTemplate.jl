############################################################
# For advanced JOLI users who want to create their own types
############################################################
# joMyOperator #########################################
############################################################
# based in joLinearFunction
#   shows minimum type and the set of methods needed
#   to fully work with other joAbstractLinearOperator types
#
#   un-implemented methods are defined in
#       joAbstractLinearOperator/base_functions.jl
############################################################

export joMyOperator, joMyOperatorException

############################################################
## type definition

"""
joMyOperator type

# TYPE PARAMETERS
- DDT::DataType : domain DataType
- RDT::DataType : range DataType

# FIELDS
- name::String : given name
- m::Integer : # of rows
- n::Integer : # of columns
- fop::Function              # forward
- iop::Nullable{Function}    # inverse

"""
immutable joMyOperator{DDT<:Number,RDT<:Number} <: joAbstractLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function              # forward
    iop::Nullable{Function}    # inverse
end

############################################################
## type exceptions

type joMyOperatorException <: Exception
    msg :: String
end

############################################################
## joMyOperator - outer constructors

"""
joMyOperator outer constructor

    joMyOperator(m::Integer,n::Integer,
        fop::Function,...,
        iop::Function,...,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joMyOperator")

Look up argument names in help to joMyOperator type.

# Notes
- the developer is responsible for ensuring that used functions take/return correct DDT/RDT

"""
joMyOperator(m::Integer,n::Integer,
    fop::Function,...,
    iop::Function,...,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joMyOperatorAll") =
        joMyOperator{DDT,RDT}(name,m,n,
            fop,...,
            iop,...,
            )

############################################################
## joMyOperator - overloaded Base functions

# conj(jo)
function conj{DDT,RDT}(A::joMyOperator{DDT,RDT})
...
end

# transpose(jo)
function transpose{DDT,RDT}(A::joMyOperator{DDT,RDT})
...
end

# adjoint(jo)
function adjoint{DDT,RDT}(A::joMyOperator{DDT,RDT})
...
end

############################################################
## overloaded Base *(...jo...)

# *(jo,mvec)
function *{ADDT,ARDT,mvDT<:Number}(A::joMyOperator{ADDT,ARDT},mv::AbstractMatrix{mvDT})
...
end

# *(jo,vec)
function *{ADDT,ARDT,vDT<:Number}(A::joMyOperator{ADDT,ARDT},v::AbstractVector{vDT})
...
end

############################################################
## overloaded Base -(...jo...)

# -(jo)
function -{DDT,RDT}(A::joMyOperator{DDT,RDT})
...
end

