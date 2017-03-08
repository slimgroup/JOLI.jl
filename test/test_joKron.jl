T=3
tsname="joKron"
@testset "$tsname" begin
for t=1:T # start test loop

    s=rand(3:9,3,2)
    a=rand(Complex{Float64},s[1,:]...)
    A=joMatrix(a)
    b=rand(Complex{Float64},s[2,:]...)
    B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64})
    c=rand(Complex{Float64},s[3,:]...)
    C=joMatrix(c;DDT=Complex{Float64},RDT=Complex{Float32})
    k=kron(a,b,c)
    K=joKron(A,B,C)
    Km=K.m
    Kn=K.n

    println("$tsname ($Km,$Kn)")
    @testset "$Km x $Kn" begin
        sn=prod(s[:,2])
        sm=prod(s[:,1])
        vn=rand(Complex{Float64},sn);
        vm=rand(Complex{Float64},sm);
        mvn=rand(Complex{Float64},sn,2);
        mvm=rand(Complex{Float64},sm,2);
        @test norm(k*vn-K*vn)<eps(norm(k*vn))^(1./3.)
        @test norm(k*mvn-K*mvn)<eps(norm(k*mvn))^(1./3.)
        @test norm(k.'*vm-K.'*vm)<eps(norm(k.'*vm))^(1./3.)
        @test norm(k.'*mvm-K.'*mvm)<eps(norm(k.'*mvm))^(1./3.)
        @test norm(k'*vm-K'*vm)<eps(norm(k'*vm))^(1./3.)
        @test norm(k'*mvm-K'*mvm)<eps(norm(k'*mvm))^(1./3.)
        @test norm(conj(k)*vn-conj(K)*vn)<eps(norm(conj(k)*vn))^(1./3.)
        @test norm(conj(k)*mvn-conj(K)*mvn)<eps(norm(conj(k)*mvn))^(1./3.)
    end

end # end test loop
end
