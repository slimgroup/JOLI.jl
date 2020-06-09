# vector conversion operators: joReal joImag joConj joConvert

export joReal, joImag, joConj, joConvert
"""
    julia> op = joReal(m;[VDP=...,][name=...])

Takes real part of vector (experimantal).

transpose/adjont puts the real vector into real part of the complex vector with zero imag part

# Signature

    joReal(m::Integer;VDP::DataType=joFloat,name::String="joReal")

# Arguments

- `m`: vector size
- keywords
    - `VDP`: float element type of Complex number in vector
    - `name`: custom name

"""
joReal(m::Integer;VDP::DataType=joFloat,name::String="joReal") =
    joMatrix{Complex{VDP},VDP}(name,m,m,
        v1->jo_convert(VDP,real(v1),false),
        v2->jo_convert(Complex{VDP},complex.(v2),false),
        v3->jo_convert(Complex{VDP},complex.(v3),false),
        v4->jo_convert(VDP,real(v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
"""
    julia> op = joImag(m;[VDP=...,][name=...])

Takes imag part of vector (experimantal).

transpose/adjont puts the real vector into imag part of the complex vector with zero real part

# Signature

    joReal(m::Integer;VDP::DataType=joFloat,name::String="joImag")

# Arguments

- `m`: vector size
- keywords
    - `VDP`: float element type of Complex number in vector
    - `name`: custom name

"""
joImag(m::Integer;VDP::DataType=joFloat,name::String="joImag") =
    joMatrix{Complex{VDP},VDP}(name,m,m,
        v1->jo_convert(VDP,imag(v1),false),
        v2->jo_convert(Complex{VDP},complex.(zero(VDP),v2),false),
        v3->jo_convert(Complex{VDP},complex.(zero(VDP),-v3),false),
        v4->jo_convert(VDP,-imag(v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
"""
    julia> op = joConj(m;[VDP=...,][name=...])

Takes conjugate of vector (experimantal).

# Signature

    joConj(m::Integer;VDP::DataType=joFloat,name::String="joConj")

# Arguments

- `m`: vector size
- keywords
    - `VDP`: float element type of Complex number in vector
    - `name`: custom name

"""
joConj(m::Integer;VDP::DataType=joFloat,name::String="joConj") =
    joMatrix{Complex{VDP},Complex{VDP}}(name,m,m,
        v1->jo_convert(Complex{VDP},conj(v1),false),
        v2->jo_convert(Complex{VDP},conj(v2),false),
        v3->jo_convert(Complex{VDP},conj(v3),false),
        v4->jo_convert(Complex{VDP},conj(v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
"""
    julia> op = joConvert(m,DDT,RDT;[name=...])

Converts vector between different types (experimental)

# Signature

    joConvert(m::Integer,DDT::DataType,RDT::DataType;name::String="joConvert")

# Arguments

- `m`: vector size
- `DDT`: domain data type
- `RDT`: range data type
- keywords
    - `name`: custom name

"""
joConvert(m::Integer,DDT::DataType,RDT::DataType;name::String="joConvert") =
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

