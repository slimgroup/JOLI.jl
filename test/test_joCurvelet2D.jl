try
    h=Base.Libdl.dlopen(:libdfdct_wrapping)
    T=3
    Base.Libdl.dlclose(h)
catch
    T=0
    warn("Skipping Curvelet tests - libdfdct_wrapping not found")
end

tsname="joCurvelet2D"
@testset "$tsname" begin
for t=1:T # start test loop
    m=32*t
    Awr=joCurvelet2D(m,m)
    Awc=joCurvelet2D(m,m;DDT=Complex{Float64},real_crvlts=false)
    Acr=joCurvelet2D(m,m;all_crvlts=true)
    Acc=joCurvelet2D(m,m;DDT=Complex{Float64},all_crvlts=true,real_crvlts=false)

    println("$tsname ($m,$m)")
    @testset "$m x $m" begin
        @test isadjoint(Awr)[1]
        @test isadjoint(Awc)[1]
        @test isadjoint(Acr)[1]
        @test isadjoint(Acc)[1]
    end
    
end # end test loop
end
