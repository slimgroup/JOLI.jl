# vector conversion operators: joReal joImag joConj joConvert

export joReal, joImag, joConj, joConvert
joReal(m::Integer,CDP::DataType=Float64) =
    joMatrix{CDP,Complex{CDP},CDP}("joReal",m,m,
        v1->real(v1),
        v2->complex(v2),
        v3->complex(v3),
        v4->real(v4),
        @NF, @NF, @NF, @NF
        )
joImag(m::Integer,CDP::DataType=Float64) =
    joMatrix{CDP,Complex{CDP},CDP}("joImag",m,m,
        v1->imag(v1),
        v2->complex(zero(CDP),v2),
        v3->complex(zero(CDP),v3),
        v4->imag(v4),
        @NF, @NF, @NF, @NF
        )
joConj(m::Integer,CDT::DataType=Complex{Float64}) =
    joMatrix{CDT,CDT,CDT}("joConj",m,m,
        v1->conj(v1),
        v2->conj(v2),
        v3->conj(v3),
        v4->conj(v4),
        @NF, @NF, @NF, @NF
        )
joConvert(m::Integer,EDT::DataType=Float64,DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT)) =
    joMatrix{EDT,DDT,RDT}("joConvert",m,m,
        v1->jo_convert(RDT,v1),
        v2->jo_convert(DDT,v2),
        v3->jo_convert(DDT,v3),
        v4->jo_convert(RDT,v4),
        v5->jo_convert(DDT,v5),
        v6->jo_convert(RDT,v6),
        v7->jo_convert(RDT,v7),
        v8->jo_convert(DDT,v8)
        )

