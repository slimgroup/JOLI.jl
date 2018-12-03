# mask operator

export joMask
"""
Mask operator

    joMask(n,idx[;DDT=joFloat,RDT=DDT])

# Arguments
- n::Integer - size of square operator
- idx::Vector{Integer} - vector of true indecies

# Examples
- A=joMask(3,[1,3])
- A=joMask(3,[1,3];DDT=Float32)
- A=joMask(3,[1,3];DDT=Float32,RDT=Float64)

"""
function joMask(n::Integer,idx::Vector{VDT};DDT::DataType=joFloat,RDT::DataType=DDT) where {VDT<:Integer}
    l=length(idx)
    n>=l || throw(joLinearFunctionException("joMask length(idx) must be <= n"))
    n>=max(idx...) || throw(joLinearFunctionException("joMask max(idx) must be <= n"))
    mask=falses(n)
    mask[idx]=true
    return joLinearFunctionFwd(n,n,
        v1->jo_convert(RDT,mask.*v1,false),
        v2->jo_convert(DDT,mask.*v2,false),
        v3->jo_convert(DDT,mask.*v3,false),
        v4->jo_convert(RDT,mask.*v4,false),
        DDT,RDT;
        name="joMask",
        fMVok=true
        )
end
"""
Mask operator

    joMask(mask[;DDT=joFloat,RDT=DDT,makecopy=true])

# Arguments
- mask::BitArray{1} - BitArray mask of true indecies

# Examples
- mask=falses(3)
- mask[[1,3]]=true
- A=joMask(mask)
- A=joMask(mask;DDT=Float32)
- A=joMask(mask;DDT=Float32,RDT=Float64)

"""
function joMask(mask::BitArray{1};DDT::DataType=joFloat,RDT::DataType=DDT,makecopy::Bool=true)
    n=length(mask)
    mymask= makecopy ? Base.deepcopy(mask) : mask
    return joLinearFunctionFwd(n,n,
        v1->jo_convert(RDT,mymask.*v1,false),
        v2->jo_convert(DDT,mymask.*v2,false),
        v3->jo_convert(DDT,mymask.*v3,false),
        v4->jo_convert(RDT,mymask.*v4,false),
        DDT,RDT;
        name="joMask",
        fMVok=true
        )
end
