# identity operators: joDirac

export joDirac
joDirac(m::Integer=1,e::DataType=Int8) =
    joMatrix{e}("joDirac",m,m,
        v1->v1,
        v2->v2,
        v3->v3,
        v4->v4,
        v5->v5,
        v6->v6,
        v7->v7,
        v8->v8
        )

