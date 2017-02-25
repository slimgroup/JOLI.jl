# identity operators: joDirac

export joDirac
joDirac(m::Integer,EDT::DataType=Float64,DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT)) =
    joMatrix{EDT,DDT,RDT}("joDirac",m,m,
        v1->jo_convert(RDT,v1),
        v2->jo_convert(DDT,v2),
        v3->jo_convert(DDT,v3),
        v4->jo_convert(RDT,v4),
        v5->jo_convert(DDT,v5),
        v6->jo_convert(RDT,v6),
        v7->jo_convert(RDT,v7),
        v8->jo_convert(DDT,v8)
        )

