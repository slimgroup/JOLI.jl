# joRomberg operator

## helper module
module joJRM_etc

    function apply_fwd(As, z; γ=1f0)
        x = [1f0/γ*z[1]+z[i+1] for i = 1:length(As)]   # get original component
        b = [As[i]*x[i] for i=1:length(As)]
        return b
    end 

    function apply_adj(As, b; γ=1f0)
        x = [adjoint(As[i]) * b[i] for i=1:length(b)]  # get original adjoint
        z = [1f0/γ*sum(x), x...]   # weighted sum on common component
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

    isempty(ops) && throw(joLinearFunctionException("empty argument list"))
    L=length(ops)
    DDT = deltype(ops[1])
    RDT = reltype(ops[1])
    for i=2:L
        deltype(ops[i])==DDT || throw(joLinearFunctionException("domain type mismatch for $(i-1) and $i operators"))
        reltype(ops[i])==RDT || throw(joLinearFunctionException("range type mismatch for $(i-1) and $i operators"))
    end
    return joLinearFunctionFwd(L, L+1,
        v1 -> joJRM_etc.apply_fwd(ops,v1; γ=γ),
        v2 -> joJRM_etc.apply_adj(ops,v2; γ=γ),
        v3 -> joJRM_etc.apply_adj(ops,v3; γ=γ),
        v4 -> joJRM_etc.apply_fwd(ops,v4; γ=γ),
        DDT, RDT; name=name)
end
