# identity operators: joDirac

export joDirac
"""
    joDirac(m;[DDT=...,][RDT=...,][name=...])

Dirac operator

# Signature

    joDirac(m::Integer;DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joDirac")

# Arguments

# Arguments

- `m`: size
- keywords
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Examples

    A=joDirac(3)

examples with DDT/RDT

    A=joDirac(3; DDT=Float32)
    A=joDirac(3; DDT=Float32,RDT=Float64)

"""
joDirac(m::Integer;DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joDirac") =
    joMatrix{DDT,RDT}(name,m,m,
        v1->jo_convert(RDT,v1,false),
        v2->jo_convert(DDT,v2,false),
        v3->jo_convert(DDT,v3,false),
        v4->jo_convert(RDT,v4,false),
        v5->jo_convert(DDT,v5,false),
        v6->jo_convert(RDT,v6,false),
        v7->jo_convert(RDT,v7,false),
        v8->jo_convert(DDT,v8,false)
        )

