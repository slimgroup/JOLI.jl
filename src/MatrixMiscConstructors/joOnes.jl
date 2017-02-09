# matrix of ones # fix,DDT,RDT

export joOnes
joOnes(m::Integer,ODT::DataType=Int8,DDT::DataType=Int8,RDT::DataType=Int8) = joOnes(m,m,ODT,DDT,RDT)
joOnes(m::Integer,n::Integer,ODT::DataType=Int8,DDT::DataType=Int8,RDT::DataType=Int8) =
    joMatrix{ODT,DDT,RDT}("joOnes",m,n,
        v1->ones(promote_type(ODT,eltype(v1)),m,1)*sum(v1,1),
        v2->ones(promote_type(ODT,eltype(v2)),n,1)*sum(v2,1),
        v3->ones(promote_type(ODT,eltype(v3)),n,1)*sum(v3,1),
        v4->ones(promote_type(ODT,eltype(v4)),m,1)*sum(v4,1),
        @NF, @NF, @NF, @NF
        )

