T=0
try
    h=dlopen(:libdfdct_wrapping)
    global T=3
    dlclose(h)
catch
    @warn "Skipping joCurvelet2D tests - libdfdct_wrapping not found"
end

tsname="joCurvelet2D"
@testset "$tsname" begin
for t=1:T # start test loop
    m=32*t
    Awr=joCurvelet2D(m,m)
    Awc=joCurvelet2D(m,m;DDT=ComplexF64,real_crvlts=false)
    Acr=joCurvelet2D(m,m;all_crvlts=true)
    Acc=joCurvelet2D(m,m;DDT=ComplexF64,all_crvlts=true,real_crvlts=false)

    verbose && println("$tsname ($m,$m)")
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
