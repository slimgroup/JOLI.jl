workspace()
using JOLI
jo_type_mismatch_error_set(false)
#JOLI.jo_type_mismatch_warn_set(false)

s=rand(3:9)
l=3
w=rand(Complex{Float64},l)
a=rand(Complex{Float64},s,s)
A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
show(A)
bd=cat([1 2],w[1]*a,w[2]*a,w[3]*a)
println(l,size(a),size(bd))
BD=joBlockDiag(l,A;weights=w)
show(BD)
show(BD.')
show(BD')
show(conj(BD))
show(-BD)
sn=sum(l*s)
sm=sum(l*s)
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
