workspace()
using LinearOperators
using JOLI
using BenchmarkTools
m=3000
n=5000
a=rand(m,n)
vn=rand(n)
vm=rand(m)

println("***** Starting")
@time A=joMatrix(rand(m,n))
@time A=joMatrix(a)
@time L=LinearOperator(rand(m,n))
@time L=LinearOperator(a)

println("***** allocation")
println("joMatrix(a) ",@benchmark joMatrix(a)); println();
println("LinearOperator(a) ",@benchmark LinearOperator(a)); println();

println("***** forward")
@time r=a*vn; println("a*vn ",@benchmark r=a*vn); println();
@time r=A*vn; println("A*vn ",@benchmark r=A*vn); println();
@time r=L*vn; println("L*vn ",@benchmark r=L*vn); println();

println("***** ' implicit")
@time r=a'*vm; println("a'*vm ",@benchmark r=a'*vm); println();
@time r=A'*vm; println("A'*vm ",@benchmark r=A'*vm); println();
@time r=L'*vm; println("L'*vm ",@benchmark r=L'*vm); println();
println("***** ' explicit")
@time act=a';
@time r=act*vm; println("act*vm ",@benchmark r=act*vm); println();
@time Act=A';
@time r=Act*vm; println("Act*vm ",@benchmark r=Act*vm); println();
@time Lct=L';
@time r=Lct*vm; println("Lct*vm ",@benchmark r=Lct*vm); println();

println("***** '' implicit")
@time r=act'*vn; println("act'*vn ",@benchmark r=act'*vn); println();
@time r=Act'*vn; println("Act'*vn ",@benchmark r=Act'*vn); println();
@time r=Lct'*vn; println("Lct'*vn ",@benchmark r=Lct'*vn); println();
println("***** '' explicit")
@time actct=act';
@time r=actct*vn; println("actct*vn ",@benchmark r=actct*vn); println();
@time Actct=Act';
@time r=Actct*vn; println("Actct*vn ",@benchmark r=Actct*vn); println();
@time Lctct=Lct';
@time r=Lctct*vn; println("Lctct*vn ",@benchmark r=Lctct*vn); println();

println("***** Done")
