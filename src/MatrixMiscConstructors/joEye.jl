# identity operators: joEye

export joEye
joEye(m::Integer,ODT::DataType=Int8) =
    joMatrix{ODT}("joEye",m,m,
        v1->v1,
        v2->v2,
        v3->v3,
        v4->v4,
        v5->v5,
        v6->v6,
        v7->v7,
        v8->v8
        )
joEye(m::Integer,n::Integer,ODT::DataType=Int8) =
    joMatrix{ODT}("joEye",m,n,
        v1->speye(promote_type(ODT,eltype(v1)),m,n)*v1,
        v2->speye(promote_type(ODT,eltype(v2)),n,m)*v2,
        v3->speye(promote_type(ODT,eltype(v3)),n,m)*v3,
        v4->speye(promote_type(ODT,eltype(v4)),m,n)*v4,
        @NF, @NF, @NF, @NF
        )
        #v5->speye(ODT,m,n)\v5, v6->speye(ODT,n,m)\v6, v7->speye(ODT,n,m)\v7, v8->speye(ODT,m,n)\v8
        #v5->speye(ODT,n,m)*v5, v6->speye(ODT,m,n)*v6, v7->speye(ODT,m,n)*v7, v8->speye(ODT,n,m)*v8

