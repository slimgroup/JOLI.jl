T=9
tsname="joGaussian"
@testset "$tsname" begin
for t=2:T # start test loop
    m=4*t
    n=m+rand(-2:2:2)
    A=joGaussian(m,n)
    An=joGaussian(m,n,normalized=true)
    Ai=joGaussian(m,n,implicit=true)
    Ain=joGaussian(m,n,implicit=true,normalized=true)
    Ao=joGaussian(m,orthonormal=true)
    Aor=joGaussian(m,m+2,orthonormal=true)

    verbose && println("$tsname ($m)")
    @testset "$m x $m" begin
        @test isadjoint(A)[1]
        @test isadjoint(An)[1]
        @test isadjoint(Ai)[1]
        @test isadjoint(Ain)[1]
        @test isadjoint(Ao)[1]
        @test isadjoint(Aor)[1]
        @test islinear(A)[1]
        @test islinear(An)[1]
        @test islinear(Ai)[1]
        @test islinear(Ain)[1]
        @test islinear(Ao)[1]
        @test islinear(Aor)[1]
    end
    
end # end test loop
end
