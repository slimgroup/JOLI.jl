T=3
eps_exp=(1.)/(3.)
tsname="joBlock - basic"
@testset "$tsname" begin
for t=1:T # start test loop

    cn=rand(2:9,3)
    rm=rand(2:9,3)
    a1=rand(ComplexF64,rm[1],cn[1])
    A1=joMatrix(a1;DDT=ComplexF32,RDT=ComplexF64)
    a2=rand(ComplexF64,rm[1],cn[2])
    A2=joMatrix(a2;DDT=ComplexF32,RDT=ComplexF64)
    a3=rand(ComplexF64,rm[1],cn[3])
    A3=joMatrix(a3;DDT=ComplexF32,RDT=ComplexF64)
    b1=rand(ComplexF64,rm[2],cn[2])
    B1=joMatrix(b1;DDT=ComplexF32,RDT=ComplexF64)
    b2=rand(ComplexF64,rm[2],cn[3])
    B2=joMatrix(b2;DDT=ComplexF32,RDT=ComplexF64)
    b3=rand(ComplexF64,rm[2],cn[1])
    B3=joMatrix(b3;DDT=ComplexF32,RDT=ComplexF64)
    c1=rand(ComplexF64,rm[3],cn[3])
    C1=joMatrix(c1;DDT=ComplexF32,RDT=ComplexF64)
    c2=rand(ComplexF64,rm[3],cn[1])
    C2=joMatrix(c2;DDT=ComplexF32,RDT=ComplexF64)
    c3=rand(ComplexF64,rm[3],cn[2])
    C3=joMatrix(c3;DDT=ComplexF32,RDT=ComplexF64)
    bd=[a1 a2 a3; b1 b2 b3; c1 c2 c3]
    BD=joBlock([3,3,3],A1,A2,A3,B1,B2,B3,C1,C2,C3)
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
tsname="joBlock - weighted"
@testset "$tsname" begin
for t=1:T # start test loop

    cn=rand(2:9,3)
    rm=rand(2:9,3)
    w=rand(ComplexF64,9)
    a1=rand(ComplexF64,rm[1],cn[1])
    A1=joMatrix(a1;DDT=ComplexF32,RDT=ComplexF64)
    a2=rand(ComplexF64,rm[1],cn[2])
    A2=joMatrix(a2;DDT=ComplexF32,RDT=ComplexF64)
    a3=rand(ComplexF64,rm[1],cn[3])
    A3=joMatrix(a3;DDT=ComplexF32,RDT=ComplexF64)
    b1=rand(ComplexF64,rm[2],cn[2])
    B1=joMatrix(b1;DDT=ComplexF32,RDT=ComplexF64)
    b2=rand(ComplexF64,rm[2],cn[3])
    B2=joMatrix(b2;DDT=ComplexF32,RDT=ComplexF64)
    b3=rand(ComplexF64,rm[2],cn[1])
    B3=joMatrix(b3;DDT=ComplexF32,RDT=ComplexF64)
    c1=rand(ComplexF64,rm[3],cn[3])
    C1=joMatrix(c1;DDT=ComplexF32,RDT=ComplexF64)
    c2=rand(ComplexF64,rm[3],cn[1])
    C2=joMatrix(c2;DDT=ComplexF32,RDT=ComplexF64)
    c3=rand(ComplexF64,rm[3],cn[2])
    C3=joMatrix(c3;DDT=ComplexF32,RDT=ComplexF64)
    bd=[w[1]*a1 w[2]*a2 w[3]*a3; w[4]*b1 w[5]*b2 w[6]*b3; w[7]*c1 w[8]*c2 w[9]*c3]
    BD=joBlock([3,3,3],A1,A2,A3,B1,B2,B3,C1,C2,C3;weights=w)
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
