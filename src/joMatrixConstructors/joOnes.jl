# matrix of ones

export joOnes
"""
    julia> op = joOnes(m[,n];[DDT=...,][RDT=...,][name=...])

Operator equivalent to matrix of zerso

# Signature

    joOnes(m::Integer,n::Integer=m;
        DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joOnes")

# Arguments

- `m`: size
- optional
    - `n`: 2nd dimension if not square
- keywords
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Examples

    joOnes(m)
    joOnes(m,n)

examples with DDT/RDT

    joOnes(m; DDT=Float32)
    joOnes(m; DDT=Float32,RDT=Float64)

"""
joOnes(m::Integer,n::Integer=m;DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joOnes") =
    joMatrix{DDT,RDT}(name,m,n,
        v1->jo_convert(RDT,ones(eltype(v1),m,1)*sum(v1,dims=1),false),
        v2->jo_convert(DDT,ones(eltype(v2),n,1)*sum(v2,dims=1),false),
        v3->jo_convert(DDT,ones(eltype(v3),n,1)*sum(v3,dims=1),false),
        v4->jo_convert(RDT,ones(eltype(v4),m,1)*sum(v4,dims=1),false),
        @joNF, @joNF, @joNF, @joNF
        )

