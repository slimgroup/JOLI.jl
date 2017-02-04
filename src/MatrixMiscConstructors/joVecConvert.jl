# vector conversion operators: joReal joImag joConj

export joReal, joImag, joConj
joReal(m::Integer=1,ODT::DataType=Int8) =
    joMatrix{ODT}("joReal",m,m,
        v1->real(v1),
        v2->complex(v2),
        v3->complex(v3),
        v4->real(v4),
        @NF, @NF, @NF, @NF
        )
joImag(m::Integer=1,ODT::DataType=Int8) =
    joMatrix{ODT}("joImag",m,m,
        v1->imag(v1),
        v2->complex(0,v2),
        v3->complex(0,v3),
        v4->complex(0,-v4),
        @NF, @NF, @NF, @NF
        )
joConj(m::Integer=1,ODT::DataType=Int8) =
    joMatrix{ODT}("joConj",m,m,
        v1->conj(v1),
        v2->conj(v2),
        v3->conj(v3),
        v4->conj(v4),
        @NF, @NF, @NF, @NF
        )

