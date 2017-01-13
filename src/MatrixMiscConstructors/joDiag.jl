# diagonal operators: joDiag

export joDiag
joDiag{ODT}(v::AbstractVector{ODT}) =
    joMatrix{ODT}("joDiag",length(v),length(v),
        v1->Diagonal(v)*v1,
        v2->Diagonal(v)*v2,
        v3->Diagonal(conj(v))*v3,
        v4->Diagonal(conj(v))*v4,
        @NF, @NF, @NF, @NF
        )

