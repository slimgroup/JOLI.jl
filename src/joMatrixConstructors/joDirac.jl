# identity operators: joDirac # fix,DDT,RDT

export joDirac
joDirac(m::Integer=1,EDT::DataType=Int8,DDT::DataType=Float64) =
    joMatrix{EDT,DDT,DDT}("joDirac",m,m,
        v1->v1,
        v2->v2,
        v3->v3,
        v4->v4,
        v5->v5,
        v6->v6,
        v7->v7,
        v8->v8
        )

