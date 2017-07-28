# mask operator

export joMask
"""
Mask operator

    joMask(n::Integer,idx::AbstractVector{Int}[;DDT=Float64,RDT=DDT])

# Arguments
- n::Integer - number of rows
- idx::AbstractVector{Int} - vector of true indecies

# Exmaple
- A=joMask(3,[1,3])
- A=joMask(3,[1,3];DDT=Float32)
- A=joMask(3,[1,3];DDT=Float32,RDT=Float64)

"""
function joMask(n::Integer,idx::AbstractVector{Int};DDT::DataType=Float64,RDT::DataType=DDT)
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

    joMask(mask::BitArray{1}[;DDT=Float64,RDT=DDT])

# Arguments
- mask::BitArray{1} - BitArray mask

# Exmaple
- mask=falses(3)
- mask[[1,3]]=true
- A=joMask(mask)
- A=joMask(mask;DDT=Float32)
- A=joMask(mask;DDT=Float32,RDT=Float64)

"""
function joMask(mask::BitArray{1};DDT::DataType=Float64,RDT::DataType=DDT)
    n=length(mask)
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
