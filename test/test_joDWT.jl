T=3
tsname="joDWT"
@testset "$tsname" begin
for t=1:T # start test loop
    m=4^t
    v1=rand(m)
    v2=rand(m,m)
    vv2=vec(v2)

    wt=wavelet(WT.haar)
    A1=joDWT(m,wt)
    A2=joDWT(m,m,wt)
    verbose && println("$tsname ($m,$m) - planned")
    @testset "$m x $m" begin
        @test isadjoint(joDWT(m))[1]
        @test islinear(joDWT(m))[1]
        @test norm(A1*v1-dwt(v1,wt))<joTol
        @test norm(A1\v1-idwt(v1,wt))<joTol
        @test norm(adjoint(A1)*v1-idwt(v1,wt))<joTol
        @test norm((adjoint(A1)*A1)*v1-v1)<joTol
        @test isadjoint(joDWT(m,m))[1]
        @test islinear(joDWT(m,m))[1]
        @test norm(A2*vv2-vec(dwt(v2,wt)))<joTol
        @test norm(A2\vv2-vec(idwt(v2,wt)))<joTol
        @test norm(adjoint(A2)*vv2-vec(idwt(v2,wt)))<joTol
        @test norm((adjoint(A2)*A2)*vv2-vv2)<joTol
    end

end # end test loop
end
