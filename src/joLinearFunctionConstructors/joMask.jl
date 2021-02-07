# mask operator

export joMask
"""
    julia> op = joMask(n,idx;[DDT=...,][RDT=...,][name=...])

Mask operator with index array

# Signature

    function joMask(n::Integer,idx::Vector{VDT};
        DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joMask") where {VDT<:Integer}

# Arguments

- `n`: size of square operator
- `idx`: vector of true indecies
- keywords
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Examples

    A=joMask(3,[1,3])

examples with DDT/RDT

    A=joMask(3,[1,3]; DDT=Float32)
    A=joMask(3,[1,3]; DDT=Float32,RDT=Float64)

"""
function joMask(n::Integer,idx::Vector{VDT};
    DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joMask") where {VDT<:Integer}

    l=length(idx)
    n>=l || throw(joLinearFunctionException("joMask length(idx) must be <= n"))
    n>=max(idx...) || throw(joLinearFunctionException("joMask max(idx) must be <= n"))
    mask=falses(n)
    mask[idx].=true
    return joLinearFunctionFwd(n,n,
        v1->jo_convert(RDT,mask.*v1,false),
        v2->jo_convert(DDT,mask.*v2,false),
        v3->jo_convert(DDT,mask.*v3,false),
        v4->jo_convert(RDT,mask.*v4,false),
        DDT,RDT;
        name=name,
        fMVok=true
        )
end
"""
    julia> op = joMask(mask;[makecopy=...,][DDT=...,][RDT=...,][name=...])

Mask operator with BitArray mask

# Signature

    function joMask(mask::BitArray{1};
        makecopy::Bool=true,DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joMask")

# Arguments
- `mask`: BitArray mask of true indecies
- keywords
    - `makecopy`: copy mask array
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Examples

define BitArray mask and operator

    mask=falses(3)
    mask[[1,3]]=true

    A=joMask(mask)

examples with RDT/DDT

    A=joMask(mask; DDT=Float32)
    A=joMask(mask; DDT=Float32,RDT=Float64)

"""
function joMask(mask::BitArray{1};
    makecopy::Bool=true,DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joMask")

    n=length(mask)
    mymask= makecopy ? Base.deepcopy(mask) : mask
    return joLinearFunctionFwd(n,n,
        v1->jo_convert(RDT,mymask.*v1,false),
        v2->jo_convert(DDT,mymask.*v2,false),
        v3->jo_convert(DDT,mymask.*v3,false),
        v4->jo_convert(RDT,mymask.*v4,false),
        DDT,RDT;
        name=name,
        fMVok=true
        )
end
