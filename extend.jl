workspace()
using JOLI
r=9
n=9

for i=1:r
    l=rand(0:n)
    u=rand(0:n)
    x=rand(n,2)
    y=rand(n+l+u,2)
    A=joExtension(n,JOLI.pad_zeros,pad_lower=l,pad_upper=u)
    B=joExtend(n,:zeros,pad_lower=l,pad_upper=u)
    aa=isadjoint(B)[1]
    fa=vecnorm(A*x-B*x)
    ia=vecnorm(A.'*y-B.'*y)
    ea=vecnorm(elements(A.')-elements(B.'))
    ta=vecnorm(elements(B)'-elements(B.'))
    A=joExtension(n,JOLI.pad_border,pad_lower=l,pad_upper=u)
    B=joExtend(n,:border,pad_lower=l,pad_upper=u)
    ab=isadjoint(B)[1]
    fb=vecnorm(A*x-B*x)
    ib=vecnorm(A.'*y-B.'*y)
    eb=vecnorm(elements(A.')-elements(B.'))
    tb=vecnorm(elements(B)'-elements(B.'))
    A=joExtension(n,JOLI.pad_periodic,pad_lower=l,pad_upper=u)
    B=joExtend(n,:mirror,pad_lower=l,pad_upper=u)
    ac=isadjoint(B)[1]
    fc=vecnorm(A*x-B*x)
    ic=vecnorm(A.'*y-B.'*y)
    ec=vecnorm(elements(A.')-elements(B.'))
    tc=vecnorm(elements(B)'-elements(B.'))
    B=joExtend(n,:periodic,pad_lower=l,pad_upper=u)
    ad=isadjoint(B)[1]
    td=vecnorm(elements(B)'-elements(B.'))
    println(((i,n,l,u),(aa,ab,ac,ad)))
    println(((i,n,l,u),(fa,fb,fc),(ia,ib,ic),(ea,eb,ec),(ta,tb,tc),(td)))
end
