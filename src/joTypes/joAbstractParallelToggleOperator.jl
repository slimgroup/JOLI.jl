############################################################
## types supporting conversion from local to DA arrays
############################################################

############################################################
## joDAdistributor

export joDAdistributor, joDAdistributorException

# type definition
"""
joDAdistributor type

# Atributes

- name::String        # name for identification
- dims::Dims          # dimensions of the array
- procs::Vector{Int}  # ids of workers to use
- chunks::Vector{Int} # number of chunks in each dimension
- idxs::Array{Tuple{Vararg{UnitRange{<:Integer}}}}
- cuts::Vector{Vector{<:Integer}}
- DT::DataType

See help for outer constructors for joDAdistributor.

"""
struct joDAdistributor
    name::String        # name for identification
    dims::Dims          # dimensions of the array
    procs::Vector{Int}  # ids of workers to use
    chunks::Vector{Int} # number of chunks in each dimension
    idxs::Array{Tuple{Vararg{UnitRange{<:Integer}}}}
    cuts::Vector{Vector{<:Integer}}
    DT::DataType
end

# type exception
struct joDAdistributorException <: Exception
    msg :: String
end

############################################################
# joDA{distribute,gather} ##################################

export joDAdistribute, joDAgather, joDAtoggleException

# type definition
"""
    joDAdistribute is DAarray toggle type & constructor

    !!! Do not use it to create the operators
    !!! Use joMatrix and joLinearFunction constructors

"""
struct joDAdistribute{DDT<:Number,RDT<:Number,N} <: joAbstractParallelToggleOperator{DDT,RDT,N}
    name::String
    m::Integer
    n::Integer
    fop::Function    # forward
    fop_T::Function  # transpose
    fop_A::Function  # adjoint
    fop_C::Function  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    dst_out::joDAdistributor   # output distributor
    gclean::Bool               # clean input vector post gathering
end
"""
    joDAgather is DAarray toggle type & constructor

    !!! Do not use it to create the operators
    !!! Use joMatrix and joLinearFunction constructors

"""
struct joDAgather{DDT<:Number,RDT<:Number,N} <: joAbstractParallelToggleOperator{DDT,RDT,N}
    name::String
    m::Integer
    n::Integer
    fop::Function    # forward
    fop_T::Function  # transpose
    fop_A::Function  # adjoint
    fop_C::Function  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    dst_in::joDAdistributor    # input distributor
    gclean::Bool               # clean input vector post gathering
end

# toggle unions
const joDAtoggle{D,T,N}=Union{joDAdistribute{D,T,N},joDAgather{D,T,N}} where {D,T,N}

# type exception
struct joDAtoggleException <: Exception
    msg :: String
end

