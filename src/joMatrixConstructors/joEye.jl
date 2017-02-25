# identity operators: joEye

export joEye
joEye(m::Integer,EDT::DataType=Float64,DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT)) =
    joMatrix{EDT,DDT,DDT}("joEye",m,m,
        v1->jo_convert(RDT,v1),
        v2->jo_convert(DDT,v2),
        v3->jo_convert(DDT,v3),
        v4->jo_convert(RDT,v4),
        v5->jo_convert(DDT,v5),
        v6->jo_convert(RDT,v6),
        v7->jo_convert(RDT,v7),
        v8->jo_convert(DDT,v8)
        )
joEye(m::Integer,n::Integer,EDT::DataType=Float64,DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT)) =
    joMatrix{EDT,DDT,DDT}("joEye",m,n,
        v1->jo_convert(RDT,speye(eltype(v1),m,n)*v1),
        v2->jo_convert(DDT,speye(eltype(v2),n,m)*v2),
        v3->jo_convert(DDT,speye(eltype(v3),n,m)*v3),
        v4->jo_convert(RDT,speye(eltype(v4),m,n)*v4),
        @NF, @NF, @NF, @NF
        )
        #v5->speye(EDT,m,n)\v5, v6->speye(EDT,n,m)\v6, v7->speye(EDT,n,m)\v7, v8->speye(EDT,m,n)\v8
        #v5->speye(EDT,n,m)*v5, v6->speye(EDT,m,n)*v6, v7->speye(EDT,m,n)*v7, v8->speye(EDT,n,m)*v8

