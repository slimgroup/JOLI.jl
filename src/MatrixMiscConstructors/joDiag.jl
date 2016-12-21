# diagonal operators: joDiag

export joDiag
joDiag{MT}(v::AbstractVector{MT}) =
    joMatrix{MT}("joDiag",length(v),length(v),
        v1->spdiagm(v)*v1,
        v2->spdiagm(v)*v2,
        v3->spdiagm(conj(v))*v3,
        v4->spdiagm(conj(v))*v4,
        @NF, @NF, @NF, @NF
        )

