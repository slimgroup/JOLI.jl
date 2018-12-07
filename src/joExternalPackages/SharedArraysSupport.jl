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
    function jo_x_mv!(F::Function,din::joPAsetup,dout::joPAsetup,
            in::SharedArray{ADDT,2},out::SharedArray{ARDT,2}) where {ADDT,ARDT}

        @sync @distributed for i in din.procs
            out[dout.idxs[indexpids(out)]...]=jo_convert(ARDT,F(in[din.idxs[indexpids(in)]...]))
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
    return SharedArray{DT,length(d.dims)}(d.dims,pids=d.procs)
end

export szeros
function szeros(d::joPAsetup;DT::DataType=d.DT)
    fill=S->S[SharedArrays.localindices(S)]=zeros(DT,length(SharedArrays.localindices(S)))
    S = SharedArray{DT,length(d.dims)}(d.dims, init=fill, pids=d.procs)
    return S
end

export sones
function sones(d::joPAsetup;DT::DataType=d.DT)
    fill=S->S[SharedArrays.localindices(S)]=ones(DT,length(SharedArrays.localindices(S)))
    S = SharedArray{DT,length(d.dims)}(d.dims, init=fill, pids=d.procs)
    return S
end

export srand
function srand(d::joPAsetup;DT::DataType=d.DT)
    fill=S->S[SharedArrays.localindices(S)]=rand(DT,length(SharedArrays.localindices(S)))
    S = SharedArray{DT,length(d.dims)}(d.dims, init=fill, pids=d.procs)
    return S
end

export srandn
function srandn(d::joPAsetup;DT::DataType=d.DT)
    fill=S->S[SharedArrays.localindices(S)]=randn(DT,length(SharedArrays.localindices(S)))
    S = SharedArray{DT,length(d.dims)}(d.dims, init=fill, pids=d.procs)
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
    SA=SharedArray{eltype(A),ndims(A)}(d.dims,pids=d.procs)
    SA[:]=A[:]
    return SA
end

