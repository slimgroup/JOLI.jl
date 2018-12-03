T=3
tsname="joKron"
@testset "$tsname" begin
for t=1:T # start test loop

    s=rand(3:9,3,2)
    a=rand(ComplexF64,s[1,:]...)
    A=joMatrix(a)
    b=rand(ComplexF64,s[2,:]...)
    B=joMatrix(b;DDT=ComplexF32,RDT=ComplexF64)
    c=rand(ComplexF64,s[3,:]...)
    C=joMatrix(c;DDT=ComplexF64,RDT=ComplexF32)
    k=kron(a,b,c)
    K=joKron(A,B,C)
    Km=K.m
    Kn=K.n

    exp_exp=(1.)/(3.)
    verbose && println("$tsname ($Km,$Kn)")
    @testset "$Km x $Kn" begin
        sn=prod(s[:,2])
        sm=prod(s[:,1])
        vn=rand(ComplexF64,sn);
        vm=rand(ComplexF64,sm);
        mvn=rand(ComplexF64,sn,2);
        mvm=rand(ComplexF64,sm,2);
        @test norm(k*vn-K*vn)<eps(norm(k*vn))^exp_exp
        @test norm(k*mvn-K*mvn)<eps(norm(k*mvn))^exp_exp
        @test norm(transpose(k)*vm-transpose(K)*vm)<eps(norm(transpose(k)*vm))^exp_exp
        @test norm(transpose(k)*mvm-transpose(K)*mvm)<eps(norm(transpose(k)*mvm))^exp_exp
        @test norm(adjoint(k)*vm-adjoint(K)*vm)<eps(norm(adjoint(k)*vm))^exp_exp
        @test norm(adjoint(k)*mvm-adjoint(K)*mvm)<eps(norm(adjoint(k)*mvm))^exp_exp
        @test norm(conj(k)*vn-conj(K)*vn)<eps(norm(conj(k)*vn))^exp_exp
        @test norm(conj(k)*mvn-conj(K)*mvn)<eps(norm(conj(k)*mvn))^exp_exp
        @test norm((-k)*vn-(-K)*vn)<eps(norm((-k)*vn))^exp_exp
        @test norm((-k)*mvn-(-K)*mvn)<eps(norm((-k)*mvn))^exp_exp
    end

end # end test loop
end
