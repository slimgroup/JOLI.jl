############################################################
# joMatrix - miscaleneous constructor-only operators #######
############################################################

# identity operators: joDirac
export joDirac
joDirac(m::Integer=1,e::DataType=Float64)=
    joMatrix{e}("joDirac",m,m,
        v1->v1,v2->v2,v3->v3,v4->v4,
        @NF(v5->v5),@NF(v6->v6),@NF(v7->v7),@NF(v8->v8))

# identity operators: joEye
export joEye
joEye(m::Integer,e::DataType=Float64)=
    joMatrix{e}("joEye",m,m,
        v1->v1,v2->v2,v3->v3,v4->v4,
        @NF(v5->v5),@NF(v6->v6),@NF(v7->v7),@NF(v8->v8))
joEye(m::Integer,n::Integer,e::DataType=Float64)=
    joMatrix{e}("joEye",m,n,
        v1->speye(m,n)*v1,v2->speye(n,m)*v2,v3->speye(n,m)*v3,v4->speye(m,n)*v4,
        @NF, @NF, @NF, @NF)
        #@NF(v5->speye(m,n)\v5), @NF(v6->speye(m,n)\v6), @NF(v7->speye(m,n)\v7), @NF(v8->speye(m,n)\v8))
        #@NF(v5->speye(n,m)*v5), @NF(v6->speye(n,m)*v6), @NF(v7->speye(n,m)*v7), @NF(v8->speye(n,m)*v8))

# matrix of ones
export joOnes
joOnes(m::Integer,e::DataType=Float64)=joOnes(m,m,e)
joOnes(m::Integer,n::Integer,e::DataType=Float64)=
    joMatrix{e}("joOnes",m,n,
        v1->ones(m,1)*sum(v1,1),v2->ones(n,1)*sum(v2,1),v3->ones(n,1)*sum(v3,1),v4->ones(m,1)*sum(v4,1),
        @NF, @NF, @NF, @NF)

# matrix of zeros
export joZeros
joZeros(m::Integer,e::DataType=Float64)=joZeros(m,m,e)
joZeros(m::Integer,n::Integer,e::DataType=Float64)=
    joMatrix{e}("joZeros",m,n,
        v1->(size(v1,2)>1 ? zeros(m,size(v1,2)) : zeros(m)),
        v2->(size(v2,2)>1 ? zeros(n,size(v2,2)) : zeros(m)),
        v3->(size(v3,2)>1 ? zeros(n,size(v3,2)) : zeros(m)),
        v4->(size(v4,2)>1 ? zeros(m,size(v4,2)) : zeros(m)),
        @NF, @NF, @NF, @NF)

