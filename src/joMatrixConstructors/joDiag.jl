# diagonal operators: joDiag

export joDiag
"""
    julia> op = joDiag(v;[makecopy=...,][DDT=...,][RDT=...,][name=...])

Diagonal matrix with elements from given vector

# Signature

    function joDiag(v::LocalVector{EDT};makecopy::Bool=true,
        DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),name::String="joDiag") where {EDT}

# Arguments

- `v`: vector of diagonal elements
- keywords
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Examples

    joDiag(rand(m))

examples with DDT/RDT

    joDiag(rand(m); DDT=Float32)
    joDiag(rand(m); DDT=Float32,RDT=Float64)

"""
function joDiag(v::LocalVector{EDT};makecopy::Bool=true,
    DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),name::String="joDiag") where {EDT}

    vc= makecopy ? Base.deepcopy(v) : v
    
    return joMatrix(Diagonal(vc);DDT=DDT,RDT=RDT,name=name)
end

