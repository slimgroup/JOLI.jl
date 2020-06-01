# restriction operator

export joRestriction
"""
    julia> op = joRestriction(n,idx;[makecopy=...,][DDT=...,][RDT=...,][name=...])

Restriction operator

# Signature

    function joRestriction(n::Integer,idx::LocalVector{idxdt};
        makecopy::Bool=true,DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joRestriction")
            where {idxdt<:Integer}

# Arguments

- `n`: number of columns
- `idx`: vector of indecies
- keywords
    - `makecopy`: make private copy of indecies vector
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Examples

    A=joRestriction(3,[1,3])

examples with DDT/RDT

    A=joRestriction(3,[1,3];DDT=Float32)
    A=joRestriction(3,[1,3];DDT=Float32,RDT=Float64)

"""
function joRestriction(n::Integer,idx::LocalVector{idxdt};
    makecopy::Bool=true,DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joRestriction") where {idxdt<:Integer}

    m::Int=length(idx)
    n>=m || throw(joLinearFunctionException("joRestriction: length(idx) must be <= n"))
    n>=max(idx...) || throw(joLinearFunctionException("joRestriction: max(idx) must be <= n"))
    myidx= makecopy ? Base.deepcopy(idx) : idx
    fwd=(x,m,i)->begin
            y= size(x,2)>1 ? x[i,:] : x[i]
            return y
        end
    rev=(x,n,i)->begin
            y= size(x,2)>1 ? zeros(eltype(x),n,size(x,2)) : zeros(eltype(x),n)
            size(x,2)>1 ? y[i,:]=x : y[i]=x
            return y
        end
    return joLinearFunctionFwd(m,n,
        v1->jo_convert(RDT,fwd(v1,m,myidx),false),
        v2->jo_convert(DDT,rev(v2,n,myidx),false),
        v3->jo_convert(DDT,rev(v3,n,myidx),false),
        v4->jo_convert(RDT,fwd(v4,m,myidx),false),
        DDT,RDT;
        name=name,
        fMVok=true
        )
end
