using FFTW
using LinearAlgebra
using BenchmarkTools
using JOLI # remove when done
using JOLI.Seismic


function lpradon(input::Matrix, t::Vector, h::Vector, q::Vector, power::Integer, mode::Integer)
    # linear and parabolic Radon transform and its adjoint.
    #
    # Tristan van Leeuwen, 2012
    # tleeuwen@eos.ubc.ca
    #
    # use:
    #   out = lpradon(input,t,h,q,power,mode)
    #
    # input:
    #   input - input matrix of size (length(t) x length(h)) for forward, (length(t) x length(q)) for adjoint)
    #   t     - time vector in seconds
    #   h     - offset vecror in meters
    #   q     - radon parameter
    #   power - 1: linear radon, 2: parabolic radon
    #   mode  - 1: forward, -1: adjoint
    #
    # output:            println(size(L))
    #   output matrix of size (length(t) x length(q)) for forward, (length(t) x length(h)) for adjoint)
    #
    #

    dt   = t[2] - t[1]
    tN   = length(t)
    hN   = length(h)
    qN   = length(q)
    fftN = 2*nextpow(2,tN)

    input_padded = zeros(fftN, size(input)[2])
    input_padded[1:size(input)[1], :] = input[:, :]


    if mode == 1

        input_padded  = fft(input_padded, 1)
        out = zeros(Complex{Float64}, fftN, qN)

        for k = 2:Int(floor(fftN/2))
            f = (2.)*pi*(k-1)/fftN/dt
            L = exp.(im*f*(h.^power)*q')
            tmp = transpose(input_padded[k,:])*L
            out[k,:] = tmp
            out[fftN + 2 - k, :] = conj(tmp)
        end
        out = real(ifft(out, 1))
        out = out[1:tN, :]

    else

        input_padded  = fft(input_padded,1)
        out = zeros(Complex{Float64}, fftN, hN)

        for k = 2:Int(floor(fftN/2))
            f = (2.)*pi*(k-1)/fftN/dt
            L = exp.(im*f*(h.^power)*q')
            tmp = transpose(input_padded[k,:])*L'
            out[k,:] = tmp
            out[fftN+2-k,:] = conj(tmp)
        end

        out = real(ifft(out,1))
        out = out[1:tN, :]

    end

    return out
end

#################
#t = collect(0.0:0.004:4.0)
t = collect(0.0:0.04:4.0)
h = collect(-2000:25:2000)
q = collect(1e-3.*(-3:.05:3))

nt=length(t)
nh=length(h)
nq=length(q)
pwrs=[1 2]
println("dims: nt $nt nh $nh nq $nq")

DDT=joFloat
RDT=joFloat
#image=jo_eye(nt,nh)
image=randn(nt,nh)

for pwr in pwrs
A=joRadon(t,h,q,pwr,DDT=DDT,RDT=RDT)

global radon=lpradon(image,t,h,q,pwr,1)
global RADON=reshape(JOLI.Seismic.joRadon_etc.fwd_lpradon(vec(image),t,h,q,pwr,RDT),nt,nq)
global Radon=reshape(A*vec(image),nt,nq)
global image0=lpradon(radon,t,h,q,pwr,-1)
global IMAGE0=reshape(JOLI.Seismic.joRadon_etc.adj_lpradon(vec(RADON),t,h,q,pwr,DDT),nt,nh)
global Image0=reshape(A'*vec(RADON),nt,nh)
@time radon=lpradon(image,t,h,q,pwr,1)
@time RADON=reshape(JOLI.Seismic.joRadon_etc.fwd_lpradon(vec(image),t,h,q,pwr,RDT),nt,nq)
@time Radon=reshape(A*vec(image),nt,nq)
@time image0=lpradon(radon,t,h,q,pwr,-1)
@time IMAGE0=reshape(JOLI.Seismic.joRadon_etc.adj_lpradon(vec(RADON),t,h,q,pwr,DDT),nt,nh)
@time Image0=reshape(A'*vec(Radon),nt,nh)
#display(@benchmark radon=lpradon(image,t,h,q,pwr,1))
#display(@benchmark RADON=reshape(JOLI.Seismic.joRadon_etc.fwd_lpradon(vec(image),t,h,q,pwr,RDT),nt,nq))
#display(@benchmark Radon=reshape(A*vec(image),nt,nq))
#display(@benchmark image0=lpradon(radon,t,h,q,pwr,-1))
#display(@benchmark IMAGE0=reshape(JOLI.Seismic.joRadon_etc.adj_lpradon(vec(RADON),t,h,q,pwr,DDT),nt,nh))
#display(@benchmark Image0=reshape(A'*vec(Radon),nt,nh))

println("f: $(nt*nq)x$(nt*nh) a:$(nt*nh)x$(nt*nq)")
println("f: $(prod(size(radon)))x$(prod(size(image))) a:$(prod(size(image0)))x$(prod(size(radon)))")
println("f: $(prod(size(RADON)))x$(prod(size(image))) a:$(prod(size(IMAGE0)))x$(prod(size(RADON)))")
println("f: $(prod(size(Radon)))x$(prod(size(image))) a:$(prod(size(Image0)))x$(prod(size(Radon)))")
println("norms: $(norm(radon-RADON)) $(norm(image0-IMAGE0))")
println("norms: $(norm(radon-Radon)) $(norm(image0-Image0))")
println("tests: linear $(islinear(A)[1]) / adjoint $(isadjoint(A)[1])")

end
