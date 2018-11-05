# joNMO - NMO Correction (experimental)

## helper module
module joNMO_etc
    using Dierckx
    using JOLI: jo_convert
    using Dierckx
    # NMO correction and adjoint
    #
    # use:
    #   out = fwd_NMO(in,t,h,v)
    #   out = adj_NMO(in,t,h,v)
    #
    # input:
    #   in   - data matrix of size [length(t) x length(h)], each column is a trace
    #   t    - time vector [s]
    #   offsets    - offset vector [m]
    #   v    - NMO velocity [m/s] as vector of size [length(t) x 1].
    #   flag - 1:forward, -1:adjoint
    #
    # output
    #   out  - data matrix of size [length(t) x length(h)], each column is a trace


    function getLA(x1,x2)
        # Cubic Lagrange interpolation from grid x1 to x2

        # find interior points
        ik = find((x2 .>= x1[1]) .& (x2 .<= x1[end]))
        # sizes
        n1 = length(x1)
        n2 = length(x2)
        nk = length(ik)
        # check
        if length(nk) == 0
            A = 0
            return A
        end

        # initialize stuff
        I = zeros(4*nk,1)
        J = zeros(4*nk,1)
        S = zeros(4*nk,1)
        a = 1
        b = 2
        c = 3
        d = 4
        l = 1

        # loop
        for i = 1:nk
            # find gridpoints x1([a,b,c,d]) surrounding x2[k]
            k = ik[i]
            if x2[k] < x1[b]
                while (x2[k]<x1[b]) & (b-1>1)
                    b=b-1
                end
                a=b-1
                c=b+1
                d=c+1
            elseif x2[k]>x1[c]
                while (x2[k]>x1[c]) & (c+1<n1)
                    c=c+1
                end
                a=c-2
                b=c-1
                d=c+1
            end
            # row indices
            I[l:l+3] = k
            # column indices
            J[l:l+3] = [a b c d]
            # interpolation weights
            S[l]   = ((x2[k]-x1[b])*(x2[k]-x1[c])*(x2[k]-x1[d]))/((x1[a]-x1[b])*(x1[a]-x1[c])*(x1[a]-x1[d]));
            S[l+1] = ((x2[k]-x1[a])*(x2[k]-x1[c])*(x2[k]-x1[d]))/((x1[b]-x1[a])*(x1[b]-x1[c])*(x1[b]-x1[d]));
            S[l+2] = ((x2[k]-x1[b])*(x2[k]-x1[a])*(x2[k]-x1[d]))/((x1[c]-x1[b])*(x1[c]-x1[a])*(x1[c]-x1[d]));
            S[l+3] = ((x2[k]-x1[b])*(x2[k]-x1[c])*(x2[k]-x1[a]))/((x1[d]-x1[b])*(x1[d]-x1[c])*(x1[d]-x1[a]));
            # increase counter
            l = l + 4
        end

        # construct sparse matrix
        A = sparse(I[1:l-1], J[1:l-1], S[1:l-1], n2, n1)

        return A
    end

    function fwd_NMO(in::Vector{idt}, t::Vector, h::Vector, v::Vector, rdt::DataType) where idt<:Real

        (idt<:Real && rdt<:Real) || throw(joLinearFunctionException("joNMO: input and output must be real"))

        dt   = t[2] - t[1]
        tN   = length(t)
        hN   = length(h)

        input = reshape(in,tN,hN)
        h=jo_convert(idt,h)
        v=jo_convert(idt,vec(v))

        out = zeros(Complex{rdt}, tN, hN)

        # loop over offset
        for i = 1:hN
            # NMO traveltime
            tau = sqrt.(t.^2 + h[i].^2./v.^2);
            # interpolate, forward or adjoint
            A   = getLA(t, tau);
            out[:, i] = A*input[:,i];
        end

        out = jo_convert(rdt,vec(out))

        return out
    end

    function adj_NMO(in::Vector{idt}, t::Vector, h::Vector, v::Vector, rdt::DataType) where idt<:Real

        (idt<:Real && rdt<:Real) || throw(joLinearFunctionException("joNMO: input and output must be real"))

        dt   = t[2] - t[1]
        tN   = length(t)
        hN   = length(h)

        input = reshape(in,tN,hN)
        h=jo_convert(idt,h)
        v=jo_convert(idt,vec(v))

        out = zeros(Complex{rdt}, tN, hN)

        # loop over offset
        for i = 1:hN
            # NMO traveltime
            tau = sqrt.(t.^2 + h[i].^2./v.^2);
            # interpolate, forward or adjoint
            A   = getLA(t, tau)
            out[:, i] = A'*input[:,i]
        end
        out = jo_convert(rdt,vec(out))

        return out
    end
end
using .joNMO_etc

export joNMO
"""
    julia> joNMO(t,h,v)

NMO correction fo a common midpoint gather

# Signature

    joNMO(t::Vector,h::Vector,v::Vector;DDT::DataType=joComplex,RDT::DataType=DDT)

# Arguments

- `t`: time vector [s]
- `h`: offset vector [m]
- `v`: NMO velocity

# Notes

- joNMNO is dimensionalized; it is not standard units-independent operator
- 2D array must be in vectorized form of array(t,h) of size (length(t),length(q))

"""
function joNMO(t::Vector,h::Vector,v::Vector;DDT::DataType=joFloat,RDT::DataType=DDT)
    (DDT<:Real && RDT<:Real) || throw(joLinearFunctionException("joNMO: domain and range must be real"))
    nt=length(t)
    nh=length(h)
    nv=length(v)
    return joLinearFunctionFwdT(nt*nh,nt*nh,
        v1->joNMO_etc.fwd_NMO(vec(v1),t,h,v,RDT),
        v2->joNMO_etc.adj_NMO(vec(v2),t,h,v,DDT),
        DDT,RDT;
        name="joNMO")
end
