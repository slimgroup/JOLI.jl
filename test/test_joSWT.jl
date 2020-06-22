try
    global pywt = pyimport("pywt")
    global swt = pywt.swt
catch
    @warn "Skipping joSWTtests - PyCall clouldn't import PyWavelets"
end

families = ("haar", "db", "sym", "coif")
wavelets = vcat([pywt.wavelist(name) for name in families]...)

tsname="joSWT"
@testset "$tsname" begin
for w in wavelets
    m = 1024
    Swt = joSWT(m, w)
    u = rand(m)
    v = rand(size(Swt, 1))
    verbose && println("$tsname, $w")
    @testset "$w" begin
        @test isadjoint(Swt)[1]
        @test islinear(Swt)[1]
    end
    
end # end test loop
end
