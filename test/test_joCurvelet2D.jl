T=3
tsname="joCurvelet2D"
@testset "$tsname" begin
for t=1:T # start test loop
    m=32*t
    Awr=joCurvelet2D(m,m)
    Awc=joCurvelet2D(m,m;real_crvlts=false)
    Acr=joCurvelet2D(m,m;all_crvlts=true)
    Acc=joCurvelet2D(m,m;all_crvlts=true,real_crvlts=false)

println("$tsname ($m,$m)")
    @testset "$m x $m" begin
        @test isadjoint(Awr)
        @test isadjoint(Awc)
        @test isadjoint(Acr)
        @test isadjoint(Acc)
    end
    
end # end test loop
end
