# matrix of zeros

export joZeros
joZeros(m::Integer,e::DataType=Int8) = joZeros(m,m,e)
joZeros(m::Integer,n::Integer,e::DataType=Int8) =
    joMatrix{e}("joZeros",m,n,
        v1->(size(v1,2)>1 ? zeros(promote_type(e,eltype(v1)),m,size(v1,2)) : zeros(promote_type(e,eltype(v1)),m)),
        v2->(size(v2,2)>1 ? zeros(promote_type(e,eltype(v2)),n,size(v2,2)) : zeros(promote_type(e,eltype(v2)),m)),
        v3->(size(v3,2)>1 ? zeros(promote_type(e,eltype(v3)),n,size(v3,2)) : zeros(promote_type(e,eltype(v3)),m)),
        v4->(size(v4,2)>1 ? zeros(promote_type(e,eltype(v4)),m,size(v4,2)) : zeros(promote_type(e,eltype(v4)),m)),
        @NF, @NF, @NF, @NF
        )

