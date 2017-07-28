# restriction operator

export joRestriction
"""
Restriction operator

    joRestriction(n::Integer,idx::AbstractVector{Int}[;DDT=Float64,RDT=DDT])

# Arguments
- n::Integer - number of rows
- idx::AbstractVector{Int} - vector of indecies

# Exmaple
- A=joRestriction(3,[1,3])
- A=joRestriction(3,[1,3];DDT=Float32)
- A=joRestriction(3,[1,3];DDT=Float32,RDT=Float64)

"""
function joRestriction(n::Integer,idx::AbstractVector{Int};DDT::DataType=Float64,RDT::DataType=DDT)
    m::Int=length(idx)
    n>=m || throw(joLinearFunctionException("joRestriction: length(idx) must be <= n"))
    n>=max(idx...) || throw(joLinearFunctionException("joRestriction: max(idx) must be <= n"))
    fwd=(x,m,idx)->begin
            y= size(x,2)>1 ? x[idx,:] : x[idx]
            return y
        end
    rev=(x,n,idx)->begin
            y= size(x,2)>1 ? zeros(eltype(x),n,size(x,2)) : zeros(eltype(x),n)
            size(x,2)>1 ? y[idx,:]=x : y[idx]=x
            return y
        end
    joLinearFunctionFwd(m,n,
        v1->jo_convert(RDT,fwd(v1,m,idx),false),
        v2->jo_convert(DDT,rev(v2,n,idx),false),
        v3->jo_convert(DDT,rev(v3,n,idx),false),
        v4->jo_convert(RDT,fwd(v4,m,idx),false),
        DDT,RDT;
        name="joRestriction",
        fMVok=true
        )
end
