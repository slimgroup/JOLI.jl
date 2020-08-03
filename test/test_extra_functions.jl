# Unit tests for extra joli functions
# Rafael Orozco (rorozco@gatech.edu)
# July 2021

using JOLI, Test, LinearAlgebra

################################################# test isposdef ####################################################

@testset "Extra Functions Unit Tests" begin

    # set up operator that should be posdef
    A = [1.0 0.0;
         0.0 1.0]
    jo_A = joMatrix(A);
    @test JOLI.isposdef(jo_A)[1]

    # set up operator that is a complex matrix but posdef 
    k = 4
    B = complex.(randn(k,k),randn(k,k))
    A = B*B'
    jo_A = joMatrix(A);
    @test JOLI.isposdef(jo_A)[1]

    # set up operator that should NOT be posdef
    A = [-1.0 0.0;
         0.0 -1.0]
    jo_A = joMatrix(A);
    @test !JOLI.isposdef(jo_A)[1]

    # set up operator that should NOT be posdef because of imaginary result. 
    k = 4
    A = complex.(randn(k,k),randn(k,k))
    jo_A = joMatrix(A);
    @test !JOLI.isposdef(jo_A)[1]


#################################################### test normest ###################################################

    # set up operator and compare with opnorm()
    A = [1.0 0.0;
         0.0 1.0]
    jo_A = joMatrix(A);
    @test isapprox(normest(jo_A), opnorm(A))

    A = randn(5,5)
    jo_A = joMatrix(A);
    @test isapprox(normest(jo_A), opnorm(A);atol=1e-1)

    #more iterations should make the approximation better
    A = randn(5,5)
    jo_A = joMatrix(A);
    @test isapprox(normest(jo_A; numiters=20), opnorm(A);atol=1e-3)
   

end
