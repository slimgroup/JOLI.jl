# matrix of ones

export joOnes
joOnes(m::Integer;DDT::DataType=joFloat,RDT::DataType=DDT) = joOnes(m,m;DDT=DDT,RDT=RDT)
joOnes(m::Integer,n::Integer;DDT::DataType=joFloat,RDT::DataType=DDT) =
    joMatrix{DDT,RDT}("joOnes",m,n,
        v1->jo_convert(RDT,ones(eltype(v1),m,1)*sum(v1,1),false),
        v2->jo_convert(DDT,ones(eltype(v2),n,1)*sum(v2,1),false),
        v3->jo_convert(DDT,ones(eltype(v3),n,1)*sum(v3,1),false),
        v4->jo_convert(RDT,ones(eltype(v4),m,1)*sum(v4,1),false),
        @joNF, @joNF, @joNF, @joNF
        )

