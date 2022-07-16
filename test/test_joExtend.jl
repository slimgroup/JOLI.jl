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
        for A ∈ [Az, Ab, Am, Ap]
            @test isadjoint(A)[1]
            @test islinear(A)[1]
            v = randn(size(A, 2))
            @test A * v == vec(A * reshape(v, :, 1))
        end
    end
    
end # end test loop
end
