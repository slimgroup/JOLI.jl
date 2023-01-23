# Extension operator: joExtend

## helper module
module joExtend_etc
    using JOLI: jo_convert, LocalVector, LocalMatrix
    ### zeros
    function zeros_fwd(v::LocalVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = [zeros(VT,pad_lower); v; zeros(VT,pad_upper)]
        return jo_convert(rdt,w,false)
    end
    function zeros_fwd(v::LocalMatrix{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = [zeros(VT,pad_lower,size(v,2)); v; zeros(VT,pad_upper,size(v,2))]
        return jo_convert(rdt,w,false)
    end
    function zeros_tran(v::LocalVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = v[pad_lower+1:n+pad_lower]
        return jo_convert(rdt,w,false)
    end
    function zeros_tran(v::LocalMatrix{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = v[pad_lower+1:n+pad_lower,:]
        return jo_convert(rdt,w,false)
    end
    ### border
    function border_fwd(v::LocalVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = [repeat([v[1]],pad_lower); v; repeat([v[end]],pad_upper)]
        return jo_convert(rdt,w,false)
    end
    function border_fwd(v::LocalMatrix{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = [repeat(v[1:1,:],pad_lower,1); v; repeat(v[end:end,:],pad_upper,1)]
        return jo_convert(rdt,w,false)
    end
    function border_tran(v::LocalVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = v[pad_lower+1:end-pad_upper]
        w[1] += sum(v[1:pad_lower])
        w[end] += sum(v[end-pad_upper+1:end])
        return jo_convert(rdt,w,false)
    end
    function border_tran(v::LocalMatrix{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = v[pad_lower+1:end-pad_upper,:]
        w[1:1,:] += sum(v[1:pad_lower,:],dims=1)
        w[end:end,:] += sum(v[end-pad_upper+1:end,:],dims=1)
        return jo_convert(rdt,w,false)
    end
    ### mirror
    function mirror_fwd(v::LocalVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = [reverse(v[1:pad_lower]); v; reverse(v[end-pad_upper+1:end])]
        return jo_convert(rdt,w,false)
    end
    function mirror_fwd(v::LocalMatrix{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = [reverse(v[1:pad_lower,:],dims=1); v; reverse(v[end-pad_upper+1:end,:],dims=1)]
        return jo_convert(rdt,w,false)
    end
    function mirror_tran(v::LocalVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = v[pad_lower+1:end-pad_upper]
        w[1:pad_lower] += reverse(v[1:pad_lower])
        w[end-pad_upper+1:end] += reverse(v[end-pad_upper+1:end])
        return jo_convert(rdt,w,false)
    end
    function mirror_tran(v::LocalMatrix{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = v[pad_lower+1:end-pad_upper,:]
        w[1:pad_lower,:] += reverse(v[1:pad_lower,:],dims=1)
        w[end-pad_upper+1:end,:] += reverse(v[end-pad_upper+1:end,:],dims=1)
        return jo_convert(rdt,w,false)
    end
    ### periodic
    function periodic_fwd(v::LocalVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = [v[end-pad_lower+1:end]; v; v[1:pad_upper]]
        return jo_convert(rdt,w,false)
    end
    function periodic_fwd(v::LocalMatrix{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = [v[end-pad_lower+1:end,:]; v; v[1:pad_upper,:]]
        return jo_convert(rdt,w,false)
    end
    function periodic_tran(v::LocalVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = v[pad_lower+1:end-pad_upper]
        w[1:pad_upper] += v[end-pad_upper+1:end]
        w[end-pad_lower+1:end] += v[1:pad_lower]
        return jo_convert(rdt,w,false)
    end
    function periodic_tran(v::LocalMatrix{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType) where {VT<:Number}
        w = v[pad_lower+1:end-pad_upper,:]
        w[1:pad_upper,:] += v[end-pad_upper+1:end,:]
        w[end-pad_lower+1:end,:] += v[1:pad_lower,:]
        return jo_convert(rdt,w,false)
    end
end
using .joExtend_etc

export joExtend
"""
    julia> op = joExtend(n,pad_type;[pad_lower=...,][pad_upper=...,][DDT=...,][RDT=...,][name=...])

1D extension operator

# Signature

    function joExtend(n::Integer,pad_type::Symbol;
        pad_upper::Integer=0,pad_lower::Integer=0,
        DDT::DataType=joFloat,RDT::DataType=DDT,
        name="joExtend")

# Arguments

- `n` : size of input vector
- `pad_type` : one of the symbols
   - `:zeros` : pad signal with zeros
   - `:border` : pad signal with values at the edge of the domain
   - `:mirror` : mirror extension of the signal
   - `:periodic` : periodic extension of the signal
- keywords
    - `pad_lower` : number of points to pad on the lower index end
    - `pad_upper` : number of points to pad on the upper index end
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Examples

extend a n-length vector with 10 zeros on either side

    joExtend(n,:zeros; pad_lower=10,pad_upper=10)

append, to a n-length vector, so that x[n+1:n+10] = x[n]

    joExtend(n,:border; pad_upper=10)

prepend, to n-length vector, its mirror extension: y=[reverse(x[1:10]);x]

    joExtend(n,:mirror; pad_lower=10)

append, to n-length vector, its periodic extension: y=[x;x[1:10]]

    joExtend(n,:periodic; pad_upper=10)

examples with DDT/RDT

    joExtend(n,:mirror; pad_lower=10,DDT=Float32)
    joExtend(n,:periodic; pad_upper=10,DDT=Float32,RDT=Float64)

"""
function joExtend(n::Integer,pad_type::Symbol;
    pad_upper::Integer=0,pad_lower::Integer=0,
    DDT::DataType=joFloat,RDT::DataType=DDT,
    name="joExtend")

    (pad_upper>=0) || throw(joLinearFunctionException("joExtend: invalid pad_upper size; should be >=0"))
    (pad_lower>=0) || throw(joLinearFunctionException("joExtend: invalid pad_lower size; should be >=0"))
    if pad_type==:zeros
        return joLinearFunctionFwd(n+pad_lower+pad_upper,n,
                                v1->joExtend_etc.zeros_fwd(v1,n,pad_upper,pad_lower,RDT),
                                v2->joExtend_etc.zeros_tran(v2,n,pad_upper,pad_lower,DDT),
                                v2->joExtend_etc.zeros_tran(v2,n,pad_upper,pad_lower,DDT),
                                v1->joExtend_etc.zeros_fwd(v1,n,pad_upper,pad_lower,RDT),
                                DDT,RDT;fMVok=true,
                                name=name*"_zeros")
    elseif pad_type==:border
        return joLinearFunctionFwd(n+pad_lower+pad_upper,n,
                                v1->joExtend_etc.border_fwd(v1,n,pad_upper,pad_lower,RDT),
                                v2->joExtend_etc.border_tran(v2,n,pad_upper,pad_lower,DDT),
                                v2->joExtend_etc.border_tran(v2,n,pad_upper,pad_lower,DDT),
                                v1->joExtend_etc.border_fwd(v1,n,pad_upper,pad_lower,RDT),
                                DDT,RDT;fMVok=true,
                                name=name*"_border")
    elseif pad_type==:mirror
        (pad_upper<=n) || throw(joLinearFunctionException("joExtend: invalid pad_upper size; should be <=n"))
        (pad_lower<=n) || throw(joLinearFunctionException("joExtend: invalid pad_lower size; should be <=n"))
        return joLinearFunctionFwd(n+pad_lower+pad_upper,n,
                                v1->joExtend_etc.mirror_fwd(v1,n,pad_upper,pad_lower,RDT),
                                v2->joExtend_etc.mirror_tran(v2,n,pad_upper,pad_lower,DDT),
                                v2->joExtend_etc.mirror_tran(v2,n,pad_upper,pad_lower,DDT),
                                v1->joExtend_etc.mirror_fwd(v1,n,pad_upper,pad_lower,RDT),
                                DDT,RDT;fMVok=true,
                                name=name*"_mirror")
    elseif pad_type==:periodic
        (pad_upper<=n) || throw(joLinearFunctionException("joExtend: invalid pad_upper size; should be <=n"))
        (pad_lower<=n) || throw(joLinearFunctionException("joExtend: invalid pad_lower size; should be <=n"))
        return joLinearFunctionFwd(n+pad_lower+pad_upper,n,
                                v1->joExtend_etc.periodic_fwd(v1,n,pad_upper,pad_lower,RDT),
                                v2->joExtend_etc.periodic_tran(v2,n,pad_upper,pad_lower,DDT),
                                v2->joExtend_etc.periodic_tran(v2,n,pad_upper,pad_lower,DDT),
                                v1->joExtend_etc.periodic_fwd(v1,n,pad_upper,pad_lower,RDT),
                                DDT,RDT;fMVok=true,
                                name=name*"_periodic")
    else
        throw(joLinearFunctionException("joExtend: unknown extension type."))
    end
    return nothing
end
