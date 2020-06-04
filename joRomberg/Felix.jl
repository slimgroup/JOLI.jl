function phasecode(n)

# precompute phase in ambient dimension
    dist = Uniform(-1, 1)
    F = joDFT(n; DDT=Float32,RDT=ComplexF64);
    phase=F*(adjoint(F)*exp.(1im*2*pi*convert(Array{Float32},rand(dist,n))))
    phase = phase ./abs.(phase);
    sgn = sign.(convert(Array{Float32},randn(n)));

# Return operator    
    return A = joDiag(sgn) * adjoint(F) * joDiag(phase)*F;
end
    
M = phasecode(length(x));
R = joRestriction(length(x),randperm(length(x))[1:Int(round(length(x)/4))];DDT=Float32, RDT=Float32);
A = R*M;
