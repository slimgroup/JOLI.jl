T=3
tsname="joDCT"
@testset "$tsname" begin
for t=1:T # start test loop
    m=4^t
    v1=rand(m)
    mv1=rand(m,m)
    v2=rand(m,m)
    vv2=vec(v2)
    mv2=rand(m,m,m)
    vmv2=reshape(mv2,m*m,m)

    A1=joDCT(m)
    A2=joDCT(m,m)
    verbose && println("$tsname ($m,$m) - planned")
    @testset "$m x $m" begin
        @test isadjoint(joDCT(m))[1]
        @test islinear(joDCT(m))[1]
        @test isadjoint(joDCT(m,m))[1]
        @test islinear(joDCT(m,m))[1]

        @test norm(A1*v1-dct(v1))<joTol
        @test norm(A1\v1-idct(v1))<joTol
        @test norm(adjoint(A1)*v1-idct(v1))<joTol
        @test norm((adjoint(A1)*A1)*v1-v1)<joTol
        @test norm(A1*mv1-dct(mv1,1))<joTol
        @test norm(A1\mv1-idct(mv1,1))<joTol
        @test norm(adjoint(A1)*mv1-idct(mv1,1))<joTol
        @test norm((adjoint(A1)*A1)*mv1-mv1)<joTol

        @test norm(A2*vv2-vec(dct(v2)))<joTol
        @test norm(A2\vv2-vec(idct(v2)))<joTol
        @test norm(adjoint(A2)*vv2-vec(idct(v2)))<joTol
        @test norm((adjoint(A2)*A2)*vv2-vv2)<joTol
        @test norm(vec(A2*vmv2)-vec(dct(mv2,1:2)))<joTol
        @test norm(vec(A2\vmv2)-vec(idct(mv2,1:2)))<joTol
        @test norm(vec(adjoint(A2)*vmv2)-vec(idct(mv2,1:2)))<joTol
        @test norm((adjoint(A2)*A2)*vmv2-vmv2)<joTol
    end

    A1=joDCT(m;planned=false)
    A2=joDCT(m,m;planned=false)
    verbose && println("$tsname ($m,$m) - not planned")
    @testset "$m x $m" begin
        @test isadjoint(joDCT(m;planned=false))[1]
        @test islinear(joDCT(m;planned=false))[1]
        @test isadjoint(joDCT(m,m;planned=false))[1]
        @test islinear(joDCT(m,m;planned=false))[1]

        @test norm(A1*v1-dct(v1))<joTol
        @test norm(A1\v1-idct(v1))<joTol
        @test norm(adjoint(A1)*v1-idct(v1))<joTol
        @test norm((adjoint(A1)*A1)*v1-v1)<joTol
        @test norm(A1*mv1-dct(mv1,1))<joTol
        @test norm(A1\mv1-idct(mv1,1))<joTol
        @test norm(adjoint(A1)*mv1-idct(mv1,1))<joTol
        @test norm((adjoint(A1)*A1)*mv1-mv1)<joTol

        @test norm(A2*vv2-vec(dct(v2)))<joTol
        @test norm(A2\vv2-vec(idct(v2)))<joTol
        @test norm(adjoint(A2)*vv2-vec(idct(v2)))<joTol
        @test norm((adjoint(A2)*A2)*vv2-vv2)<joTol
        @test norm(vec(A2*vmv2)-vec(dct(mv2,1:2)))<joTol
        @test norm(vec(A2\vmv2)-vec(idct(mv2,1:2)))<joTol
        @test norm(vec(adjoint(A2)*vmv2)-vec(idct(mv2,1:2)))<joTol
        @test norm((adjoint(A2)*A2)*vmv2-vmv2)<joTol
    end
    
end # end test loop
end
