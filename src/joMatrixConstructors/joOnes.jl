# matrix of ones # fix,DDT,RDT

export joOnes
joOnes(m::Integer,EDT::DataType=Int8,DDT::DataType=Float64) = joOnes(m,m,EDT,DDT)
joOnes(m::Integer,n::Integer,EDT::DataType=Int8,DDT::DataType=Int8) =
    joMatrix{EDT,DDT,DDT}("joOnes",m,n,
        v1->ones(promote_type(EDT,eltype(v1)),m,1)*sum(v1,1),
        v2->ones(promote_type(EDT,eltype(v2)),n,1)*sum(v2,1),
        v3->ones(promote_type(EDT,eltype(v3)),n,1)*sum(v3,1),
        v4->ones(promote_type(EDT,eltype(v4)),m,1)*sum(v4,1),
        @NF, @NF, @NF, @NF
        )

