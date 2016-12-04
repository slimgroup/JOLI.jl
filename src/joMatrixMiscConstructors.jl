############################################################
# joMatrix - miscaleneous constructor-only operators #######
############################################################

# identity operators: joDirac
export joDirac
joDirac(m::Integer=1,e::DataType=Int8)=
    joMatrix{e}("joDirac",m,m,
        v1->v1,v2->v2,v3->v3,v4->v4,
        @NF(v5->v5),@NF(v6->v6),@NF(v7->v7),@NF(v8->v8))

# identity operators: joEye
export joEye
joEye(m::Integer,e::DataType=Int8)=
    joMatrix{e}("joEye",m,m,
        v1->v1,v2->v2,v3->v3,v4->v4,
        @NF(v5->v5),@NF(v6->v6),@NF(v7->v7),@NF(v8->v8))
joEye(m::Integer,n::Integer,e::DataType=Int8)=
    joMatrix{e}("joEye",m,n,
        v1->speye(promote_type(e,eltype(v1)),m,n)*v1,
        v2->speye(promote_type(e,eltype(v2)),n,m)*v2,
        v3->speye(promote_type(e,eltype(v3)),n,m)*v3,
        v4->speye(promote_type(e,eltype(v4)),m,n)*v4,
        @NF, @NF, @NF, @NF)
        #@NF(v5->speye(e,m,n)\v5), @NF(v6->speye(e,n,m)\v6), @NF(v7->speye(e,n,m)\v7), @NF(v8->speye(e,m,n)\v8))
        #@NF(v5->speye(e,n,m)*v5), @NF(v6->speye(e,m,n)*v6), @NF(v7->speye(e,m,n)*v7), @NF(v8->speye(e,n,m)*v8))

# matrix of ones
export joOnes
joOnes(m::Integer,e::DataType=Int8)=joOnes(m,m,e)
joOnes(m::Integer,n::Integer,e::DataType=Int8)=
    joMatrix{e}("joOnes",m,n,
        v1->ones(promote_type(e,eltype(v1)),m,1)*sum(v1,1),
        v2->ones(promote_type(e,eltype(v2)),n,1)*sum(v2,1),
        v3->ones(promote_type(e,eltype(v3)),n,1)*sum(v3,1),
        v4->ones(promote_type(e,eltype(v4)),m,1)*sum(v4,1),
        @NF, @NF, @NF, @NF)

# matrix of zeros
export joZeros
joZeros(m::Integer,e::DataType=Int8)=joZeros(m,m,e)
joZeros(m::Integer,n::Integer,e::DataType=Int8)=
    joMatrix{e}("joZeros",m,n,
        v1->(size(v1,2)>1 ? zeros(promote_type(e,eltype(v1)),m,size(v1,2)) : zeros(promote_type(e,eltype(v1)),m)),
        v2->(size(v2,2)>1 ? zeros(promote_type(e,eltype(v2)),n,size(v2,2)) : zeros(promote_type(e,eltype(v2)),m)),
        v3->(size(v3,2)>1 ? zeros(promote_type(e,eltype(v3)),n,size(v3,2)) : zeros(promote_type(e,eltype(v3)),m)),
        v4->(size(v4,2)>1 ? zeros(promote_type(e,eltype(v4)),m,size(v4,2)) : zeros(promote_type(e,eltype(v4)),m)),
        @NF, @NF, @NF, @NF)

# conversion operators: joReal joImag
export joReal, joImag
joReal(m::Integer=1,e::DataType=Int8)=
    joMatrix{e}("joReal",m,m,
        v1->real(v1),v2->real(v2),v3->real(v3),v4->real(v4),
        @NF, @NF, @NF, @NF)
joImag(m::Integer=1,e::DataType=Int8)=
    joMatrix{e}("joImag",m,m,
        v1->imag(v1),v2->imag(v2),v3->imag(v3),v4->imag(v4),
        @NF, @NF, @NF, @NF)

