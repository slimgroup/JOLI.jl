T=6
tol=10e-12
tsname="joFunction - Single"
@testset "$tsname" begin
for t=1:T # start test loop

if t<=2
    (m,n)=(5,5)
else
    (m,n)=(rand(3:7),rand(3:7))
end

if t%2==1
    tname="loop $t for real($m,$n)"
    at=Float64
    bt=Float64
    a=rand(m,n)
    b=rand(m,n)
    vn=rand(n)
    mvn=rand(n,2)+im*rand(n,2)
    vm=rand(m)+im*rand(m)
    mvm=rand(m,2)
else
    tname="loop $t for complex($m,$n)"
    at=Complex{Float64}
    bt=Complex{Float64}
    a=rand(m,n)+im*rand(m,n)
    b=rand(m,n)+im*rand(m,n)
    vn=rand(n)+im*rand(n)
    mvn=rand(n,2)
    vm=rand(m)
    mvm=rand(m,2)+im*rand(m,2)
end
A=joFunctionAll(at,m,n,v->a*v,v->a.'*v,v->a'*v,v->conj(a)*v,v->a\v,v->a.'\v,v->a'\v,v->conj(a)\v)
B=joFunctionAll(bt,m,n,v->b*v,v->b.'*v,v->b'*v,v->conj(b)*v,v->b\v,v->b.'\v,v->b'\v,v->conj(b)\v)
afac=rand()+rand()*im
mfac=rand()+rand()*im

println("$tsname $tname")
    @testset "$tname A" begin
        @test eltype(A)==eltype(a)
        @test size(A)==size(a)
        @test length(A)==length(a)
        @test full(A)==a
        @test double(A)==a
        @test norm(A)==norm(a)
        for i=1:2
            @test norm(A,i)==norm(a,i)
        end
        @test norm(A,Inf)==norm(a,Inf)
        @test vecnorm(A)==vecnorm(a)
        for i=1:2
            @test vecnorm(A,i)==vecnorm(a,i)
        end
        @test vecnorm(A,Inf)==vecnorm(a,Inf)
        @test double(A')==a'
        @test double(A.')==a.'
        @test double(conj(A))==conj(a)
        @test double(+A)==+a
        @test double(-A)==-a
        @test norm(A*vn-a*vn)<tol
        @test norm(A*mvn-a*mvn)<tol
        @test norm(A'*vm-a'*vm)<tol
        @test norm(A'*mvm-a'*mvm)<tol
        @test norm(A.'*vm-a.'*vm)<tol
        @test norm(A.'*mvm-a.'*mvm)<tol
        @test norm((A.')'*vn-(a.')'*vn)<tol
        @test norm((A.')'*mvn-(a.')'*mvn)<tol
        @test norm((A').'*vn-(a').'*vn)<tol
        @test norm((A').'*mvn-(a').'*mvn)<tol
        @test norm(double(A.'*A)-(a.'*a))<tol
        @test norm(double(A*A.')-(a*a.'))<tol
        @test norm(double(A'*A)-(a'*a))<tol
        @test norm(double(A*A')-(a*a'))<tol
        @test norm(A\vm-a\vm)<tol
        @test norm(A\mvm-a\mvm)<tol
        @test norm(A'\vn-a'\vn)<tol
        @test norm(A'\mvn-a'\mvn)<tol
        @test norm(A.'\vn-a.'\vn)<tol
        @test norm(A.'\mvn-a.'\mvn)<tol
        @test norm(double(A+B)-(a+b))<tol
        @test norm(double(A-B)-(a-b))<tol
        @test norm(double(mfac*A)-(mfac*a))<tol
        @test norm(double(mfac*A.')-(mfac*a.'))<tol
        @test norm(double(mfac*A')-(mfac*a'))<tol
        @test norm(double(mfac*conj(A))-(mfac*conj(a)))<tol
        @test norm(double(A*mfac)-(a*mfac))<tol
        @test norm(double(A.'*mfac)-(a.'*mfac))<tol
        @test norm(double(A'*mfac)-(a'*mfac))<tol
        @test norm(double(conj(A)*mfac)-(conj(a)*mfac))<tol
    end

    end # end test loop
end
