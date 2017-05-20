T=0
try
    h=Base.Libdl.dlopen(:libdfdct_wrapping)
    T=3
    Base.Libdl.dlclose(h)
catch
    warn("Skipping Curvelet tests - libdfdct_wrapping not found")
end

tsname="joCurvelet2DnoFFT"
@testset "$tsname" begin
for t=1:T # start test loop
    m=32*t
    Awr=joCurvelet2DnoFFT(m,m)
    Acr=joCurvelet2DnoFFT(m,m;all_crvlts=true)

    println("$tsname ($m,$m)")
    @testset "$m x $m" begin
        @test isadjoint(Awr)[1]
        @test isadjoint(Acr)[1]
        @test islinear(Awr)[1]
        @test islinear(Acr)[1]
    end
    
end # end test loop
end
