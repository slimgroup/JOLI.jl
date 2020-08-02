workspace()
using JOLI
jo_type_mismatch_error_set(false)
#JOLI.jo_type_mismatch_warn_set(false)

s=rand(3:9,3)
a=rand(Complex{Float64},s[1],s[1])
A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
show(A)
b=rand(Complex{Float64},s[2],s[1])
B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
show(B)
c=rand(Complex{Float64},s[3],s[1])
C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64},name="C")
show(C)
bd=cat(1,a,b,c)
println(size(a),size(b),size(c),size(bd))
#BD=joStack(A,B,C)
BD=[A;B;C]
show(BD)
show(BD.')
show(BD')
show(conj(BD))
show(-BD)
sm=sum(s[:])
sn=s[1]
vn=rand(Complex{Float32},sn);
vm=rand(Complex{Float64},sm);
mvn=rand(Complex{Float32},sn,2);
mvm=rand(Complex{Float64},sm,2);
size(BD)
println(norm(bd*vn-BD*vn)<eps(norm(bd*vn))^(1./3.))
println(norm(bd*mvn-BD*mvn)<eps(norm(bd*mvn))^(1./3.))
println(norm(bd.'*vm-BD.'*vm)<eps(norm(bd.'*vm))^(1./3.))
println(norm(bd.'*mvm-BD.'*mvm)<eps(norm(bd.'*mvm))^(1./3.))
println(norm(bd'*vm-BD'*vm)<eps(norm(bd'*vm))^(1./3.))
println(norm(bd'*mvm-BD'*mvm)<eps(norm(bd'*mvm))^(1./3.))
println(norm(conj(bd)*vn-conj(BD)*vn)<eps(norm(conj(bd)*vn))^(1./3.))
println(norm(conj(bd)*mvn-conj(BD)*mvn)<eps(norm(conj(bd)*mvn))^(1./3.))
println(norm((-bd)*vn-(-BD)*vn)<eps(norm((-bd)*vn))^(1./3.))
println(norm((-bd)*mvn-(-BD)*mvn)<eps(norm((-bd)*mvn))^(1./3.))