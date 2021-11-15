T=3
tsname="joJRM"

@testset "$tsname" begin
    for t=2:T # start test loop
    
        ops = [joDiag(randn(Float32,t); DDT=Float32, RDT=Float32) for i = 1:t]
        γ = sqrt(t)
        A=joJRM(ops; γ=γ)

        verbose && println("$tsname ($m)")
        @testset "$tsname w/ $t vintages" begin
            # test adjoint
            x = [randn(Float32, t) for i = 1:t+1]
            y = [randn(Float32, t) for i = 1:t]
            d1 = dot(y,A*x)
            d2 = dot(x,A'*y)
            @test isapprox(d1, d2; rtol=1f3*max(eps(abs(d1)),eps(abs(d2))))
            # test linearity
            x1 = [randn(Float32, t) for i = 1:t+1]
            x2 = [randn(Float32, t) for i = 1:t+1]
            y1 = A*(x1+x2)
            y2 = A*x1 + A*x2
            @test isapprox(y1, y2; rtol=max(eps(abs(norm(y1))),eps(abs(norm(y2)))))
        end
    
    end # end test loop
end
