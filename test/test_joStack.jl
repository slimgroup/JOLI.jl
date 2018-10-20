T=3
eps_exp=(1.)/(3.)
tsname="joStack - basic"
@testset "$tsname" begin
for t=1:T # start test loop

    s=rand(3:9,3)
    a=rand(ComplexF64,s[1],s[1])
    A=joMatrix(a;DDT=ComplexF32,RDT=ComplexF64)
    b=rand(ComplexF64,s[2],s[1])
    B=joMatrix(b;DDT=ComplexF32,RDT=ComplexF64)
    c=rand(ComplexF64,s[3],s[1])
    C=joMatrix(c;DDT=ComplexF32,RDT=ComplexF64)
    bd=cat(a,b,c,dims=1)
    BD=joStack(A,B,C)
    BDm=BD.m
    BDn=BD.n

    verbose && println("$tsname ($BDm,$BDn)")
    @testset "$BDm x $BDn" begin
        vn=rand(ComplexF32,BDn);
        vm=rand(ComplexF64,BDm);
        mvn=rand(ComplexF32,BDn,2);
        mvm=rand(ComplexF64,BDm,2);
        @test norm(bd*vn-BD*vn)<eps(norm(bd*vn))^eps_exp
        @test norm(bd*mvn-BD*mvn)<eps(norm(bd*mvn))^eps_exp
        @test norm(transpose(bd)*vm-transpose(BD)*vm)<eps(norm(transpose(bd)*vm))^eps_exp
        @test norm(transpose(bd)*mvm-transpose(BD)*mvm)<eps(norm(transpose(bd)*mvm))^eps_exp
        @test norm(adjoint(bd)*vm-adjoint(BD)*vm)<eps(norm(adjoint(bd)*vm))^eps_exp
        @test norm(adjoint(bd)*mvm-adjoint(BD)*mvm)<eps(norm(adjoint(bd)*mvm))^eps_exp
        @test norm(conj(bd)*vn-conj(BD)*vn)<eps(norm(conj(bd)*vn))^eps_exp
        @test norm(conj(bd)*mvn-conj(BD)*mvn)<eps(norm(conj(bd)*mvn))^eps_exp
        @test norm((-bd)*vn-(-BD)*vn)<eps(norm((-bd)*vn))^eps_exp
        @test norm((-bd)*mvn-(-BD)*mvn)<eps(norm((-bd)*mvn))^eps_exp
    end

end # end test loop
end
tsname="joStack - weighted"
@testset "$tsname" begin
for t=1:T # start test loop

    s=rand(3:9,3)
    w=rand(ComplexF64,3)
    a=rand(ComplexF64,s[1],s[1])
    A=joMatrix(a;DDT=ComplexF32,RDT=ComplexF64)
    b=rand(ComplexF64,s[2],s[1])
    B=joMatrix(b;DDT=ComplexF32,RDT=ComplexF64)
    c=rand(ComplexF64,s[3],s[1])
    C=joMatrix(c;DDT=ComplexF32,RDT=ComplexF64)
    bd=cat(w[1]*a,w[2]*b,w[3]*c,dims=1)
    BD=joStack(A,B,C;weights=w)
    BDm=BD.m
    BDn=BD.n

    verbose && println("$tsname ($BDm,$BDn)")
    @testset "$BDm x $BDn" begin
        vn=rand(ComplexF32,BDn);
        vm=rand(ComplexF64,BDm);
        mvn=rand(ComplexF32,BDn,2);
        mvm=rand(ComplexF64,BDm,2);
        @test norm(bd*vn-BD*vn)<eps(norm(bd*vn))^eps_exp
        @test norm(bd*mvn-BD*mvn)<eps(norm(bd*mvn))^eps_exp
        @test norm(transpose(bd)*vm-transpose(BD)*vm)<eps(norm(transpose(bd)*vm))^eps_exp
        @test norm(transpose(bd)*mvm-transpose(BD)*mvm)<eps(norm(transpose(bd)*mvm))^eps_exp
        @test norm(adjoint(bd)*vm-adjoint(BD)*vm)<eps(norm(adjoint(bd)*vm))^eps_exp
        @test norm(adjoint(bd)*mvm-adjoint(BD)*mvm)<eps(norm(adjoint(bd)*mvm))^eps_exp
        @test norm(conj(bd)*vn-conj(BD)*vn)<eps(norm(conj(bd)*vn))^eps_exp
        @test norm(conj(bd)*mvn-conj(BD)*mvn)<eps(norm(conj(bd)*mvn))^eps_exp
        @test norm((-bd)*vn-(-BD)*vn)<eps(norm((-bd)*vn))^eps_exp
        @test norm((-bd)*mvn-(-BD)*mvn)<eps(norm((-bd)*mvn))^eps_exp
    end

end # end test loop
end
tsname="joStack - replicated"
@testset "$tsname" begin
for t=1:T # start test loop

    s=rand(3:9)
    l=3
    w=rand(ComplexF64,l)
    a=rand(ComplexF64,s,s)
    A=joMatrix(a;DDT=ComplexF32,RDT=ComplexF64)
    bd=cat(w[1]*a,w[2]*a,w[3]*a,dims=1)
    BD=joStack(l,A;weights=w)
    BDm=BD.m
    BDn=BD.n

    verbose && println("$tsname ($BDm,$BDn)")
    @testset "$BDm x $BDn" begin
        vn=rand(ComplexF32,BDn);
        vm=rand(ComplexF64,BDm);
        mvn=rand(ComplexF32,BDn,2);
        mvm=rand(ComplexF64,BDm,2);
        @test norm(bd*vn-BD*vn)<eps(norm(bd*vn))^eps_exp
        @test norm(bd*mvn-BD*mvn)<eps(norm(bd*mvn))^eps_exp
        @test norm(transpose(bd)*vm-transpose(BD)*vm)<eps(norm(transpose(bd)*vm))^eps_exp
        @test norm(transpose(bd)*mvm-transpose(BD)*mvm)<eps(norm(transpose(bd)*mvm))^eps_exp
        @test norm(adjoint(bd)*vm-adjoint(BD)*vm)<eps(norm(adjoint(bd)*vm))^eps_exp
        @test norm(adjoint(bd)*mvm-adjoint(BD)*mvm)<eps(norm(adjoint(bd)*mvm))^eps_exp
        @test norm(conj(bd)*vn-conj(BD)*vn)<eps(norm(conj(bd)*vn))^eps_exp
        @test norm(conj(bd)*mvn-conj(BD)*mvn)<eps(norm(conj(bd)*mvn))^eps_exp
        @test norm((-bd)*vn-(-BD)*vn)<eps(norm((-bd)*vn))^eps_exp
        @test norm((-bd)*mvn-(-BD)*mvn)<eps(norm((-bd)*mvn))^eps_exp
    end

end # end test loop
end
