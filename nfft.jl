using JOLI
using NFFT

M, N = 1024, 512

#x = linspace(-0.4, 0.4, M)      # nodes at which the NFFT is evaluated
#fHat = randn(M) + randn(M)*im   # data to be transformed
#p = NFFTPlan(x, N)              # create plan. m and sigma are optional parameters
#f = nfft_adjoint(p, fHat)       # calculate adjoint NFFT
#g = nfft(p, f)                  # calculate forward NFFT

x = collect(linspace(0., 1., M))
p = NFFTPlan(x, N)              # create plan. m and sigma are optional parameters
f=complex(randn(N))
#display(f); println()
fHat=nfft(p, f)/sqrt(N)
#display(fHat); println()
fn=nfft_adjoint(p,fHat)/sqrt(N)
#display(fn); println()
#display(real(f)./real(fn)); println()

A=joNFFT(N,x)
println((norm(A*f-fHat),norm(A'*fHat-fn)))
show(A)
println(isadjoint(A;verbose=true))
#println(islinear(A;verbose=true))

A=joNFFT(N,x;centered=true)
show(A)
println(isadjoint(A;verbose=true))
#println(islinear(A;verbose=true))
