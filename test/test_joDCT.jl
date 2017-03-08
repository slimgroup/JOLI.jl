T=3
tsname="joDCT"
@testset "$tsname" begin
for t=1:T # start test loop
    m=4^t
    v1=rand(m)
    v2=rand(m,m)
    vv2=vec(v2)
    A1=joDCT(m)
    A2=joDCT(m,m)

    println("$tsname ($m,$m)")
    @testset "$m x $m" begin
        @test isadjoint(joDCT(m))[1]
        @test norm(A1*v1-dct(v1))<joTol
        @test norm(A1\v1-idct(v1))<joTol
        @test norm(A1'*v1-idct(v1))<joTol
        @test norm((A1'*A1)*v1-v1)<joTol
        @test isadjoint(joDCT(m,m))[1]
        @test norm(A2*vv2-vec(dct(v2)))<joTol
        @test norm(A2\vv2-vec(idct(v2)))<joTol
        @test norm(A2'*vv2-vec(idct(v2)))<joTol
        @test norm((A2'*A2)*vv2-vv2)<joTol
    end
    
end # end test loop
end
