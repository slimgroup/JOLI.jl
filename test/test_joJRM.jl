T=3
tsname="joJRM"
rtol = 1f-5
@testset "$tsname" begin
    for t=2:T # start test loop
    
        ops = [joDiag(randn(Float32,t); DDT=Float32, RDT=Float64) for i = 1:t]
        γ = Float32(sqrt(t))
        A=joJRM(ops; γ=γ)

        verbose && println("$tsname ($m)")
        @testset "$tsname w/ $t vintages" begin
            x1 = [randn(Float32, t) for i = 1:t+1]
            x2 = [randn(Float32, t) for i = 1:t+1]
            y = [randn(Float64, t) for i = 1:t]
            # test if it works as expected
            Ax1 = A*x1
            Ax1_ = ops.*[1f0/γ*x1[1]+x1[i] for i = 2:t+1]
            @test isapprox(Ax1, Ax1_; rtol=rtol)
            Aadjy = A'*y
            Aadjy_ = [ops[i]'*y[i] for i = 1:t]
            Aadjy_ = [1f0/γ*sum(Aadjy_), Aadjy_...]
            @test isapprox(Aadjy, Aadjy_; rtol=rtol)
            # test adjoint
            d1 = dot(y,Ax1)
            d2 = dot(x1,Aadjy)
            @test isapprox(d1, d2; rtol=rtol)
            # test linearity
            Ax2 = A*x2
            y1 = A*(x1+x2)
            y2 = Ax1+Ax2
            @test isapprox(y1, y2; rtol=rtol)
        end
    
    end # end test loop
end
