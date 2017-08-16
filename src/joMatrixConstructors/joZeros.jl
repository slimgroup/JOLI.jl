# matrix of zeros

export joZeros
joZeros(m::Integer;DDT::DataType=joFloat,RDT::DataType=DDT) = joZeros(m,m,DDT=DDT,RDT=RDT)
joZeros(m::Integer,n::Integer;DDT::DataType=joFloat,RDT::DataType=DDT) =
    joMatrix{DDT,RDT}("joZeros",m,n,
        v1->(size(v1,2)>1 ? zeros(RDT,m,size(v1,2)) : zeros(RDT,m)),
        v2->(size(v2,2)>1 ? zeros(DDT,n,size(v2,2)) : zeros(DDT,n)),
        v3->(size(v3,2)>1 ? zeros(DDT,n,size(v3,2)) : zeros(DDT,n)),
        v4->(size(v4,2)>1 ? zeros(RDT,m,size(v4,2)) : zeros(RDT,m)),
        @joNF, @joNF, @joNF, @joNF
        )

