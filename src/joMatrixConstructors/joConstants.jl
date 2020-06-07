# matrix of constats

export joConstants
"""
    julia> op = joConstants(m,a;[DDT=...,][RDT=...,][name=...])
    julia> op = joConstants(m,n,a;[DDT=...,][RDT=...,][name=...])

Operator equivalent to matrix of same elements

# Signature

    joConstants(m::Integer,a::EDT;
        DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),
        name::String="joConstants") where {EDT<:Number}
    joConstants(m::Integer,n::Integer,a::EDT;
        DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),
        name::String="joConstants") where {EDT<:Number}

# Arguments

- `m`: size
- `a`: element value, default DDT/RDT will have the same type as `a`
- optional
    - `n`: 2nd dimension if not square
- keywords
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Examples

    joConstants(m,a)
    joConstants(m,n,a)

examples with DDT/RDT

    joConstants(m,a; DDT=Float32)
    joConstants(m,a; DDT=Float32,RDT=Float64)

"""
joConstants(m::Integer,a::EDT;
    DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),
    name::String="joConstants") where {EDT<:Number} = joConstants(m,m,a;DDT=DDT,RDT=RDT,name=name)
joConstants(m::Integer,n::Integer,a::EDT;
    DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),
    name::String="joConstants") where {EDT<:Number} =
    joMatrix{DDT,RDT}(name,m,n,
        v1->jo_convert(RDT,a*ones(eltype(v1),m,1)*sum(v1,dims=1),false),
        v2->jo_convert(DDT,a*ones(eltype(v2),n,1)*sum(v2,dims=1),false),
        v3->jo_convert(DDT,conj(a)*ones(eltype(v3),n,1)*sum(v3,dims=1),false),
        v4->jo_convert(RDT,conj(a)*ones(eltype(v4),m,1)*sum(v4,dims=1),false),
        @joNF, @joNF, @joNF, @joNF
        )

