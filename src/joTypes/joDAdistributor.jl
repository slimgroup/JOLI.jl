############################################################
## joDAdistributor
############################################################

export joDAdistributor

# type definition
"""
joDAdistributor type

See help for outer constructors for joDAdistributor.

"""
struct joDAdistributor
    dims::Dims          # dimensions of the array
    procs::Vector{Int}  # ids of workers to use
    chunks::Vector{Int} # number of chunks in each dimension
    idxs::Array{Tuple{Vararg{UnitRange{<:Integer}}}}
    cuts::Vector{Vector{<:Integer}}
    DT::DataType
end

