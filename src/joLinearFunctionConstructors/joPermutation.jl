export joPermutation
    
"""
    julia> op = joPermutation(perm;[DDT=...,][RDT=...,][name=...])

Permiutation operator

# Signature

    function joPermutation(perm::LocalVector{T};
        DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joPermutation") where {T<:Integer}

# Arguments

- `perm`: permiutation vector
- keywords
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Examples

    joPermutation([3, 1, 2])

examples with DDT/RDT

    joPermutation([3, 1, 2]; DDT=Float32)
    joPermutation([3, 1, 2]; DDT=Float32,RDT=Float64)

"""
function joPermutation(perm::LocalVector{T};
    DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joPermutation") where {T<:Integer}

    n = length(perm)
    minimum(perm)==1 && maximum(perm)==n || throw(ArgumentError("perm must have values between 1 and n"))
    length(unique(perm))==n || throw(ArgumentError("perm must have unique values"))
    invp = invperm(perm)
    forw = v->v[perm,:]
    reverse = v->v[invp,:]
    return joLinearFunctionAll(n,n,
                               forw, reverse, reverse, forw,
                               reverse, forw, forw, reverse,
                               DDT,RDT,name=name,fMVok=true,iMVok=true)
end

