T=9
tsname="joRomberg"
@testset "$tsname" begin
for t=2:T # start test loop
    m=4*t
    n=m+rand(-2:2:2)
    A=joRomberg(m,n)

    verbose && println("$tsname ($m)")
    @testset "$m x $m" begin
        @test isadjoint(A)[1]
        @test islinear(A)[1]
    end
    
end # end test loop
end
