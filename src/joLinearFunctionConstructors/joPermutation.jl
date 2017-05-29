export joPermutation

function apply_permutation{T<:Integer,DDT<:Number}(v::AbstractVector{DDT},n::T,perm::AbstractVector{T})
    lenv::T = length(v)
    nrhs::T = lenv/n
    w = reshape(v,n,nrhs)
    w = w[perm,:]
    return vec(w)
end
    
function joPermutation{T<:Integer}(perm::AbstractVector{T}; DDT::DataType=Float64,RDT::DataType=DDT)
    n = length(perm)
    minimum(perm)==1 && maximum(perm)==n || throw(ArgumentError("perm must have values between 1 and n"))
    length(unique(perm))==n || throw(ArgumentError("perm must have unique values"))
    invp = invperm(perm)
    forw = v->apply_permutation(v,n,perm)
    reverse = v->apply_permutation(v,n,invp)
    return joLinearFunctionAll(n,n,
                               forw,
                               reverse,
                               reverse,
                               forw,
                               reverse,
                               forw,
                               forw,
                               reverse,DDT,RDT,name="joPermutation")
end

