using JOLI
using InplaceOps
DDT=Float32
RDT=Float64
A=joMatrix(rand(3,3),DDT=DDT,RDT=RDT)

x=rand(DDT,3)
mx=rand(DDT,3,3)
Y=zeros(RDT,3)
MY=zeros(RDT,3,3)

y=A*x
my=A*mx
@into! Y=A*x
show(Y-y);println()
@into! MY=A*mx
show(MY-my);println()

x=rand(RDT,3)
mx=rand(RDT,3,3)
Y=zeros(DDT,3)
MY=zeros(DDT,3,3)

y=A.'*x
my=A.'*mx
@into! Y=A.'*x
show(Y-y);println()
@into! MY=A.'*mx
show(MY-my);println()

y=A'*x
my=A'*mx
@into! Y=A'*x
show(Y-y);println()
@into! MY=A'*mx
show(MY-my);println()

x=rand(RDT,3)
mx=rand(RDT,3,3)
Y=zeros(DDT,3)
MY=zeros(DDT,3,3)

y=A\x
my=A\mx
@into! Y=A\x
show(Y-y);println()
@into! MY=A\mx
show(MY-my);println()

x=rand(DDT,3)
mx=rand(DDT,3,3)
Y=zeros(RDT,3)
MY=zeros(RDT,3,3)

y=A.'\x
my=A.'\mx
@into! Y=A.'\x
show(Y-y);println()
@into! MY=A.'\mx
show(MY-my);println()

y=A'\x
my=A'\mx
@into! Y=A'\x
show(Y-y);println()
@into! MY=A'\mx
show(MY-my);println()
