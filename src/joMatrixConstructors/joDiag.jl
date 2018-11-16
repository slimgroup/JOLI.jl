# diagonal operators: joDiag

export joDiag
function joDiag(v::LocalVector{EDT};DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),makecopy::Bool=true) where {EDT}
    vc= makecopy ? Base.deepcopy(v) : v
    
    return joMatrix(Diagonal(vc);DDT=DDT,RDT=RDT,name="joDiag")
end

