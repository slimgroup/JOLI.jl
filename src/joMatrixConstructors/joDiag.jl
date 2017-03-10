# diagonal operators: joDiag

export joDiag
function joDiag{EDT}(v::AbstractVector{EDT};DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),makecopy::Bool=false)
    vc= makecopy ? Base.deepcopy(v) : v
    return joMatrix{EDT,DDT,RDT}("joDiag",length(vc),length(vc),
        v1->jo_convert(RDT,Diagonal(vc)*v1,false),
        v2->jo_convert(DDT,Diagonal(vc)*v2,false),
        v3->jo_convert(DDT,Diagonal(conj(vc))*v3,false),
        v4->jo_convert(RDT,Diagonal(conj(vc))*v4,false),
        @joNF, @joNF, @joNF, @joNF
        )
end

