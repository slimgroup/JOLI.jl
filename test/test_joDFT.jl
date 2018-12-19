T=3
tsname="joDFT"
@testset "$tsname" begin
for t=1:T # start test loop
    m=4^t
    v1=rand(ComplexF64,m)
    mv1=rand(ComplexF64,m,m)
    v2=rand(ComplexF64,m,m)
    vv2=vec(v2)
    mv2=rand(ComplexF64,m,m,m)
    vmv2=reshape(mv2,m*m,m)

    A1=joDFT(m;DDT=ComplexF64)
    A2=joDFT(m,m;DDT=ComplexF64)
    verbose && println("$tsname ($m[,$m]) - planned")
    @testset "$m [x $m]" begin
        @test isadjoint(joDFT(m))[1]
        @test isadjoint(joDFT(m;centered=true))[1]
        @test islinear(joDFT(m))[1]
        @test islinear(joDFT(m;centered=true))[1]
        @test isadjoint(joDFT(m,m))[1]
        @test isadjoint(joDFT(m,m;centered=true))[1]
        @test islinear(joDFT(m,m))[1]
        @test islinear(joDFT(m,m;centered=true))[1]

        @test norm(A1*v1-fft(v1)/sqrt(m))<joTol
        @test norm(A1\v1-ifft(v1)*sqrt(m))<joTol
        @test norm(adjoint(A1)*v1-ifft(v1)*sqrt(m))<joTol
        @test norm((adjoint(A1)*A1)*v1-v1)<joTol
        @test norm(A1*mv1-fft(mv1,1)/sqrt(m))<joTol
        @test norm(A1\mv1-ifft(mv1,1)*sqrt(m))<joTol
        @test norm(adjoint(A1)*mv1-ifft(mv1,1)*sqrt(m))<joTol
        @test norm((adjoint(A1)*A1)*mv1-mv1)<joTol

        @test norm(A2*vv2-vec(fft(v2))/sqrt(m^2))<joTol
        @test norm(A2\vv2-vec(ifft(v2))*sqrt(m^2))<joTol
        @test norm(adjoint(A2)*vv2-vec(ifft(v2))*sqrt(m^2))<joTol
        @test norm((adjoint(A2)*A2)*vv2-vv2)<joTol
        @test norm(vec(A2*vmv2)-vec(fft(mv2,1:2))/sqrt(m^2))<joTol
        @test norm(vec(A2\vmv2)-vec(ifft(mv2,1:2))*sqrt(m^2))<joTol
        @test norm(vec(adjoint(A2)*vmv2)-vec(ifft(mv2,1:2))*sqrt(m^2))<joTol
        @test norm((adjoint(A2)*A2)*vmv2-vmv2)<joTol
    end

    A1=joDFT(m;planned=false,DDT=ComplexF64)
    A2=joDFT(m,m;planned=false,DDT=ComplexF64)
    verbose && println("$tsname ($m[,$m]) - not planned")
    @testset "$m [x $m]" begin
        @test isadjoint(joDFT(m;planned=false))[1]
        @test isadjoint(joDFT(m;planned=false,centered=true))[1]
        @test islinear(joDFT(m;planned=false))[1]
        @test islinear(joDFT(m;planned=false,centered=true))[1]
        @test isadjoint(joDFT(m,m;planned=false))[1]
        @test isadjoint(joDFT(m,m;planned=false,centered=true))[1]
        @test islinear(joDFT(m,m;planned=false))[1]
        @test islinear(joDFT(m,m;planned=false,centered=true))[1]

        @test norm(A1*v1-fft(v1)/sqrt(m))<joTol
        @test norm(A1\v1-ifft(v1)*sqrt(m))<joTol
        @test norm(adjoint(A1)*v1-ifft(v1)*sqrt(m))<joTol
        @test norm((adjoint(A1)*A1)*v1-v1)<joTol
        @test norm(A1*mv1-fft(mv1,1)/sqrt(m))<joTol
        @test norm(A1\mv1-ifft(mv1,1)*sqrt(m))<joTol
        @test norm(adjoint(A1)*mv1-ifft(mv1,1)*sqrt(m))<joTol
        @test norm((adjoint(A1)*A1)*mv1-mv1)<joTol

        @test norm(A2*vv2-vec(fft(v2))/sqrt(m^2))<joTol
        @test norm(A2\vv2-vec(ifft(v2))*sqrt(m^2))<joTol
        @test norm(adjoint(A2)*vv2-vec(ifft(v2))*sqrt(m^2))<joTol
        @test norm((adjoint(A2)*A2)*vv2-vv2)<joTol
        @test norm(vec(A2*vmv2)-vec(fft(mv2,1:2))/sqrt(m^2))<joTol
        @test norm(vec(A2\vmv2)-vec(ifft(mv2,1:2))*sqrt(m^2))<joTol
        @test norm(vec(adjoint(A2)*vmv2)-vec(ifft(mv2,1:2))*sqrt(m^2))<joTol
        @test norm((adjoint(A2)*A2)*vmv2-vmv2)<joTol
    end

end # end test loop
end
