# joRomberg operator

## helper module
module joJRM_etc

    function apply_fwd(As, z)
	    # Sum z_i according to the weighting matrix
	    vec = As[end] * z
	    # Apply diag(ops) to summed z_i
	    return [As[i]*vec[i] for i=1:length(As)-1]
    end 

    function apply_adj(As, b)
	    # Apply diag(adj(ops)) * b[i], then sum on common component
        z = adjoint(As[end]) * [adjoint(As[i]) * b[i] for i=1:length(b)]
        return z
    end

end
using .joJRM_etc

export joJRM
"""
    julia> op = joJRM(ops;[name=...])

JRM operator of an array of JOLI operators

# Signature

    joJRM(ops::Vector{joAbstractLinearOperator}; γ::Number=1f0, name::String="joJRM")

# Arguments

- `ops`: an array of JOLI operators (subtypes of joAbstractLinearOperator)
- keywords
    - `γ`: weight of common component = 1/γ
    - `name`: custom name

# Notes

- the domain and range types of joJRM are equal to domain type of any operator in ops
- all operators in the array ops must have the same domain/range types

# Example

define operators

    ops = [joDiag(randn(Float32,3); DDT=Float32, RDT=Float32) for i = 1:4]
    γ = 2f0

define JRM operator

    A=joJRM(ops; γ=γ)

"""
function joJRM(ops::Vector{T}; γ::Number=1f0, name::String="joJRM") where {T<:joAbstractOperator}

    isempty(ops) && throw(joKronException("empty argument list"))
    L=length(ops)
    DDT = deltype(ops[1])
    RDT = reltype(ops[1])
    for i=2:L
        deltype(ops[i])==DDT || throw(joKronException("domain type mismatch for $(i-1) and $i operators"))
        reltype(ops[i])==RDT || throw(joKronException("range type mismatch for $(i-1) and $i operators"))
    end
    Iz  = Array{Any}(undef, L, L+1)
    for i=1:L
        for j=1:L+1
            Iz[i,j] = 0
        end
        Iz[i,1]  = 1f0/γ*joEye(size(ops[i],2); RDT=DDT, DDT=DDT)
    end
    collect(Iz[i,i+1] = joEye(size(ops[i],2); RDT=DDT, DDT=DDT) for i=1:L)
    As = [ops..., Iz]
    return joLinearFunctionFwd_T(L, L+1,
        z -> joJRM_etc.apply_fwd(As,z),
        b -> joJRM_etc.apply_adj(As,b),
        DDT, RDT, name=name)
end
