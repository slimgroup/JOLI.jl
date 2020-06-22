pywavelet= false
try
    global pywt = pyimport("pywt")
    global swt = pywt.swt
    global pywavelet = true
catch
    @warn "Skipping joSWTtests - PyCall clouldn't import PyWavelets"
end

families = ("haar", "db", "sym", "coif")
pywavelet ? wavelets = vcat([pywt.wavelist(name) for name in families]...) : wavelets = []

tsname="joSWT"
@testset "$tsname" begin
for w in wavelets
    for m in [124, 125]
        Swt = joSWT(m, w)
        u = rand(m)
        v = Swt*u
        verbose && println("$tsname, $w, $m")
        @testset "$w, $m" begin
            @test isadjoint(Swt)[1]
            @test islinear(Swt)[1]
            # Test orthogonality
            @test norm((adjoint(Swt)*Swt)* u - u) < joTol
            @test norm((Swt*adjoint(Swt))* v - v) < joTol
        end
    end
end # end test loop
end
