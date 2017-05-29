# diagonal operators: joDiag

export joDiag
function joDiag{EDT}(v::AbstractVector{EDT};DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),makecopy::Bool=false)
    vc= makecopy ? Base.deepcopy(v) : v
    
    return joMatrix(Diagonal(vc);DDT=DDT,RDT=RDT,name="joDiag")
end

