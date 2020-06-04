using JOLI
using IterativeSolvers

n=9
t=Complex{Float64}
t=Float64
srand(0)
a=rand(t,n,n)
b=rand(t,n)
M=joMatrix(a)
F=joLinearFunctionFwd(n,n,v->a*v,v->a.'*v,v->a'*v,v->conj(a)*v, eltype(a),eltype(a))
S=joLinearFunctionAll(n,n,v->a*v,v->a.'*v,v->a'*v,v->conj(a)*v, v->a\v,v->a.'\v,v->a'\v,v->conj(a)\v,eltype(a),eltype(a))
ab=a\b

display(ab); println()

display(typeof(lsqr(a,b))); println(" type")
if VERSION < v"0.6"
    la=lsqr(a,b)[1]-ab
    lM=lsqr(M,b)[1]-ab
    lF=lsqr(F,b)[1]-ab
else
    la=lsqr(a,b)-ab
    lM=lsqr(M,b)-ab
    lF=lsqr(F,b)-ab
end
println(("lsqr:",norm(la),norm(lM),norm(lF)))
display([la lM lF]); println()

display(typeof(gmres(a,b))); println(" type")
if VERSION < v"0.6"
    ga=gmres(a,b)-ab
    gM=gmres(M,b)-ab
    gF=gmres(F,b)-ab
else
    ga=gmres(a,b)-ab
    gM=gmres(M,b)-ab
    gF=gmres(F,b)-ab
end
println(("gmres:",norm(ga),norm(gM),norm(gF)))
display([ga gM gF]); println()

#jo_iterative_solver4square_set((A,v)->lsqr(A,v))
ja=JOLI.jo_iterative_solver4square(a,b)-ab
jM=JOLI.jo_iterative_solver4square(M,b)-ab
if VERSION < v"0.6"
    jF=JOLI.jo_iterative_solver4square(F,b)-ab
else
    jF=F\b-ab
end
println(("jdis:",norm(ja),norm(jM),norm(jF)))
display([ja jM jF]); println()

