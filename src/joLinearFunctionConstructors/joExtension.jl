export joExtension, EXT_TYPE

@enum EXT_TYPE pad_zeros pad_border pad_periodic

function apply_pad(v::Array{DDT,1},n::T,pad_type::EXT_TYPE,pad_upper::T,pad_lower::T; forw_mode::Bool=true) where {T<:Integer,DDT<:Number}
    nbdry_pts::T = pad_lower+pad_upper
    next::T = n+nbdry_pts
    lenv::T = length(v)   
    nrhs::T = forw_mode ? lenv/n : lenv/next
    w = reshape(v,forw_mode ? n : next,nrhs)

    if pad_type==pad_zeros
        if forw_mode
            w = [zeros(pad_lower,nrhs); w; zeros(pad_upper,nrhs)]
        else
            w = w[pad_lower+1:n+pad_lower,:]
        end
    elseif pad_type==pad_border
        if forw_mode
            w = [repeat(v[1,:],pad_lower,1); v; repeat(v[end,:],pad_upper,1) ]
        else
            w = w[pad_lower+1:end-pad_upper,:]
            w[1,:] = w[1,:] + sum(v[1:pad_lower,:],1)
            w[end,:] = w[end,:] + sum(v[end-pad_upper+1:end,:],1)
        end
    elseif pad_type==pad_periodic
        if forw_mode
            w = [flipdim(v[1:pad_lower,:],1); v; flipdim(v[end-pad_upper+1:end,:],1)]
        else
            w = w[pad_lower+1:end-pad_upper,:]
            w[1:pad_lower,:] = w[1:pad_lower,:] + flipdim(v[1:pad_lower,:],1)
            w[end-pad_upper+1:end,:] = w[end-pad_upper+1:end,:] + flipdim(v[end-pad_upper+1:end,:],1)
        end
    end

    return vec(w)
end

 
"""
1D extension operator 

   joExtension(n,pad_type; pad_lower=0,pad_upper=0,DDT=joFloat,RDT=DDT)

# Arguments

- n : size of input vector
- pad_type : one of EXT_TYPE 
   - pad_zeros - pad signal with zeros
   - pad_border - pad signal with values at the edge of the domain
   - pad_periodic - periodic extension of the signal
- pad_lower : number of points to pad on the low end index (keyword arg, default=0)
- pad_upper : number of points to pad on the upper index (keyword arg, default=0)

# Examples
- joExtension(n,pad_zeros,pad_lower=10,pad_upper=10)
  - pads a n- length vector with 10 zeros on either side

- joExtension(n,pad_periodic,pad_lower=10)
  - extends an n-length vector by its periodic extension starting at index 1

- joExtension(n,pad_border,pad_upper=10)
  - extends a n-length vector so that x[n+1:n+10] = x[n]

"""
function joExtension(n::T, pad_type::EXT_TYPE; pad_upper::T=0,pad_lower::T=0,DDT::DataType=joFloat,RDT::DataType=DDT) where {T<:Integer}
    
    warn("joExtension is deprecated. Use joExtend and pay attention to syntax changes.";once=true, key="joExtension")
    return joLinearFunctionFwdT(n+pad_lower+pad_upper,n,
                                v1->apply_pad(v1,n,pad_type,pad_upper,pad_lower,forw_mode=true),
                                v2->apply_pad(v2,n,pad_type,pad_upper,pad_lower,forw_mode=false),DDT,RDT;
                                name="joExtension")
end


