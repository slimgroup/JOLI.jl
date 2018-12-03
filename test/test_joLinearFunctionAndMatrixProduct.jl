T=6
tsname="joLinearOperator - Product"
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
    B=joLinearFunctionAll(m,n,v->b*v,v->transpose(b)*v,v->adjoint(b)*v,v->conj(b)*v,v->b\v,v->transpose(b)\v,v->adjoint(b)\v,v->conj(b)\v,eltype(vn),eltype(vm);fMVok=true,iMVok=true)
else
    tname="loop $t for complex($m,$n)"
    a=rand(ComplexF64,m,n)
    b=rand(ComplexF64,m,n)
    vn=rand(ComplexF64,n)
    mvn=rand(ComplexF64,n,2)
    vm=rand(ComplexF64,m)
    mvm=rand(ComplexF64,m,2)
    A=joLinearFunctionAll(m,n,v->a*v,v->transpose(a)*v,v->adjoint(a)*v,v->conj(a)*v,v->a\v,v->transpose(a)\v,v->adjoint(a)\v,v->conj(a)\v,eltype(vn),eltype(vm);fMVok=true,iMVok=true)
    B=joMatrix(b)
end
c=a*adjoint(b)
C=A*adjoint(B)
afac=rand(eltype(c))
Afac=joNumber(afac,C)
mfac=rand(eltype(c))
Mfac=joNumber(mfac,C)

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
        @test norm(C*vm-c*vm)<joTol
        @test norm(C*mvm-c*mvm)<joTol
        @test norm(adjoint(C)*vm-adjoint(c)*vm)<joTol
        @test norm(adjoint(C)*mvm-adjoint(c)*mvm)<joTol
        @test norm(transpose(C)*vm-transpose(c)*vm)<joTol
        @test norm(transpose(C)*mvm-transpose(c)*mvm)<joTol
        @test norm(adjoint(transpose(C))*vm-adjoint(transpose(c))*vm)<joTol
        @test norm(adjoint(transpose(C))*mvm-adjoint(transpose(c))*mvm)<joTol
        @test norm(transpose(adjoint(C))*vm-transpose(adjoint(c))*vm)<joTol
        @test norm(transpose(adjoint(C))*mvm-transpose(adjoint(c))*mvm)<joTol
        @test norm(elements(transpose(C)*C)-(transpose(c)*c))<joTol
        @test norm(elements(C*transpose(C))-(c*transpose(c)))<joTol
        @test norm(elements(adjoint(C)*C)-(adjoint(c)*c))<joTol
        @test norm(elements(C*adjoint(C))-(c*adjoint(c)))<joTol
        @test norm(elements(mfac*C)-(mfac*c))<joTol
        @test norm(elements(mfac*transpose(C))-(mfac*transpose(c)))<joTol
        @test norm(elements(mfac*adjoint(C))-(mfac*adjoint(c)))<joTol
        @test norm(elements(mfac*conj(C))-(mfac*conj(c)))<joTol
        @test norm(elements(C*mfac)-(c*mfac))<joTol
        @test norm(elements(transpose(C)*mfac)-(transpose(c)*mfac))<joTol
        @test norm(elements(adjoint(C)*mfac)-(adjoint(c)*mfac))<joTol
        @test norm(elements(conj(C)*mfac)-(conj(c)*mfac))<joTol
        @test norm(elements(Mfac*C)-(mfac*c))<joTol
        @test norm(elements(Mfac*transpose(C))-(mfac*transpose(c)))<joTol
        @test norm(elements(Mfac*adjoint(C))-(mfac*adjoint(c)))<joTol
        @test norm(elements(Mfac*conj(C))-(mfac*conj(c)))<joTol
        @test norm(elements(C*Mfac)-(c*mfac))<joTol
        @test norm(elements(transpose(C)*Mfac)-(transpose(c)*mfac))<joTol
        @test norm(elements(adjoint(C)*Mfac)-(adjoint(c)*mfac))<joTol
        @test norm(elements(conj(C)*Mfac)-(conj(c)*mfac))<joTol
        @test norm(elements(C+afac)-(c.+afac))<joTol
        @test norm(elements(transpose(C)+afac)-(transpose(c).+afac))<joTol
        @test norm(elements(adjoint(C)+afac)-(adjoint(c).+afac))<joTol
        @test norm(elements(conj(C)+afac)-(conj(c).+afac))<joTol
        @test norm(elements(afac+C)-(afac.+c))<joTol
        @test norm(elements(afac+transpose(C))-(afac.+transpose(c)))<joTol
        @test norm(elements(afac+adjoint(C))-(afac.+adjoint(c)))<joTol
        @test norm(elements(afac+conj(C))-(afac.+conj(c)))<joTol
        @test norm(elements(C+Afac)-(c.+afac))<joTol
        @test norm(elements(transpose(C)+Afac)-(transpose(c).+afac))<joTol
        @test norm(elements(adjoint(C)+Afac)-(adjoint(c).+afac))<joTol
        @test norm(elements(conj(C)+Afac)-(conj(c).+afac))<joTol
        @test norm(elements(Afac+C)-(afac.+c))<joTol
        @test norm(elements(Afac+transpose(C))-(afac.+transpose(c)))<joTol
        @test norm(elements(Afac+adjoint(C))-(afac.+adjoint(c)))<joTol
        @test norm(elements(Afac+conj(C))-(afac.+conj(c)))<joTol
        if (issquare(C) && m==n)
            @test norm(C\vm-c\vm)<joTol^(2/3)
            @test norm(C\mvm-c\mvm)<joTol^(2/3)
            @test norm(adjoint(C)\vn-adjoint(c)\vn)<joTol^(2/3)
            @test norm(adjoint(C)\mvn-adjoint(c)\mvn)<joTol^(2/3)
            @test norm(transpose(C)\vn-transpose(c)\vn)<joTol^(2/3)
            @test norm(transpose(C)\mvn-transpose(c)\mvn)<joTol^(2/3)
        end
    end

end # end test loop
end
