export joSincInterp

<<<<<<< HEAD
# joSincInterp
#
# sinc interpolation matrix for interpolating functions f defined on grid xin to functions defined on grid xout
#
# Note: if xout has more than one point, the spacings of xin and xout are normalized to the spacing of xout
# 
# Parameters:
#   xin  - 1D input grid
#   xout - 1D output grid
#   r    - kaiser window parameter (default: 0, no windowing)
#
function joSincInterp{T<:AbstractFloat,I<:Integer}(xin::AbstractArray{T,1},xout::AbstractArray{T,1};r::I=0,DomainT=T,RangeT=T)
=======
"""
 joSincInterp

 sinc interpolation matrix for interpolating functions f defined on grid xin to functions defined on grid xout

 Note: if xout has more than one point, the spacings of xin and xout are normalized to the spacing of xout
 
 Parameters:
   xin  - 1D input grid
   xout - 1D output grid
   r    - kaiser window parameter (default: 0, no windowing)

"""
function joSincInterp{T<:AbstractFloat,I<:Integer}(xin::AbstractArray{T,1},xout::AbstractArray{T,1};r::I=0)
>>>>>>> master
    if length(xout)>1
        dx = xout[2]-xout[1]
        xin = xin./dx
        xout = xout./dx
    end    
    S = [sinc(xout[i]-xin[j]) for i in 1:length(xout), j in 1:length(xin)]
    if r > 0
        r_b =[1.24 2.94 4.53 6.31 7.91 9.42 10.95 12.53 14.09 14.18];
        window = [kaiser_window(xout[i]-xin[j],r,r_b[r]) for i in 1:length(xout), j in 1:length(xin)]
        S = S .* window
    end
<<<<<<< HEAD
    return joMatrix(S,DDT=DomainT,RDT=RangeT)
=======
    return joMatrix(S;name="joSincInterp")
>>>>>>> master
end

function kaiser_window(x,r,b)
    return abs(x) <= r ? besseli(0,b*sqrt(1-(x/r)^2))/besseli(0,b) : 0.0
end
