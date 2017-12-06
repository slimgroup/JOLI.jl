# Extension operator: joExtend

## helper module
module joExtend_etc
    using JOLI: jo_convert
    ### zeros
    function zeros_fwd{VT<:Number}(v::AbstractVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType)
        w = [zeros(VT,pad_lower); v; zeros(VT,pad_upper)]
        return jo_convert(rdt,w,false)
    end
    function zeros_tran{VT<:Number}(v::AbstractVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType)
        w = v[pad_lower+1:n+pad_lower]
        return jo_convert(rdt,w,false)
    end
    ### border
    function border_fwd{VT<:Number}(v::AbstractVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType)
        w = [repmat([v[1]],pad_lower); v; repmat([v[end]],pad_upper)]
        return jo_convert(rdt,w,false)
    end
    function border_tran{VT<:Number}(v::AbstractVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType)
        w = v[pad_lower+1:end-pad_upper]
        w[1] = w[1] + sum(v[1:pad_lower])
        w[end] = w[end] + sum(v[end-pad_upper+1:end])
        return jo_convert(rdt,w,false)
    end
    ### mirror
    function mirror_fwd{VT<:Number}(v::AbstractVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType)
        w = [reverse(v[1:pad_lower]); v; reverse(v[end-pad_upper+1:end])]
        return jo_convert(rdt,w,false)
    end
    function mirror_tran{VT<:Number}(v::AbstractVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType)
        w = v[pad_lower+1:end-pad_upper]
        w[1:pad_lower] = w[1:pad_lower] + reverse(v[1:pad_lower])
        w[end-pad_upper+1:end] = w[end-pad_upper+1:end] + reverse(v[end-pad_upper+1:end])
        return jo_convert(rdt,w,false)
    end
    ### periodic
    function periodic_fwd{VT<:Number}(v::AbstractVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType)
        w = [v[end-pad_lower+1:end]; v; v[1:pad_upper]]
        return jo_convert(rdt,w,false)
    end
    function periodic_tran{VT<:Number}(v::AbstractVector{VT},n::Integer,pad_upper::Integer,pad_lower::Integer,rdt=DataType)
        w = v[pad_lower+1:end-pad_upper]
        w[1:pad_upper] = w[1:pad_upper] + v[end-pad_upper+1:end]
        w[end-pad_lower+1:end] = w[end-pad_lower+1:end] + v[1:pad_lower]
        return jo_convert(rdt,w,false)
    end
end
using .joExtend_etc

export joExtend
"""
1D extension operator

   joExtend(n,pad_type; pad_lower=0,pad_upper=0,DDT=joFloat,RDT=DDT)

# Arguments
- n : size of input vector
- pad_type : one of the symbols
   - :zeros - pad signal with zeros
   - :border - pad signal with values at the edge of the domain
   - :mirror - mirror extension of the signal
   - :periodic - periodic extension of the signal
- pad_lower : number of points to pad on the lower index end (keyword arg, default=0)
- pad_upper : number of points to pad on the upper index end (keyword arg, default=0)

# Examples
- joExtend(n,:zeros,pad_lower=10,pad_upper=10)
  - extends a n-length vector with 10 zeros on either side

- joExtend(n,:border,pad_upper=10)
  - appends, to a n-length vector, so that x[n+1:n+10] = x[n]

- joExtend(n,:mirror,pad_lower=10)
  - prepends, to a n-length vector, its mirror extension
  - y=[reverse(x[1:10]);x]

- joExtend(n,:periodic,pad_upper=10)
  - appends, to a n-length vector, its periodic extension
  - y=[x;x[1:10]]

"""
function joExtend(n::Integer,pad_type::Symbol; pad_upper::Integer=0,pad_lower::Integer=0,DDT::DataType=joFloat,RDT::DataType=DDT)
    (pad_upper>=0 && pad_upper<=n) || error("joExtend: invalid pad_upper size; should be 0<= pad_upper <=n")
    (pad_lower>=0 && pad_lower<=n) || error("joExtend: invalid pad_lower size; should be 0<= pad_lower <=n")
    if pad_type==:zeros
        return joLinearFunctionFwd(n+pad_lower+pad_upper,n,
                                v1->joExtend_etc.zeros_fwd(v1,n,pad_upper,pad_lower,RDT),
                                v2->joExtend_etc.zeros_tran(v2,n,pad_upper,pad_lower,DDT),
                                v2->joExtend_etc.zeros_tran(v2,n,pad_upper,pad_lower,DDT),
                                v1->joExtend_etc.zeros_fwd(v1,n,pad_upper,pad_lower,RDT),
                                DDT,RDT;#fMVok=true,
                                name="joExtend(zeros)")
    elseif pad_type==:border
        return joLinearFunctionFwd(n+pad_lower+pad_upper,n,
                                v1->joExtend_etc.border_fwd(v1,n,pad_upper,pad_lower,RDT),
                                v2->joExtend_etc.border_tran(v2,n,pad_upper,pad_lower,DDT),
                                v2->joExtend_etc.border_tran(v2,n,pad_upper,pad_lower,DDT),
                                v1->joExtend_etc.border_fwd(v1,n,pad_upper,pad_lower,RDT),
                                DDT,RDT;#fMVok=true,
                                name="joExtend(border)")
    elseif pad_type==:mirror
        return joLinearFunctionFwd(n+pad_lower+pad_upper,n,
                                v1->joExtend_etc.mirror_fwd(v1,n,pad_upper,pad_lower,RDT),
                                v2->joExtend_etc.mirror_tran(v2,n,pad_upper,pad_lower,DDT),
                                v2->joExtend_etc.mirror_tran(v2,n,pad_upper,pad_lower,DDT),
                                v1->joExtend_etc.mirror_fwd(v1,n,pad_upper,pad_lower,RDT),
                                DDT,RDT;#fMVok=true,
                                name="joExtend(mirror)")
    elseif pad_type==:periodic
        return joLinearFunctionFwd(n+pad_lower+pad_upper,n,
                                v1->joExtend_etc.periodic_fwd(v1,n,pad_upper,pad_lower,RDT),
                                v2->joExtend_etc.periodic_tran(v2,n,pad_upper,pad_lower,DDT),
                                v2->joExtend_etc.periodic_tran(v2,n,pad_upper,pad_lower,DDT),
                                v1->joExtend_etc.periodic_fwd(v1,n,pad_upper,pad_lower,RDT),
                                DDT,RDT;#fMVok=true,
                                name="joExtend(periodic)")
    else
        error("joExtend: unknown extension type.")
    end
    return nothing
end

