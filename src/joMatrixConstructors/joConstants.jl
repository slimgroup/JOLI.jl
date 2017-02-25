# matrix of constats # fix,DDT,RDT

export joConstants
joConstants(m::Integer,a::Number,EDT::DataType=Float64,DDT::DataType=Float64,RDT::DataType=promote_type(EDT,DDT)) = joConstants(m,m,a,EDT,DDT,RDT)
joConstants(m::Integer,n::Integer,a::Number,EDT::DataType=Float64,DDT::DataType=Float64,RDT::DataType=promote_type(EDT,DDT)) =
    joMatrix{EDT,DDT,RDT}("joConstants",m,n,
        v1->jo_convert(RDT,a*ones(eltype(v1),m,1)*sum(v1,1)),
        v2->jo_convert(DDT,a*ones(eltype(v2),n,1)*sum(v2,1)),
        v3->jo_convert(DDT,a*ones(eltype(v3),n,1)*sum(v3,1)),
        v4->jo_convert(RDT,a*ones(eltype(v4),m,1)*sum(v4,1)),
        @NF, @NF, @NF, @NF
        )

