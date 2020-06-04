function op = opRombergND(dims)
% OPROMBERG     a 2D random convolution based on Romberg 08
% (expects a vector for input and output)

phs = random_phasesND(dims);
sgn = sign(randn(dims));

op = @(x,mode) opRomberg_intrnl(dims,x,phs,sgn,mode);

function y = opRomberg_intrnl(dims,x,phs,sgn,mode)
if (mode == 0)
   y = {prod(dims),prod(dims),[1,1,1,1],{'ROMBERG'}};
elseif (mode == 1)
   x = reshape(x,dims);
   y = sgn.*ifftn(phs.*fftn(x));
   y = y(:);
else
   x = reshape(x,dims);
   y = ifftn(conj(phs).*fftn(sgn.*x));
   y = y(:);
end
% random_phases.m
%
% Create array of random phases, with symmetries for a real-valued 3D
% image.
%
function PHS = random_phasesND(dims)

p1 = exp(j*2*pi*rand(dims));
p2 = fftn(real(ifftn(p1)));
PHS = p2./abs(p2);
