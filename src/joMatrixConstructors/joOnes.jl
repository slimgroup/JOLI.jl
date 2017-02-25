# matrix of ones # fix,DDT,RDT

export joOnes
joOnes(m::Integer,EDT::DataType=Float64,DDT::DataType=Float64,RDT::DataType=promote_type(EDT,DDT)) = joOnes(m,m,EDT,DDT,RDT)
joOnes(m::Integer,n::Integer,EDT::DataType=Float64,DDT::DataType=Float64,RDT::DataType=promote_type(EDT,DDT)) =
    joMatrix{EDT,DDT,RDT}("joOnes",m,n,
        v1->jo_convert(RDT,ones(eltype(v1),m,1)*sum(v1,1)),
        v2->jo_convert(DDT,ones(eltype(v2),n,1)*sum(v2,1)),
        v3->jo_convert(DDT,ones(eltype(v3),n,1)*sum(v3,1)),
        v4->jo_convert(RDT,ones(eltype(v4),m,1)*sum(v4,1)),
        @NF, @NF, @NF, @NF
        )

