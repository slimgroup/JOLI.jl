T=3
eps_exp=(1.)/(3.)
tsname="joCoreBlock - basic"
@testset "$tsname" begin
for t=1:T # start test loop

    s=rand(3:9,3)
    u=rand(7:11,2)
mo=vec([0 rand(0:u[1]) u[1]]) #rand(0:9,3)
no=vec([0 rand(0:u[2]) u[2]]) #rand(0:9,3)
m=max((mo+s)...)
n=max((no+circshift(s,-1))...)
    a=rand(Complex{Float64},s[1],s[2])
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64})
    b=rand(Complex{Float64},s[2],s[3])
    B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64})
    c=rand(Complex{Float64},s[3],s[1])
    C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64})
bm=zeros(Complex{Float64},m,n)
bm[(mo[1]+1):(mo[1]+s[1]),(no[1]+1):(no[1]+s[2])]+=a
bm[(mo[2]+1):(mo[2]+s[2]),(no[2]+1):(no[2]+s[3])]+=b
bm[(mo[3]+1):(mo[3]+s[3]),(no[3]+1):(no[3]+s[1])]+=c
    CB=joCoreBlock(A,B,C;moffsets=mo,noffsets=no)
    CBm=CB.m
    CBn=CB.n

    verbose && println("$tsname ($CBm,$CBn)")
    @testset "$CBm x $CBn" begin
        vn=rand(Complex{Float32},CBn);
        vm=rand(Complex{Float64},CBm);
        mvn=rand(Complex{Float32},CBn,2);
        mvm=rand(Complex{Float64},CBm,2);
        @test norm(bm*vn-CB*vn)<eps(norm(bm*vn))^eps_exp
        @test norm(bm*mvn-CB*mvn)<eps(norm(bm*mvn))^eps_exp
        @test norm(transpose(bm)*vm-transpose(CB)*vm)<eps(norm(transpose(bm)*vm))^eps_exp
        @test norm(transpose(bm)*mvm-transpose(CB)*mvm)<eps(norm(transpose(bm)*mvm))^eps_exp
        @test norm(adjoint(bm)*vm-adjoint(CB)*vm)<eps(norm(adjoint(bm)*vm))^eps_exp
        @test norm(adjoint(bm)*mvm-adjoint(CB)*mvm)<eps(norm(adjoint(bm)*mvm))^eps_exp
        @test norm(conj(bm)*vn-conj(CB)*vn)<eps(norm(conj(bm)*vn))^eps_exp
        @test norm(conj(bm)*mvn-conj(CB)*mvn)<eps(norm(conj(bm)*mvn))^eps_exp
        @test norm((-bm)*vn-(-CB)*vn)<eps(norm((-bm)*vn))^eps_exp
        @test norm((-bm)*mvn-(-CB)*mvn)<eps(norm((-bm)*mvn))^eps_exp
    end

end # end test loop
end
tsname="joCoreBlock - weighted"
@testset "$tsname" begin
for t=1:T # start test loop

    s=rand(3:9,3)
    u=rand(7:11,2)
    w=rand(Complex{Float64},3)
mo=vec([0 rand(0:u[1]) u[1]]) #rand(0:9,3)
no=vec([0 rand(0:u[2]) u[2]]) #rand(0:9,3)
m=max((mo+s)...)
n=max((no+circshift(s,-1))...)
    a=rand(Complex{Float64},s[1],s[2])
    A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64})
    b=rand(Complex{Float64},s[2],s[3])
    B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64})
    c=rand(Complex{Float64},s[3],s[1])
    C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64})
bm=zeros(Complex{Float64},m,n)
bm[(mo[1]+1):(mo[1]+s[1]),(no[1]+1):(no[1]+s[2])]+=w[1]*a
bm[(mo[2]+1):(mo[2]+s[2]),(no[2]+1):(no[2]+s[3])]+=w[2]*b
bm[(mo[3]+1):(mo[3]+s[3]),(no[3]+1):(no[3]+s[1])]+=w[3]*c
    CB=joCoreBlock(A,B,C;moffsets=mo,noffsets=no,weights=w)
    CBm=CB.m
    CBn=CB.n

    verbose && println("$tsname ($CBm,$CBn)")
    @testset "$CBm x $CBn" begin
        vn=rand(Complex{Float32},CBn);
        vm=rand(Complex{Float64},CBm);
        mvn=rand(Complex{Float32},CBn,2);
        mvm=rand(Complex{Float64},CBm,2);
        @test norm(bm*vn-CB*vn)<eps(norm(bm*vn))^eps_exp
        @test norm(bm*mvn-CB*mvn)<eps(norm(bm*mvn))^eps_exp
        @test norm(transpose(bm)*vm-transpose(CB)*vm)<eps(norm(transpose(bm)*vm))^eps_exp
        @test norm(transpose(bm)*mvm-transpose(CB)*mvm)<eps(norm(transpose(bm)*mvm))^eps_exp
        @test norm(adjoint(bm)*vm-adjoint(CB)*vm)<eps(norm(adjoint(bm)*vm))^eps_exp
        @test norm(adjoint(bm)*mvm-adjoint(CB)*mvm)<eps(norm(adjoint(bm)*mvm))^eps_exp
        @test norm(conj(bm)*vn-conj(CB)*vn)<eps(norm(conj(bm)*vn))^eps_exp
        @test norm(conj(bm)*mvn-conj(CB)*mvn)<eps(norm(conj(bm)*mvn))^eps_exp
        @test norm((-bm)*vn-(-CB)*vn)<eps(norm((-bm)*vn))^eps_exp
        @test norm((-bm)*mvn-(-CB)*mvn)<eps(norm((-bm)*mvn))^eps_exp
    end

end # end test loop
end
