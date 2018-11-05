# joSRtoCMO - converts shot record to common-midpoint offset

## helper module
module joSRtoCMO_etc
    using JOLI: jo_convert
    # forward SRtoCMO
    function SRtoCMOfwd(x::AbstractVector,nr::Int,ns::Int,RDT::DataType)
        x    = reshape(x,nr,ns);
        B    = zeros(RDT,nr,2*ns-1);
        for k = 1-ns:1:nr-1
        B[floor(Int,abs(k)/2)+1:floor(Int,abs(k)/2)+length(diag(x,k)),ns+k] = diag(x,k);
        end
        B = B[:];
        B=jo_convert(RDT,B,false);
        return B
    end
    # adjoint SRtoCMO
    function SRtoCMOadj(x::AbstractVector,nr::Int,ns::Int,RDT::DataType)
        x = reshape(x,nr,2*ns-1);
        B = zeros(RDT,nr,ns);
        for k = 1-ns:1:nr-1
            B[diagind(B,k)]=vec(x[floor(Int,abs(k)/2)+1:floor(Int,abs(k)/2)+length(diag(B,k)),ns+k]);
        end
        B = B[:];
        B=jo_convert(RDT,B,false);
        return B
    end
end
using .joSRtoCMO_etc

export joSRtoCMO
"""
    julia> joSRtoCMO(M,N)

converter from shot record to common-midpoint offset record

# Signature

    joSRtoCMO(nr::Int,ns::Int;DDT::DataType=joComplex,RDT::DataType=DDT)

# Arguments

- M : ?
- N : ?

# Notes

- ?

# Examples

- ?

"""
function joSRtoCMO(nr::Int,ns::Int;DDT::DataType=joComplex,RDT::DataType=DDT)
    joLinearFunctionFwdT((nr)*(2*ns-1),nr*ns,
        v1->joSRtoCMO_etc.SRtoCMOfwd(v1,nr,ns,RDT),
        v2->joSRtoCMO_etc.SRtoCMOadj(v2,nr,ns,DDT),
        DDT,RDT;
        name="joSRtoCMO")
end
