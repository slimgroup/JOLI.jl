T=0
try
    h=Base.Libdl.dlopen(:libdfdct_wrapping)
    T=3
    Base.Libdl.dlclose(h)
catch
    warn("Skipping joCurvelet2DnoFFT tests - libdfdct_wrapping not found")
end

tsname="joCurvelet2DnoFFT"
@testset "$tsname" begin
for t=1:T # start test loop
    m=32*t
    Awr=joCurvelet2DnoFFT(m,m)*joDFT(m,m)
    Awc=joCurvelet2DnoFFT(m,m;real_crvlts=false)*joDFT(m,m)
    Acr=joCurvelet2DnoFFT(m,m;all_crvlts=true)*joDFT(m,m)
    Acc=joCurvelet2DnoFFT(m,m;all_crvlts=true,real_crvlts=false)*joDFT(m,m)

    println("$tsname ($m,$m)")
    @testset "$m x $m" begin
        @test isadjoint(Awr)[1]
        @test isadjoint(Awc)[1]
        @test isadjoint(Acr)[1]
        @test isadjoint(Acc)[1]
        @test islinear(Awr)[1]
        @test islinear(Awc)[1]
        @test islinear(Acr)[1]
        @test islinear(Acc)[1]
    end
    
end # end test loop
end
