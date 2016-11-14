T=6
tol=10e-12
tsname="joFunction - Product"
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
c=a*b'
C=A*B'
afac=rand()+rand()*im
mfac=rand()+rand()*im

println("$tsname $tname")
    @testset "$tname A*B" begin
        @test eltype(C)==eltype(c)
        @test size(C)==size(c)
        @test length(C)==length(c)
        @test norm(full(C)-c)<tol
        @test norm(double(C)-c)<tol
        @test norm(C)-norm(c)<tol
        for i=1:2
            @test norm(C,i)-norm(c,i)<tol
        end
        @test norm(C,Inf)-norm(c,Inf)<tol
        @test vecnorm(C)-vecnorm(c)<tol
        for i=1:2
            @test vecnorm(C,i)-vecnorm(c,i)<tol
        end
        @test vecnorm(C,Inf)-vecnorm(c,Inf)<tol
        @test norm(double(C')-c')<tol
        @test norm(double(C.')-c.')<tol
        @test norm(double(+C)-(+c))<tol
        @test norm(double(-C)-(-c))<tol
        @test norm(C*vm-c*vm)<tol
        @test norm(C*mvm-c*mvm)<tol
        @test norm(C'*vm-c'*vm)<tol
        @test norm(C'*mvm-c'*mvm)<tol
        @test norm(C.'*vm-c.'*vm)<tol
        @test norm(C.'*mvm-c.'*mvm)<tol
        @test norm((C.')'*vm-(c.')'*vm)<tol
        @test norm((C.')'*mvm-(c.')'*mvm)<tol
        @test norm((C').'*vm-(c').'*vm)<tol
        @test norm((C').'*mvm-(c').'*mvm)<tol
        @test norm(double(C.'*C)-(c.'*c))<tol
        @test norm(double(C*C.')-(c*c.'))<tol
        @test norm(double(C'*C)-(c'*c))<tol
        @test norm(double(C*C')-(c*c'))<tol
        #@test norm(C\vm-c\vm)<tol
        #@test norm(C\mvm-c\mvm)<tol
        #@test norm(C'\vm-c'\vm)<tol
        #@test norm(C'\mvm-c'\mvm)<tol
        #@test norm(C.'\vn-c.'\vn)<tol
        #@test norm(C.'\mvn-c.'\mvn)<tol
    end

    end # end test loop
end
