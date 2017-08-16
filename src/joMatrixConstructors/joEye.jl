# identity operators: joEye

export joEye
joEye(m::Integer;DDT::DataType=joFloat,RDT::DataType=DDT) =
    joMatrix{DDT,DDT}("joEye",m,m,
        v1->jo_convert(RDT,v1,false),
        v2->jo_convert(DDT,v2,false),
        v3->jo_convert(DDT,v3,false),
        v4->jo_convert(RDT,v4,false),
        v5->jo_convert(DDT,v5,false),
        v6->jo_convert(RDT,v6,false),
        v7->jo_convert(RDT,v7,false),
        v8->jo_convert(DDT,v8,false)
        )
joEye(m::Integer,n::Integer;DDT::DataType=joFloat,RDT::DataType=DDT) =
    joMatrix{DDT,DDT}("joEye",m,n,
        v1->jo_convert(RDT,speye(eltype(v1),m,n)*v1,false),
        v2->jo_convert(DDT,speye(eltype(v2),n,m)*v2,false),
        v3->jo_convert(DDT,speye(eltype(v3),n,m)*v3,false),
        v4->jo_convert(RDT,speye(eltype(v4),m,n)*v4,false),
        @joNF, @joNF, @joNF, @joNF
        )
        #v5->speye(EDT,m,n)\v5, v6->speye(EDT,n,m)\v6, v7->speye(EDT,n,m)\v7, v8->speye(EDT,m,n)\v8
        #v5->speye(EDT,n,m)*v5, v6->speye(EDT,m,n)*v6, v7->speye(EDT,m,n)*v7, v8->speye(EDT,n,m)*v8

