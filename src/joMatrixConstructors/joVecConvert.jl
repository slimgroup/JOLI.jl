# vector conversion operators: joReal joImag joConj joConvert

export joReal, joImag, joConj, joConvert
joReal(m::Integer;CDP::DataType=Float64) =
    joMatrix{Complex{CDP},CDP}("joReal",m,m,
        v1->jo_convert(CDP,real(v1),false),
        v2->jo_convert(Complex{CDP},complex(v2),false),
        v3->jo_convert(Complex{CDP},complex(v3),false),
        v4->jo_convert(CDP,real(v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
joImag(m::Integer;CDP::DataType=Float64) =
    joMatrix{Complex{CDP},CDP}("joImag",m,m,
        v1->jo_convert(CDP,imag(v1),false),
        v2->jo_convert(Complex{CDP},complex(zero(CDP),v2),false),
        v3->jo_convert(Complex{CDP},complex(zero(CDP),v3),false),
        v4->jo_convert(CDP,imag(v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
joConj(m::Integer;CDT::DataType=Complex{Float64}) =
    joMatrix{CDT,CDT}("joConj",m,m,
        v1->jo_convert(Complex{CDT},conj(v1),false),
        v2->jo_convert(Complex{CDT},conj(v2),false),
        v3->jo_convert(Complex{CDT},conj(v3),false),
        v4->jo_convert(Complex{CDT},conj(v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
joConvert(m::Integer,DDT::DataType,RDT::DataType) =
    joMatrix{DDT,RDT}("joConvert",m,m,
        v1->jo_convert(RDT,v1,false),
        v2->jo_convert(DDT,v2,false),
        v3->jo_convert(DDT,v3,false),
        v4->jo_convert(RDT,v4,false),
        v5->jo_convert(DDT,v5,false),
        v6->jo_convert(RDT,v6,false),
        v7->jo_convert(RDT,v7,false),
        v8->jo_convert(DDT,v8,false)
        )

