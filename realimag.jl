workspace()
using JOLI
using Base.Test
a=rand(3,3)+im*rand(3,3)
display(a);println()
A=joMatrix(a)
display(elements(A));println()
b=complex(rand(3,3))
display(b);println()
B=joMatrix(b)
display(elements(B));println()
c=im*rand(3,3)
display(c);println()
C=joMatrix(c)
display(elements(C));println()
v=rand(3)+im*rand(3)
display(v);println()

@testset "joReal/joImag" begin

@test norm(elements(A)-a) < joTol

# real(jo)/joReal
@test norm(.5*(A+conj(A))*v-real(a)*v) < joTol
@test norm(.5*(A.'+conj(A.'))*v-real(a.')*v) < joTol
@test norm(.5*(A'+conj(A'))*v-real(a')*v) < joTol
@test norm(.5*(conj(A)+A)*v-real(conj(a))*v) < joTol

@test norm(.5*(B+conj(B))*v-real(b)*v) < joTol
@test norm(.5*(B.'+conj(B.'))*v-real(b.')*v) < joTol
@test norm(.5*(B'+conj(B'))*v-real(b')*v) < joTol
@test norm(.5*(conj(B)+B)*v-real(conj(b))*v) < joTol

@test norm(.5*(C+conj(C))*v-real(c)*v) < joTol
@test norm(.5*(C.'+conj(C.'))*v-real(c.')*v) < joTol
@test norm(.5*(C'+conj(C'))*v-real(c')*v) < joTol
@test norm(.5*(conj(C)+C)*v-real(conj(c))*v) < joTol

# imag(jo)/joImag
@test norm(-im*.5*(A-conj(A))*v-imag(a)*v) < joTol
@test norm(-im*.5*(A.'-conj(A.'))*v-imag(a.')*v) < joTol
@test norm(-im*.5*(A'-conj(A'))*v-imag(a')*v) < joTol
@test norm(-im*.5*(conj(A)-A)*v-imag(conj(a))*v) < joTol

@test norm(-im*.5*(B-conj(B))*v-imag(b)*v) < joTol
@test norm(-im*.5*(B.'-conj(B.'))*v-imag(b.')*v) < joTol
@test norm(-im*.5*(B'-conj(B'))*v-imag(b')*v) < joTol
@test norm(-im*.5*(conj(B)-B)*v-imag(conj(b))*v) < joTol

@test norm(-im*.5*(C-conj(C))*v-imag(c)*v) < joTol
@test norm(-im*.5*(C.'-conj(C.'))*v-imag(c.')*v) < joTol
@test norm(-im*.5*(C'-conj(C'))*v-imag(c')*v) < joTol
@test norm(-im*.5*(conj(C)-C)*v-imag(conj(c))*v) < joTol

end
;


#display(elements(A-conj(A)))
#display(2.*imag(a))
