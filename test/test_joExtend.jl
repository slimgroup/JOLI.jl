T=9
tsname="joExtend"
@testset "$tsname" begin
for t=1:T # start test loop
    n=8*t
    l=rand(0:n)
    u=rand(0:n)
    m=n+l+u
    Az=joExtend(n,:zeros,pad_lower=l,pad_upper=u)
    Ab=joExtend(n,:border,pad_lower=l,pad_upper=u)
    Am=joExtend(n,:mirror,pad_lower=l,pad_upper=u)
    Ap=joExtend(n,:periodic,pad_lower=l,pad_upper=u)

    verbose && println("$tsname ($n,$l,$u)")
    @testset "$n x $m" begin
        @test isadjoint(Az)[1]
        @test isadjoint(Ab)[1]
        @test isadjoint(Am)[1]
        @test isadjoint(Ap)[1]
        @test islinear(Az)[1]
        @test islinear(Ab)[1]
        @test islinear(Am)[1]
        @test islinear(Ap)[1]
    end
    
end # end test loop
end
