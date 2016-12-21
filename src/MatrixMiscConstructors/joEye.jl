# identity operators: joEye

export joEye
joEye(m::Integer,e::DataType=Int8) =
    joMatrix{e}("joEye",m,m,
        v1->v1,
        v2->v2,
        v3->v3,
        v4->v4,
        v5->v5,
        v6->v6,
        v7->v7,
        v8->v8
        )
joEye(m::Integer,n::Integer,e::DataType=Int8) =
    joMatrix{e}("joEye",m,n,
        v1->speye(promote_type(e,eltype(v1)),m,n)*v1,
        v2->speye(promote_type(e,eltype(v2)),n,m)*v2,
        v3->speye(promote_type(e,eltype(v3)),n,m)*v3,
        v4->speye(promote_type(e,eltype(v4)),m,n)*v4,
        @NF, @NF, @NF, @NF
        )
        #v5->speye(e,m,n)\v5, v6->speye(e,n,m)\v6, v7->speye(e,n,m)\v7, v8->speye(e,m,n)\v8
        #v5->speye(e,n,m)*v5, v6->speye(e,m,n)*v6, v7->speye(e,m,n)*v7, v8->speye(e,n,m)*v8

