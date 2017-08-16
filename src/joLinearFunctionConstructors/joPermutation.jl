export joPermutation
    
function joPermutation{T<:Integer}(perm::AbstractVector{T}; DDT::DataType=joFloat,RDT::DataType=DDT)
    n = length(perm)
    minimum(perm)==1 && maximum(perm)==n || throw(ArgumentError("perm must have values between 1 and n"))
    length(unique(perm))==n || throw(ArgumentError("perm must have unique values"))
    invp = invperm(perm)
    forw = v->v[perm,:]
    reverse = v->v[invp,:]
    return joLinearFunctionAll(n,n,
                               forw,
                               reverse,
                               reverse,
                               forw,
                               reverse,
                               forw,
                               forw,
                               reverse,DDT,RDT,name="joPermutation",fMVok=true,iMVok=true)
end

