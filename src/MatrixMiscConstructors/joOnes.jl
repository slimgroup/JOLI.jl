# matrix of ones

export joOnes
joOnes(m::Integer,e::DataType=Int8) = joOnes(m,m,e)
joOnes(m::Integer,n::Integer,e::DataType=Int8) =
    joMatrix{e}("joOnes",m,n,
        v1->ones(promote_type(e,eltype(v1)),m,1)*sum(v1,1),
        v2->ones(promote_type(e,eltype(v2)),n,1)*sum(v2,1),
        v3->ones(promote_type(e,eltype(v3)),n,1)*sum(v3,1),
        v4->ones(promote_type(e,eltype(v4)),m,1)*sum(v4,1),
        @NF, @NF, @NF, @NF
        )

