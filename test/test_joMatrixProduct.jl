T=6
tsname="joMatrix - Product"
@testset "$tsname" begin
for t=1:T # start test loop

if t<=2
    (m,n)=(5,5)
else
    (m,n)=(rand(3:7),rand(3:7))
end

if t%2==1
    tname="loop $t for real($m,$n)"
    a=rand(m,n)
    b=rand(m,n)
    vn=rand(n)
    mvn=rand(n,2)
    vm=rand(m)
    mvm=rand(m,2)
else
    tname="loop $t for complex($m,$n)"
    a=rand(Complex{Float64},m,n)
    b=rand(Complex{Float64},m,n)
    vn=rand(Complex{Float64},n)
    mvn=rand(Complex{Float64},n,2)
    vm=rand(Complex{Float64},m)
    mvm=rand(Complex{Float64},m,2)
end
A=joMatrix(a)
B=joMatrix(b)
c=a*b'
C=A*B'

println("$tsname $tname")
    @testset "$tname A*B" begin
        @test size(C)==size(c)
        @test length(C)==length(c)
        @test norm(full(C)-c)<joTol
        @test norm(double(C)-c)<joTol
        @test norm(C)-norm(c)<joTol
        for i=1:2
            @test norm(C,i)-norm(c,i)<joTol
        end
        @test norm(C,Inf)-norm(c,Inf)<joTol
        @test vecnorm(C)-vecnorm(c)<joTol
        for i=1:2
            @test vecnorm(C,i)-vecnorm(c,i)<joTol
        end
        @test vecnorm(C,Inf)-vecnorm(c,Inf)<joTol
        @test norm(double(C')-c')<joTol
        @test norm(double(C.')-c.')<joTol
        @test norm(double(+C)-(+c))<joTol
        @test norm(double(-C)-(-c))<joTol
        @test norm(C*vm-c*vm)<joTol
        @test norm(C*mvm-c*mvm)<joTol
        @test norm(C'*vm-c'*vm)<joTol
        @test norm(C'*mvm-c'*mvm)<joTol
        @test norm(C.'*vm-c.'*vm)<joTol
        @test norm(C.'*mvm-c.'*mvm)<joTol
        @test norm((C.')'*vm-(c.')'*vm)<joTol
        @test norm((C.')'*mvm-(c.')'*mvm)<joTol
        @test norm((C').'*vm-(c').'*vm)<joTol
        @test norm((C').'*mvm-(c').'*mvm)<joTol
        @test norm(double(C.'*C)-(c.'*c))<joTol
        @test norm(double(C*C.')-(c*c.'))<joTol
        @test norm(double(C'*C)-(c'*c))<joTol
        @test norm(double(C*C')-(c*c'))<joTol
        #@test norm(C\vm-c\vm)<joTol
        #@test norm(C\mvm-c\mvm)<joTol
        #@test norm(C'\vm-c'\vm)<joTol
        #@test norm(C'\mvm-c'\mvm)<joTol
        #@test norm(C.'\vn-c.'\vn)<joTol
        #@test norm(C.'\mvn-c.'\mvn)<joTol
    end

end # end test loop
end
