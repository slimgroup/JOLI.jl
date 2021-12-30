T=3
tsname="joJRM"
@testset "$tsname" begin
    for t=2:T # start test loop
    
        ops = [joMatrix(randn(Float32, 2*t+8, 2*t)) for i = 1:t]
        γ = abs(randn(Float32))
        A=joJRM(ops; γ=γ)

        verbose && println("$tsname ($m)")
        @testset "1 common component and $t innovation components" begin
            @test isadjoint(A)[1]
            @test islinear(A)[1]
        end
    
    end # end test loop
end
