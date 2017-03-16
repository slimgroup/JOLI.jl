T=3
tsname="joDFT"
@testset "$tsname" begin
for t=1:T # start test loop
    m=4^t
    v1=rand(Complex{Float64},m)
    v2=rand(Complex{Float64},m,m)
    vv2=vec(v2)
    A1=joDFT(m;DDT=Complex{Float64})
    A2=joDFT(m,m;DDT=Complex{Float64})

    println("$tsname ($m,$m)")
    @testset "$m x $m" begin
        @test isadjoint(joDFT(m))[1]
        @test isadjoint(joDFT(m;centered=true))[1]
        @test islinear(joDFT(m))[1]
        @test islinear(joDFT(m;centered=true))[1]
        @test norm(A1*v1-fft(v1)/sqrt(m))<joTol
        @test norm(A1\v1-ifft(v1)*sqrt(m))<joTol
        @test norm(A1'*v1-ifft(v1)*sqrt(m))<joTol
        @test norm((A1'*A1)*v1-v1)<joTol
        @test isadjoint(joDFT(m,m))[1]
        @test isadjoint(joDFT(m,m;centered=true))[1]
        @test islinear(joDFT(m,m))[1]
        @test islinear(joDFT(m,m;centered=true))[1]
        @test norm(A2*vv2-vec(fft(v2))/sqrt(m^2))<joTol
        @test norm(A2\vv2-vec(ifft(v2))*sqrt(m^2))<joTol
        @test norm(A2'*vv2-vec(ifft(v2))*sqrt(m^2))<joTol
        @test norm((A2'*A2)*vv2-vv2)<joTol
    end
    
end # end test loop
end
