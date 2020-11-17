tsname="joSincInterp"
@testset "$tsname" begin
    xin = range(0.0, 10.0, length=201)
    xout = range(0.0, 10.0, length=401)
    # Difference in dx
    scale = 2
    # Input coarser
    Is = joSincInterp(xin, xout)
    @test isadjoint(Is)[1]
    v = sin.(pi .* xin)
    vi = Is*v
    # Makes sure we do not have unwanted zeros
    @test vi[2] != 0
    # Verifies some known values
    @test isapprox(maximum(vi), maximum(v))
    @test isapprox(v[11], vi[21])

    # Output coarser
    Is = joSincInterp(xout, xin)
    @test isadjoint(Is)[1]
    v = sin.(pi .* xout)
    vi = Is*v
    # Verifies some known values
    @test isapprox(maximum(vi), maximum(v))
    @test isapprox(v[21], vi[11])
end
