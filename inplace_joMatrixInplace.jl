using JOLI
using InplaceOps
DDT=Float64
RDT=Float64
a=rand(3,3)
A=joMatrix(a,DDT=DDT,RDT=RDT)
AI=joMatrixInplace(a,DDT=DDT,RDT=RDT)

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
