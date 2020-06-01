# matrix of zeros

export joZeros
"""
    julia> op = joZeros(m[,n];[DDT=...,][RDT=...,][name=...])

Operator equivalent to matrix of ones

# Signature

    joZeros(m::Integer,n::Integer=m;
        DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joZeros")

# Arguments

- `m`: size
- optional
    - `n`: 2nd dimension if not square
- keywords
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Examples

    joZeros(m)
    joZeros(m,n)

examples with DDT/RDT

    joZeros(m; DDT=Float32)
    joZeros(m; DDT=Float32,RDT=Float64)

"""
joZeros(m::Integer,n::Integer=m;DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joZeros") =
    joMatrix{DDT,RDT}(name,m,n,
        v1->(size(v1,2)>1 ? zeros(RDT,m,size(v1,2)) : zeros(RDT,m)),
        v2->(size(v2,2)>1 ? zeros(DDT,n,size(v2,2)) : zeros(DDT,n)),
        v3->(size(v3,2)>1 ? zeros(DDT,n,size(v3,2)) : zeros(DDT,n)),
        v4->(size(v4,2)>1 ? zeros(RDT,m,size(v4,2)) : zeros(RDT,m)),
        @joNF, @joNF, @joNF, @joNF
        )

