############################################################
# joMatrix #################################################
############################################################

############################################################
## miscaleneous constructor-only operators

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
