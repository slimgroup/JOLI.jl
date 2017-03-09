# matrix of constats

export joConstants
joConstants(m::Integer,a::Number;EDT::DataType=typeof(a),DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT)) = joConstants(m,m,a;EDT=EDT,DDT=DDT,RDT=RDT)
joConstants(m::Integer,n::Integer,a::Number;EDT::DataType=typeof(a),DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT)) =
    joMatrix{EDT,DDT,RDT}("joConstants",m,n,
        v1->jo_convert(RDT,a*ones(eltype(v1),m,1)*sum(v1,1),false),
        v2->jo_convert(DDT,a*ones(eltype(v2),n,1)*sum(v2,1),false),
        v3->jo_convert(DDT,a*ones(eltype(v3),n,1)*sum(v3,1),false),
        v4->jo_convert(RDT,a*ones(eltype(v4),m,1)*sum(v4,1),false),
        @joNF, @joNF, @joNF, @joNF
        )

