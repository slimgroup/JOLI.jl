workspace()
using JOLI
jo_type_mismatch_error_set(false)
#JOLI.jo_type_mismatch_warn_set(false)

s=rand(3:9,3)
w=rand(Complex{Float64},3)
u=rand(7:11,2)
display(s'); println()
mo=vec([0 rand(0:u[1]) u[1]]) #rand(0:9,3)
display(mo'); println()
no=vec([0 rand(0:u[2]) u[2]]) #rand(0:9,3)
display(no'); println()
m=max((mo+s)...)
n=max((no+circshift(s,-1))...)
display([m n]); println()
a=rand(Complex{Float64},s[1],s[2])
#a=ones(s[1],s[2])
A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
#A=joMatrix(a;name="A")
show(A)
b=rand(Complex{Float64},s[2],s[3])
#b=ones(s[2],s[3])
B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
#B=joMatrix(b;name="B")
show(B)
c=rand(Complex{Float64},s[3],s[1])
#c=ones(s[3],s[1])
C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64},name="C")
#C=joMatrix(c;name="C")
show(C)
bm=zeros(Complex{Float64},m,n)
#bm=zeros(m,n)
bm[(mo[1]+1):(mo[1]+s[1]),(no[1]+1):(no[1]+s[2])]+=w[1]*a
bm[(mo[2]+1):(mo[2]+s[2]),(no[2]+1):(no[2]+s[3])]+=w[2]*b
bm[(mo[3]+1):(mo[3]+s[3]),(no[3]+1):(no[3]+s[1])]+=w[3]*c
#display(bm); println()
println(size(a),size(b),size(c),size(bm))
BM=joCoreBlock(A,B,C;moffsets=mo,noffsets=no,weights=w)
show(BM)
show(BM.')
show(BM')
show(conj(BM))
show(-BM)
sn=BM.n
sm=BM.m
vn=rand(Complex{Float32},sn);
vm=rand(Complex{Float64},sm);
mvn=rand(Complex{Float32},sn,2);
mvm=rand(Complex{Float64},sm,2);
#vn=rand(Float64,sn);
#vm=rand(Float64,sm);
#mvn=rand(Float64,sn,2);
#mvm=rand(Float64,sm,2);
size(BM)
println(norm(bm*vn-BM*vn)<eps(norm(bm*vn))^(1./3.))
println(norm(bm*mvn-BM*mvn)<eps(norm(bm*mvn))^(1./3.))
println(norm(bm.'*vm-BM.'*vm)<eps(norm(bm.'*vm))^(1./3.))
println(norm(bm.'*mvm-BM.'*mvm)<eps(norm(bm.'*mvm))^(1./3.))
println(norm(bm'*vm-BM'*vm)<eps(norm(bm'*vm))^(1./3.))
println(norm(bm'*mvm-BM'*mvm)<eps(norm(bm'*mvm))^(1./3.))
println(norm(conj(bm)*vn-conj(BM)*vn)<eps(norm(conj(bm)*vn))^(1./3.))
println(norm(conj(bm)*mvn-conj(BM)*mvn)<eps(norm(conj(bm)*mvn))^(1./3.))
println(norm((-bm)*vn-(-BM)*vn)<eps(norm((-bm)*vn))^(1./3.))
println(norm((-bm)*mvn-(-BM)*mvn)<eps(norm((-bm)*mvn))^(1./3.))
