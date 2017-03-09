# matrix of zeros

export joZeros
joZeros(m::Integer;EDT::DataType=Float64,DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT)) = joZeros(m,m,EDT=EDT,DDT=DDT,RDT=RDT)
joZeros(m::Integer,n::Integer;EDT::DataType=Float64,DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT)) =
    joMatrix{EDT,DDT,RDT}("joZeros",m,n,
        v1->(size(v1,2)>1 ? zeros(RDT,m,size(v1,2)) : zeros(EDT,m)),
        v2->(size(v2,2)>1 ? zeros(DDT,n,size(v2,2)) : zeros(EDT,n)),
        v3->(size(v3,2)>1 ? zeros(DDT,n,size(v3,2)) : zeros(EDT,n)),
        v4->(size(v4,2)>1 ? zeros(RDT,m,size(v4,2)) : zeros(EDT,m)),
        @joNF, @joNF, @joNF, @joNF
        )

