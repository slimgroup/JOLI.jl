# vector conversion operators: joReal joImag joConj # fix,DDT,RDT

export joReal, joImag, joConj
joReal(m::Integer,EDT::DataType=Int8,CDT::DataType=Float64) =
    joMatrix{EDT,Complex{CDT},CDT}("joReal",m,m,
        v1->real(v1),
        v2->complex(v2),
        v3->complex(v3),
        v4->real(v4),
        @NF, @NF, @NF, @NF
        )
joImag(m::Integer,EDT::DataType=Int8,CDT::DataType=Float64) =
    joMatrix{EDT,Complex{CDT},CDT}("joImag",m,m,
        v1->imag(v1),
        v2->complex(0,v2),
        v3->complex(0,v3),
        v4->complex(0,-v4),
        @NF, @NF, @NF, @NF
        )
joConj(m::Integer,EDT::DataType=Int8,DDT::DataType=Float64) =
    joMatrix{EDT,DDT,DDT}("joConj",m,m,
        v1->conj(v1),
        v2->conj(v2),
        v3->conj(v3),
        v4->conj(v4),
        @NF, @NF, @NF, @NF
        )

