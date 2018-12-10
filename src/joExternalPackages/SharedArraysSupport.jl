# helper module with misc SharedArray utilities
module joSAutils
    using Distributed
    using SharedArrays
    using JOLI: jo_convert, joAbstractLinearOperator, joPAsetup

    function jo_x_mv!(A::joAbstractLinearOperator,din::joPAsetup,dout::joPAsetup,
            in::SharedArray{ADDT,2},out::SharedArray{ARDT,2}) where {ADDT,ARDT}

        @sync @distributed for i in din.procs
            out[dout.idxs[indexpids(out)]...]=jo_convert(ARDT,A*in[din.idxs[indexpids(in)]...])
        end
        return nothing
    end
    # Tuple{Vararg{UnitRange}}
    # Tuple{Vararg{UnitRange{INT}}} where INT<:Integer
    function jo_x_mv!(F::Function,din::joPAsetup,dout::joPAsetup,
            in::SharedArray{ADDT,2},out::SharedArray{ARDT,2}) where {ADDT,ARDT}

        #out[:,:] = F(sdata(in))
        P=length(in.pids)
        @sync @distributed for p=1:P
            out[dout.idxs[p]...]=jo_convert(ARDT,F(in[din.idxs[p]...]))
        end
        return nothing
    end
end
using .joSAutils

export salloc
"""
    julia> salloc(d; [DT])

Allocates a SharedArray according to given distributor

# Signature

    salloc(d::joPAsetup;DT::DataType=d.DT)

# Arguments

- `d`: see help for joPAsetup
- `DT`: keyword argument to overwrite the type in joPAsetup

# Examples

- `salloc(d)`: allocate an array
- `salloc(d,DT=Float32)`: allocate array and overwite d.DT with Float32

"""
function salloc(d::joPAsetup;DT::DataType=d.DT)
    #S = SharedArray{DT}(d.dims; pids=d.procs)
    S = SharedArray{DT}(d.dims)
    return S
end

export szeros
function szeros(d::joPAsetup;DT::DataType=d.DT)
    fill=S->S[SharedArrays.localindices(S)]=zeros(DT,length(SharedArrays.localindices(S)))
    #S = SharedArray{DT}(d.dims; init=fill, pids=d.procs)
    S = SharedArray{DT}(d.dims; init=fill)
    return S
end

export sones
function sones(d::joPAsetup;DT::DataType=d.DT)
    fill=S->S[SharedArrays.localindices(S)]=ones(DT,length(SharedArrays.localindices(S)))
    #S = SharedArray{DT}(d.dims; init=fill, pids=d.procs)
    S = SharedArray{DT}(d.dims; init=fill)
    return S
end

export srand
function srand(d::joPAsetup;DT::DataType=d.DT)
    fill=S->S[SharedArrays.localindices(S)]=rand(DT,length(SharedArrays.localindices(S)))
    #S = SharedArray{DT}(d.dims; init=fill, pids=d.procs)
    S = SharedArray{DT}(d.dims; init=fill)
    return S
end

export srandn
function srandn(d::joPAsetup;DT::DataType=d.DT)
    fill=S->S[SharedArrays.localindices(S)]=randn(DT,length(SharedArrays.localindices(S)))
    #S = SharedArray{DT}(d.dims; init=fill, pids=d.procs)
    S = SharedArray{DT}(d.dims; init=fill)
    return S
end

export scatter
"""
    julia> scatter(A,d)

Scatters SharedArray according to given joPAsetup.

# Signature

    scatter(a::AbstractArray,d::joPAsetup)

# Arguments

- `A`: array to ditribute
- `d`: see help for joPAsetup

# Notes

- the type in joPAsetup is ignored here
- one of the dimensions must be large enough to hold at least one element on each worker

# Examples

- `scatter(A,d)`: scatter A using given distributor
- `scatter(A,joPAsetup(size(A)...))`: scatter A using default distributor settings

"""
function scatter(A::AbstractArray,d::joPAsetup)
    size(A)==d.dims || throw(joPAsetupException("joPAsetup: array size does not match dims of joPAsetup"))
    #SA=SharedArray{eltype(A)}(d.dims; pids=d.procs)
    SA = SharedArray{eltype(A)}(d.dims)
    SA[:] = A[:]
    return SA
end

