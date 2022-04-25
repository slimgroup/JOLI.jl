T=3
tsname="joNFFT"
@testset "$tsname" begin
for t=1:T # start test loop
    m=4^t
    n=3^t
    nodes=sort(rand(joFloat,n)) .- joFloat(.5)

    verbose && println("$tsname ($m[,$m]) - not centered")
    @testset "$m [x $m]" begin
        @test isadjoint(joNFFT(m,nodes))[1]
        @test islinear(joNFFT(m,nodes))[1]
    end

    verbose && println("$tsname ($m[,$m]) - centered")
    @testset "$m [x $m]" begin
        @test isadjoint(joNFFT(m,nodes,centered=true))[1]
        @test islinear(joNFFT(m,nodes,centered=true))[1]
    end
    
end # end test loop
end
