# identity operators: joEye # fix,DDT,RDT

export joEye
joEye(m::Integer,EDT::DataType=Int8,DDT::DataType=Float64) =
    joMatrix{EDT,DDT,DDT}("joEye",m,m,
        v1->v1,
        v2->v2,
        v3->v3,
        v4->v4,
        v5->v5,
        v6->v6,
        v7->v7,
        v8->v8
        )
joEye(m::Integer,n::Integer,EDT::DataType=Int8,DDT::DataType=Float64) =
    joMatrix{EDT,DDT,DDT}("joEye",m,n,
        v1->speye(promote_type(EDT,eltype(v1)),m,n)*v1,
        v2->speye(promote_type(EDT,eltype(v2)),n,m)*v2,
        v3->speye(promote_type(EDT,eltype(v3)),n,m)*v3,
        v4->speye(promote_type(EDT,eltype(v4)),m,n)*v4,
        @NF, @NF, @NF, @NF
        )
        #v5->speye(EDT,m,n)\v5, v6->speye(EDT,n,m)\v6, v7->speye(EDT,n,m)\v7, v8->speye(EDT,m,n)\v8
        #v5->speye(EDT,n,m)*v5, v6->speye(EDT,m,n)*v6, v7->speye(EDT,m,n)*v7, v8->speye(EDT,n,m)*v8

