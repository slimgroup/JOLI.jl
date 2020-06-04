workspace()
#using LinearOperators
using JOLI
m=9;n=8;
a=rand(m,n)+im*rand(m,n)
display(a)
b=rand(n,m)+im*rand(n,m)
display(b)
vn=rand(n)+im*rand(n)
display(vn)
vm=rand(m)+im*rand(m)
display(vm)
mvn=rand(n,n)
display(mvn)
mvm=rand(m,n)
display(mvm)
A=joLinearFunctionAll(eltype(a),size(a)...,
    v->a*v,v->a.'*v,v->a'*v,v->conj(a)*v,v->a\v,v->a.'\v,v->a'\v,v->conj(a)\v)
B=joMatrix(b)
c=a*b
C=A*B
show(A)
show(B)
show(C)
# true only for square matricies
display(A*(B*vm)-a*(b*vm))
display(round(C*vm-c*vm,12))
#display(norm((c\vm)-(b\(a\vm)))<10e-10)
