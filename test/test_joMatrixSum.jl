T=6
tsname="joMatrix - Sum"
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
    A=joMatrix(a)
    B=joMatrix(b)
else
    tname="loop $t for complex($m,$n)"
    a=rand(ComplexF64,m,n)
    b=rand(ComplexF64,m,n)
    vn=rand(ComplexF64,n)
    mvn=rand(ComplexF64,n,2)
    vm=rand(ComplexF64,m)
    mvm=rand(ComplexF64,m,2)
    A=joMatrix(a)
    B=joMatrix(b)
end
c=a+b
C=A+B

verbose && println("$tsname $tname")
    @testset "$tname A*B" begin
        @test size(C)==size(c)
        @test length(C)==length(c)
        @test norm(jo_full(C)-c)<joTol
        @test norm(elements(C)-c)<joTol
        @test norm(C)-norm(c)<joTol
        for i=1:2
            @test norm(C,i)-norm(c,i)<joTol
        end
        @test norm(C,Inf)-norm(c,Inf)<joTol
        @test norm(C)-norm(c)<joTol
        for i=1:2
            @test norm(C,i)-norm(c,i)<joTol
        end
        @test norm(C,Inf)-norm(c,Inf)<joTol
        @test norm(elements(adjoint(C))-adjoint(c))<joTol
        @test norm(elements(transpose(C))-transpose(c))<joTol
        @test norm(elements(+C)-(+c))<joTol
        @test norm(elements(-C)-(-c))<joTol
        @test norm(C*vn-c*vn)<joTol
        @test norm(C*mvn-c*mvn)<joTol
        @test norm(adjoint(C)*vm-adjoint(c)*vm)<joTol
        @test norm(adjoint(C)*mvm-adjoint(c)*mvm)<joTol
        @test norm(transpose(C)*vm-transpose(c)*vm)<joTol
        @test norm(transpose(C)*mvm-transpose(c)*mvm)<joTol
        @test norm(adjoint(transpose(C))*vn-adjoint(transpose(c))*vn)<joTol
        @test norm(adjoint(transpose(C))*mvn-adjoint(transpose(c))*mvn)<joTol
        @test norm(transpose(adjoint(C))*vn-transpose(adjoint(c))*vn)<joTol
        @test norm(transpose(adjoint(C))*mvn-transpose(adjoint(c))*mvn)<joTol
        @test norm(elements(transpose(C)*C)-(transpose(c)*c))<joTol
        @test norm(elements(C*transpose(C))-(c*transpose(c)))<joTol
        @test norm(elements(adjoint(C)*C)-(adjoint(c)*c))<joTol
        @test norm(elements(C*adjoint(C))-(c*adjoint(c)))<joTol
        if issquare(C)
            @test norm(C\vn-c\vn)<joTol
            @test norm(C\mvn-c\mvn)<joTol
            @test norm(adjoint(C)\vm-adjoint(c)\vm)<joTol
            @test norm(adjoint(C)\mvm-adjoint(c)\mvm)<joTol
            @test norm(transpose(C)\vm-transpose(c)\vm)<joTol
            @test norm(transpose(C)\mvm-transpose(c)\mvm)<joTol
        end
    end

end # end test loop
end
