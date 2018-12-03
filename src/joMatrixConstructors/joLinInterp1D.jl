# 1D Linear interpolation operator

# helper module
module joLinInterp1D_etc
"""
1D nearest neighbourhood operator, returns a vector I of size length(xout)
such that for every i in 1:length(xout), I[i] is the index such that
 |xout[i] - xin[I[i]]| <= |xout[i]-xin[j]| for all indices j

Parameters:
  xin - input grid
  xout - output grid

Note: the interval [minimum(xout),maximum(xout)] must be contained
in the interval [minimum(xin),maximum(xin)]

"""
function nearestnbr1d(xin,xout)
    ((minimum(xin) <= minimum(xout)) && (maximum(xin) >= maximum(xout))) || throw(ArgumentError("interval defined by xout must be contained within xin"))
    Jin = sortperm(xin)
    Jout = sortperm(xout)
    xin = xin[Jin]
    xout = xout[Jout]
    xend = xin[2]
    istart = 1
    I = zeros(Int64,length(xout))
    for i=1:length(xout)
        while xout[i] > xend
            istart+=1
            if istart==length(xin)
                xend = inf
            else
                xend = xin[istart+1]
            end
        end
        if abs(xout[i]-xin[istart]) <= abs(xout[i]-xend)
            I[i] = istart
        else
            I[i] = istart+1
        end
    end
    Jin_inv = Jin
    Jout_inv = Jout
    I = Jin_inv[I]
    I[Jout_inv] = I
    return I
end
end
using .joLinInterp1D_etc

export joLinInterp1D
"""

    julia> joLinInterp1D(xin,xout,T)

1D Linear interpolation operator

# Arguments

- `xin`  - input grid
- `xout` - output grid
- `T`    - vector data type

# Signature

    joLinInterp1D(xin,xout,T)

# Notes

- The interval [minimum(xout),maximum(xout)] must be contained in the interval [minimum(xin),maximum(xin)]

"""
function joLinInterp1D(xin,xout,T)
    xin = sort(xin)
    xout = sort(xout)
    nin = length(xin)
    nout = length(xout)
    I = joLinInterp1D_etc.nearestnbr1d(xin,xout)
    I[xin[I].>xout] = I[xin[I].>xout].-1
    xin = [xin;1e12]
    b = (xout-xin[I])./(xin[I.+1]-xin[I])
    a = (xin[I.+1]-xout)./(xin[I.+1]-xin[I])
    A = sparse(1:nout,I,a,nout,nin) + sparse(1:nout,min.(I.+1,nin),b,nout,nin)
    return joMatrix(A,DDT=T,name="joLinInterp1D")
end

