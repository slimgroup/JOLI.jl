using JOLI
using InplaceOps
DDT=Float64
RDT=Float64
a=rand(3,3)
A=joMatrix(a,DDT=DDT,RDT=RDT)
fa=factorize(a)
AI=joLinearFunctionInplaceAll(3,3,
    (y1,x1)->A_mul_B!(y1,a,x1),
    (y2,x2)->At_mul_B!(y2,a,x2),
    (y3,x3)->Ac_mul_B!(y3,a,x3),
    (y5,x5)->A_ldiv_B!(y5,fa,x5),
    (y6,x6)->At_ldiv_B!(y6,fa,x6),
    (y7,x7)->Ac_ldiv_B!(y7,fa,x7),
    DDT,RDT)

x=rand(DDT,3)
mx=rand(DDT,3,3)
Y=zeros(RDT,3)
MY=zeros(RDT,3,3)

y=A*x
my=A*mx
@into! Y=AI*x
show(Y-y);println()
@into! MY=AI*mx
show(MY-my);println()

x=rand(RDT,3)
mx=rand(RDT,3,3)
Y=zeros(DDT,3)
MY=zeros(DDT,3,3)

y=A.'*x
my=A.'*mx
@into! Y=AI.'*x
show(Y-y);println()
@into! MY=AI.'*mx
show(MY-my);println()

y=A'*x
my=A'*mx
@into! Y=AI'*x
show(Y-y);println()
@into! MY=AI'*mx
show(MY-my);println()

x=rand(RDT,3)
mx=rand(RDT,3,3)
Y=zeros(DDT,3)
MY=zeros(DDT,3,3)

y=A\x
my=A\mx
@into! Y=AI\x
show(Y-y);println()
@into! MY=AI\mx
show(MY-my);println()

x=rand(DDT,3)
mx=rand(DDT,3,3)
Y=zeros(RDT,3)
MY=zeros(RDT,3,3)

y=A.'\x
my=A.'\mx
@into! Y=AI.'\x
show(Y-y);println()
@into! MY=AI.'\mx
show(MY-my);println()

y=A'\x
my=A'\mx
@into! Y=AI'\x
show(Y-y);println()
@into! MY=AI'\mx
show(MY-my);println()
