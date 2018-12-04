############################################################
## types supporting conversion from local to SA/DA arrays
############################################################

############################################################
## joPAsetup

export joPAsetup, joPAsetupException

# type definition
"""
joPAsetup type

# Atributes

- name::String        # name for identification
- dims::Dims          # dimensions of the array
- procs::Vector{Int}  # ids of workers to use
- chunks::Vector{Int} # number of chunks in each dimension
- idxs::Array{Tuple{Vararg{UnitRange{<:Integer}}}}
- cuts::Vector{Vector{<:Integer}}
- DT::DataType

See help for outer constructors for joPAsetup.

"""
struct joPAsetup
    name::String        # name for identification
    dims::Dims          # dimensions of the array
    procs::Vector{Int}  # ids of workers to use
    chunks::Vector{Int} # number of chunks in each dimension
    idxs::Array{Tuple{Vararg{UnitRange{<:Integer}}}}
    cuts::Vector{Vector{<:Integer}}
    DT::DataType
end

# type exception
struct joPAsetupException <: Exception
    msg :: String
end

