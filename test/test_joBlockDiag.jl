T=3
tsname="joBlockDiag"
@testset "$tsname" begin
for t=1:T # start test loop

    s=rand(3:9,3)
    a=rand(Complex{Float64},s[1],s[1])
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64})
    b=rand(Complex{Float64},s[2],s[2])
    B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64})
    c=rand(Complex{Float64},s[3],s[3])
    C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64})
    bd=[a                zeros(s[1],s[2]) zeros(s[1],s[3]);
       zeros(s[2],s[1]) b                zeros(s[2],s[3]);
       zeros(s[3],s[1]) zeros(s[3],s[2]) c]
    BD=joBlockDiag(A,B,C)
    BDm=BD.m
    BDn=BD.n

    println("$tsname ($BDm,$BDn)")
    @testset "$BDm x $BDn" begin
        sn=sum(s[:])
        sm=sum(s[:])
        vn=rand(Complex{Float32},sn);
        vm=rand(Complex{Float64},sm);
        mvn=rand(Complex{Float32},sn,2);
        mvm=rand(Complex{Float64},sm,2);
        @test norm(bd*vn-BD*vn)<eps(norm(bd*vn))^(1./3.)
        @test norm(bd*mvn-BD*mvn)<eps(norm(bd*mvn))^(1./3.)
        @test norm(bd.'*vm-BD.'*vm)<eps(norm(bd.'*vm))^(1./3.)
        @test norm(bd.'*mvm-BD.'*mvm)<eps(norm(bd.'*mvm))^(1./3.)
        @test norm(bd'*vm-BD'*vm)<eps(norm(bd'*vm))^(1./3.)
        @test norm(bd'*mvm-BD'*mvm)<eps(norm(bd'*mvm))^(1./3.)
        @test norm(conj(bd)*vn-conj(BD)*vn)<eps(norm(conj(bd)*vn))^(1./3.)
        @test norm(conj(bd)*mvn-conj(BD)*mvn)<eps(norm(conj(bd)*mvn))^(1./3.)
    end

end # end test loop
end
