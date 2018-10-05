# matrix of constats

export joConstants
joConstants(m::Integer,a::EDT;DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT)) where {EDT} = joConstants(m,m,a;DDT=DDT,RDT=RDT)
joConstants(m::Integer,n::Integer,a::EDT;DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT)) where {EDT} =
    joMatrix{DDT,RDT}("joConstants",m,n,
        v1->jo_convert(RDT,a*ones(eltype(v1),m,1)*sum(v1,dims=1),false),
        v2->jo_convert(DDT,a*ones(eltype(v2),n,1)*sum(v2,dims=1),false),
        v3->jo_convert(DDT,conj(a)*ones(eltype(v3),n,1)*sum(v3,dims=1),false),
        v4->jo_convert(RDT,conj(a)*ones(eltype(v4),m,1)*sum(v4,dims=1),false),
        @joNF, @joNF, @joNF, @joNF
        )

