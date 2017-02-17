# diagonal operators: joDiag # fix,DDT,RDT

export joDiag
joDiag{EDT}(v::AbstractVector{EDT},DDT::DataType=Float64) =
    joMatrix{EDT,DDT,promote_type(EDT,DDT)}("joDiag",length(v),length(v),
        v1->Diagonal(v)*v1,
        v2->Diagonal(v)*v2,
        v3->Diagonal(conj(v))*v3,
        v4->Diagonal(conj(v))*v4,
        @NF, @NF, @NF, @NF
        )

