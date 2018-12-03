T=6
tsname="joLinearFunction - Single"
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
    a=rand(ComplexF64,m,n)
    b=rand(ComplexF64,m,n)
    vn=rand(ComplexF64,n)
    mvn=rand(ComplexF64,n,2)
    vm=rand(ComplexF64,m)
    mvm=rand(ComplexF64,m,2)
end
A=joLinearFunctionAll(m,n,v->a*v,v->transpose(a)*v,v->adjoint(a)*v,v->conj(a)*v,v->a\v,v->transpose(a)\v,v->adjoint(a)\v,v->conj(a)\v,eltype(vn),eltype(vm);fMVok=true,iMVok=true)
B=joLinearFunctionAll(m,n,v->b*v,v->transpose(b)*v,v->adjoint(b)*v,v->conj(b)*v,v->b\v,v->transpose(b)\v,v->adjoint(b)\v,v->conj(b)\v,eltype(vn),eltype(vm))
afac=rand(eltype(a))
Afac=joNumber(afac,A)
mfac=rand(eltype(a))
Mfac=joNumber(mfac,A)

verbose && println("$tsname $tname")
    @testset "$tname A" begin
        @test size(A)==size(a)
        @test length(A)==length(a)
        @test jo_full(A)==a
        @test elements(A)==a
        @test norm(A)==norm(a)
        for i=1:2
            @test norm(A,i)==norm(a,i)
        end
        @test norm(A,Inf)==norm(a,Inf)
        @test norm(A)==norm(a)
        for i=1:2
            @test norm(A,i)==norm(a,i)
        end
        @test norm(A,Inf)==norm(a,Inf)
        @test elements(adjoint(A))==adjoint(a)
        @test elements(transpose(A))==transpose(a)
        @test elements(conj(A))==conj(a)
        @test elements(+A)==+a
        @test elements(-A)==-a
        @test norm(A*vn-a*vn)<joTol
        @test norm(A*mvn-a*mvn)<joTol
        @test norm(adjoint(A)*vm-adjoint(a)*vm)<joTol
        @test norm(adjoint(A)*mvm-adjoint(a)*mvm)<joTol
        @test norm(transpose(A)*vm-transpose(a)*vm)<joTol
        @test norm(transpose(A)*mvm-transpose(a)*mvm)<joTol
        @test norm(adjoint(transpose(A))*vn-adjoint(transpose(a))*vn)<joTol
        @test norm(adjoint(transpose(A))*mvn-adjoint(transpose(a))*mvn)<joTol
        @test norm(transpose(adjoint(A))*vn-transpose(adjoint(a))*vn)<joTol
        @test norm(transpose(adjoint(A))*mvn-transpose(adjoint(a))*mvn)<joTol
        @test norm(elements(transpose(A)*A)-(transpose(a)*a))<joTol
        @test norm(elements(A*transpose(A))-(a*transpose(a)))<joTol
        @test norm(elements(adjoint(A)*A)-(adjoint(a)*a))<joTol
        @test norm(elements(A*adjoint(A))-(a*adjoint(a)))<joTol
        @test norm(A\vm-a\vm)<joTol
        @test norm(A\mvm-a\mvm)<joTol
        @test norm(adjoint(A)\vn-adjoint(a)\vn)<joTol
        @test norm(adjoint(A)\mvn-adjoint(a)\mvn)<joTol
        @test norm(transpose(A)\vn-transpose(a)\vn)<joTol
        @test norm(transpose(A)\mvn-transpose(a)\mvn)<joTol
        @test norm(elements(A+B)-(a+b))<joTol
        @test norm(elements(A-B)-(a-b))<joTol
        @test norm(elements(mfac*A)-(mfac*a))<joTol
        @test norm(elements(mfac*transpose(A))-(mfac*transpose(a)))<joTol
        @test norm(elements(mfac*adjoint(A))-(mfac*adjoint(a)))<joTol
        @test norm(elements(mfac*conj(A))-(mfac*conj(a)))<joTol
        @test norm(elements(A*mfac)-(a*mfac))<joTol
        @test norm(elements(transpose(A)*mfac)-(transpose(a)*mfac))<joTol
        @test norm(elements(adjoint(A)*mfac)-(adjoint(a)*mfac))<joTol
        @test norm(elements(conj(A)*mfac)-(conj(a)*mfac))<joTol
        @test norm(elements(Mfac*A)-(mfac*a))<joTol
        @test norm(elements(Mfac*transpose(A))-(mfac*transpose(a)))<joTol
        @test norm(elements(Mfac*adjoint(A))-(mfac*adjoint(a)))<joTol
        @test norm(elements(Mfac*conj(A))-(mfac*conj(a)))<joTol
        @test norm(elements(A*Mfac)-(a*mfac))<joTol
        @test norm(elements(transpose(A)*Mfac)-(transpose(a)*mfac))<joTol
        @test norm(elements(adjoint(A)*Mfac)-(adjoint(a)*mfac))<joTol
        @test norm(elements(conj(A)*Mfac)-(conj(a)*mfac))<joTol
        @test norm(elements(A+afac)-(a.+afac))<joTol
        @test norm(elements(transpose(A)+afac)-(transpose(a).+afac))<joTol
        @test norm(elements(adjoint(A)+afac)-(adjoint(a).+afac))<joTol
        @test norm(elements(conj(A)+afac)-(conj(a).+afac))<joTol
        @test norm(elements(afac+A)-(afac.+a))<joTol
        @test norm(elements(afac+transpose(A))-(afac.+transpose(a)))<joTol
        @test norm(elements(afac+adjoint(A))-(afac.+adjoint(a)))<joTol
        @test norm(elements(afac+conj(A))-(afac.+conj(a)))<joTol
        @test norm(elements(A+Afac)-(a.+afac))<joTol
        @test norm(elements(transpose(A)+Afac)-(transpose(a).+afac))<joTol
        @test norm(elements(adjoint(A)+Afac)-(adjoint(a).+afac))<joTol
        @test norm(elements(conj(A)+Afac)-(conj(a).+afac))<joTol
        @test norm(elements(Afac+A)-(afac.+a))<joTol
        @test norm(elements(Afac+transpose(A))-(afac.+transpose(a)))<joTol
        @test norm(elements(Afac+adjoint(A))-(afac.+adjoint(a)))<joTol
        @test norm(elements(Afac+conj(A))-(afac.+conj(a)))<joTol
    end

end # end test loop
end
