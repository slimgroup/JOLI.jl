T=3
tsname="joBlockDiag - basic"
@testset "$tsname" begin
for t=1:T # start test loop

    s=rand(3:9,3)
    a=rand(Complex{Float64},s[1],s[1])
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64})
    b=rand(Complex{Float64},s[2],s[2])
    B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64})
    c=rand(Complex{Float64},s[3],s[3])
    C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64})
    bd=cat([1 2],a,b,c)
    BD=joBlockDiag(A,B,C)
    BDm=BD.m
    BDn=BD.n

    println("$tsname ($BDm,$BDn)")
    @testset "$BDm x $BDn" begin
        vn=rand(Complex{Float32},BDn);
        vm=rand(Complex{Float64},BDm);
        mvn=rand(Complex{Float32},BDn,2);
        mvm=rand(Complex{Float64},BDm,2);
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
tsname="joBlockDiag - weighted"
@testset "$tsname" begin
for t=1:T # start test loop

    s=rand(3:9,3)
    w=rand(Complex{Float64},3)
    a=rand(Complex{Float64},s[1],s[1])
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64})
    b=rand(Complex{Float64},s[2],s[2])
    B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64})
    c=rand(Complex{Float64},s[3],s[3])
    C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64})
    bd=cat([1 2],w[1]*a,w[2]*b,w[3]*c)
    BD=joBlockDiag(A,B,C;weights=w)
    BDm=BD.m
    BDn=BD.n

    println("$tsname ($BDm,$BDn)")
    @testset "$BDm x $BDn" begin
        vn=rand(Complex{Float32},BDn);
        vm=rand(Complex{Float64},BDm);
        mvn=rand(Complex{Float32},BDn,2);
        mvm=rand(Complex{Float64},BDm,2);
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
tsname="joBlockDiag - replicated"
@testset "$tsname" begin
for t=1:T # start test loop

    s=rand(3:9)
    l=3
    w=rand(Complex{Float64},l)
    a=rand(Complex{Float64},s,s)
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64})
    bd=cat([1 2],w[1]*a,w[2]*a,w[3]*a)
    BD=joBlockDiag(l,A;weights=w)
    BDm=BD.m
    BDn=BD.n

    println("$tsname ($BDm,$BDn)")
    @testset "$BDm x $BDn" begin
        vn=rand(Complex{Float32},BDn);
        vm=rand(Complex{Float64},BDm);
        mvn=rand(Complex{Float32},BDn,2);
        mvm=rand(Complex{Float64},BDm,2);
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
