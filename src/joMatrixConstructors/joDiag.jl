# diagonal operators: joDiag

export joDiag
joDiag{EDT}(v::AbstractVector{EDT},DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT)) =
    joMatrix{EDT,DDT,RDT}("joDiag",length(v),length(v),
        v1->jo_convert(RDT,Diagonal(v)*v1),
        v2->jo_convert(DDT,Diagonal(v)*v2),
        v3->jo_convert(DDT,Diagonal(conj(v))*v3),
        v4->jo_convert(RDT,Diagonal(conj(v))*v4),
        @NF, @NF, @NF, @NF
        )

