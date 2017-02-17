# matrix of zeros # fix,DDT,RDT

export joZeros
joZeros(m::Integer,EDT::DataType=Int8,DDT::DataType=Float64) = joZeros(m,m,EDT,DDT)
joZeros(m::Integer,n::Integer,EDT::DataType=Int8,DDT::DataType=Float64) =
    joMatrix{EDT,DDT,DDT}("joZeros",m,n,
        v1->(size(v1,2)>1 ? zeros(promote_type(EDT,eltype(v1)),m,size(v1,2)) : zeros(promote_type(EDT,eltype(v1)),m)),
        v2->(size(v2,2)>1 ? zeros(promote_type(EDT,eltype(v2)),n,size(v2,2)) : zeros(promote_type(EDT,eltype(v2)),m)),
        v3->(size(v3,2)>1 ? zeros(promote_type(EDT,eltype(v3)),n,size(v3,2)) : zeros(promote_type(EDT,eltype(v3)),m)),
        v4->(size(v4,2)>1 ? zeros(promote_type(EDT,eltype(v4)),m,size(v4,2)) : zeros(promote_type(EDT,eltype(v4)),m)),
        @NF, @NF, @NF, @NF
        )

