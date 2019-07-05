T=9
tsname="joOuterProd"
@testset "$tsname" begin
for t=T-2:T # start test loop
    m=t
    n=m+rand(-2:2:2)
    ccA=joOuterProd(rand(joComplex,m,2),rand(joComplex,n,2);DDT=joComplex)
    crA=joOuterProd(rand(joComplex,m,2),rand(joFloat,n,2);DDT=joComplex)
    rcA=joOuterProd(rand(joFloat,m),rand(joComplex,n);DDT=joComplex)
    rrA=joOuterProd(rand(joFloat,m),rand(joFloat,n);DDT=joFloat)

    verbose && println("$tsname ($m x $n)")
    @testset "$m x $n" begin
        @test isadjoint(ccA)[1]
        @test islinear(ccA)[1]
        @test isadjoint(crA)[1]
        @test islinear(crA)[1]
        @test isadjoint(rcA)[1]
        @test islinear(rcA)[1]
        @test isadjoint(rrA)[1]
        @test islinear(rrA)[1]
    end
    
end # end test loop
end
