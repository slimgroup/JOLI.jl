# vector conversion operators: joReal joImag joConj

export joReal, joImag, joConj
joReal(m::Integer=1,e::DataType=Int8) =
    joMatrix{e}("joReal",m,m,
        v1->real(v1),
        v2->real(v2),
        v3->real(v3),
        v4->real(v4),
        @NF, @NF, @NF, @NF
        )
joImag(m::Integer=1,e::DataType=Int8) =
    joMatrix{e}("joImag",m,m,
        v1->imag(v1),
        v2->imag(v2),
        v3->imag(v3),
        v4->imag(v4),
        @NF, @NF, @NF, @NF
        )
joConj(m::Integer=1,e::DataType=Int8) =
    joMatrix{e}("joConj",m,m,
        v1->conj(v1),
        v2->conj(v2),
        v3->conj(v3),
        v4->conj(v4),
        @NF, @NF, @NF, @NF
        )

