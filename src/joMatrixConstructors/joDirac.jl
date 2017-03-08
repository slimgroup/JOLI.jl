# identity operators: joDirac

export joDirac
joDirac(m::Integer;EDT::DataType=Float64,DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT)) =
    joMatrix{EDT,DDT,RDT}("joDirac",m,m,
        v1->jo_convert(RDT,v1,false),
        v2->jo_convert(DDT,v2,false),
        v3->jo_convert(DDT,v3,false),
        v4->jo_convert(RDT,v4,false),
        v5->jo_convert(DDT,v5,false),
        v6->jo_convert(RDT,v6,false),
        v7->jo_convert(RDT,v7,false),
        v8->jo_convert(DDT,v8,false)
        )

