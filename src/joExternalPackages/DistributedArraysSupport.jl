# helper module with misc DArray utilities
module joDAutils
    using DistributedArrays
    using JOLI: jo_convert, joAbstractLinearOperator

    function DArray5(init, dims, procs, idxs, cuts)
        dist = chunks=map(i->length(i)-1,cuts)
        np = prod(dist)
        procs = reshape(procs[1:np], ntuple(i->dist[i], length(dist)))
        id = DistributedArrays.next_did()
        return DArray(id, init, dims, procs, idxs, cuts)
    end
    function jo_x_mv!(A::joAbstractLinearOperator,in::DArray{ADDT,2},out::DArray{ARDT,2}) where {ADDT,ARDT}
        out[:L]=jo_convert(ARDT,A*in[:L])
        return nothing
    end
    function jo_x_mv!(F::Function,in::DArray{ADDT,2},out::DArray{ARDT,2}) where {ADDT,ARDT}
        out[:L]=jo_convert(ARDT,F(in[:L]))
        return nothing
    end
end
using .joDAutils

export dparts
"""
    julia> dparts(da)

return partitioning vector of DArray if partioned in single dimension

# Signature

    dparts(da::DArray{T,N})

# Arguments

- `da`: DArray

# Notes

- if DArray is quasi-distributed (over single worker), dparts returns size(da,N)

"""
function dparts(da::DArray{T,N}) where {T,N}
    chunks=map(i->length(i)-1,da.cuts)
    dim=findfirst(i->i>1,chunks); dim = dim==nothing ? N : dim
    ldim=findlast(i->i>1,chunks); ldim = ldim==nothing ? N : ldim
    dim==ldim || throw(joPAsetupException("joPAsetup: cannot return parts of a DArray partitioned in multiple dimensions"))
    parts=map(i->length(i[dim]),da.indices)
    return vec(parts)
end

export dcopy
"""
    julia> dcopy(dtr,[dst])

copy transpose(DArray) into a new DArray using predefined joPAsetup

# Signature

    dcopy(Dtr::Transpose{T,<:DArray{T,2}},dst::joPAsetup)
    dcopy(Dtr::Transpose{T,<:DArray{T,2}})

# Arguments

- `dtr`: transpose(DArray)
- `dst`: target joPAsetup

"""
function dcopy(Dtr::Transpose{T,<:DArray{T,2}},dst::joPAsetup) where T
    Dst=joPAsetup(parent(Dtr))
    Dst.dims==reverse(dst.dims) || throw(joPAsetupException("the sizes of original array and provided target distributor do not match"))
    Dst.procs==dst.procs || throw(joPAsetupException("the workers of original array and provided target distributor do not match"))

    D = parent(Dtr)
    joDAutils.DArray5(dst.dims, dst.procs, dst.idxs, dst.cuts) do I
        # @debug I rI=reverse(I)
        lp = Array{T}(undef, map(length, I))
        rp = convert(Array, D[reverse(I)...])
        transpose!(lp, rp)
    end
end
function dcopy(Dtr::Transpose{T,<:DArray{T,2}}) where T
    Dst=transpose(joPAsetup(parent(Dtr)))
    return dcopy(Dtr,Dst)
end

export dalloc
"""
    julia> dalloc(dims, [...])

Allocates a DistributedArrays.DArray without value assigment.

Use it to allocate quicker the array that will have all elements overwritten.

# Signature

    dalloc(dims::Dims, [...])

# Arguments

- optional trailing arguments are the same as those accepted by `DArray`.

"""
dalloc(dims::Dims, args...) = DArray(I->Array{joFloat}(map(length,I)), dims, args...)
dalloc(::Type{T}, dims::Dims, args...) where {T} = DArray(I->Array{T}(undef,map(length,I)), dims, args...)
dalloc(::Type{T}, d1::Integer, drest::Integer...) where {T} = dalloc(T, convert(Dims, tuple(d1, drest...)))
dalloc(d1::Integer, drest::Integer...) = dalloc(joFloat, convert(Dims, tuple(d1, drest...)))
dalloc(d::Dims) = dalloc(joFloat, d)

export dfill
"""
    julia> dfill(F, d; [DT])

Constructs a DistributedArrays.DArray, according to given distributor, filled with elements provided by anonymous function F.

# Signature

    dfill(F::Function,d::joPAsetup;DT::DataType=d.DT)

# Arguments

- `F`: anonymous function of the form `I->f(...,map(length,I)))`
- `d`: see help for joPAsetup
- `DT`: keyword argument to overwrite the type in joPAsetup

# Notes

- function F will be passed via `map(length,I)` the tuple with dimensions of local part
- one has to pass array type manualy to F

# Examples

- `dfill(I->ones(d.DT,map(length,I)),d)`: fill a distributed array with ones of type d.DT

"""
function dfill(F::Function,d::joPAsetup;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, F, d.dims, procs, d.idxs, d.cuts)
end

"""
    julia> dfill(x, d; [DT])

Constructs a DistributedArrays.DArray, according to given distributor, filled with x.

# Signature

    dfill(x::Number,d::joPAsetup;DT::DataType=d.DT)

# Arguments

- `d`: see help for joPAsetup
- `DT`: keyword argument to overwrite the type in joPAsetup

# Examples

- `dfill(3.,d)`: fill a distributed array with d.DT(3.)
- `dfill(3.,d;DT=Float32)`: fill a distributed array with Float32(3.)

"""
function dfill(x::Number,d::joPAsetup;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    X=DT(x)
    init=I->fill(X,map(length,I))
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

"""
    julia> dalloc(d; [DT])

Allocates a DistributedArrays.DArray, according to given distributor, without value assigment.

Use it to allocate quicker the array that will have all elements overwritten.

# Signature

    dalloc(d::joPAsetup;DT::DataType=d.DT)

# Arguments

- `d`: see help for joPAsetup
- `DT`: keyword argument to overwrite the type in joPAsetup

# Examples

- `dalloc(d)`: allocate an array
- `dalloc(d,DT=Float32)`: allocate array and overwite d.DT with Float32

"""
function dalloc(d::joPAsetup;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    init=I->Array{DT}(undef,map(length,I))
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end
#DArray(d::joPAsetup;DT::DataType=d.DT) = dalloc(d;DT=DT)

export dzeros
"""
    julia> dzeros(d; [DT])

Constructs a DistributedArrays.DArray, according to given distributor, filled with zeros.

# Signature

    dzeros(d::joPAsetup;DT::DataType=d.DT)

# Arguments

- `d`: see help for joPAsetup
- `DT`: keyword argument to overwrite the type in joPAsetup

# Examples

- `dzeros(d)`: allocate an array of zeros
- `dzeros(d,DT=Float32)`: allocate array of Float32 zeros

"""
function dzeros(d::joPAsetup;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    init=I->zeros(DT,map(length,I))
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

export dones
"""
    julia> dones(d; [DT])

Constructs a DistributedArrays.DArray, according to given distributor, filled with ones.

# Signature

    dones(d::joPAsetup;DT::DataType=d.DT)

# Arguments

- `d`: see help for joPAsetup
- `DT`: keyword argument to overwrite the type in joPAsetup

# Examples

- `dones(d)`: allocate an array of ones
- `dones(d,DT=Float32)`: allocate array of Float32 ones

"""
function dones(d::joPAsetup;DT::DataType=d.DT)
    id=DistributedArrays.next_did()
    init=I->ones(DT,map(length,I))
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

export drand
"""
    julia> drand(d; [DT], [RNG])

Constructs a DistributedArrays.DArray, according to given distributor, filled using built-in rand.

# Signature

    drand(d::joPAsetup;DT::DataType=d.DT,RNG::AbstractRNG=RandomDevice())

# Arguments

- `d`: see help for joPAsetup
- `DT`: keyword argument to overwrite the type in joPAsetup
- `RNG`: random-number generator function (see help for rand/randn)

# Examples

- `drand(d)`: allocate an array with rand
- `drand(d,DT=Float32)`: allocate array with rand of Float32
- `drand(d,DT=Float32,RNG=MersenneTwister(1234))`: allocate array with rand of Float32 using MersenneTwister() random device

"""
function drand(d::joPAsetup;DT::DataType=d.DT,RNG::AbstractRNG=RandomDevice())
    id=DistributedArrays.next_did()
    init=I->rand(RNG,DT,map(length,I))
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

export drandn
"""
    julia> drandn(d; [DT], [RNG])

Constructs a DistributedArrays.DArray, according to given distributor, filled using built-in randn.

# Signature

    drandn(d::joPAsetup;DT::DataType=d.DT,RNG::AbstractRNG=RandomDevice())

# Arguments

- `d`: see help for joPAsetup
- `DT`: keyword argument to overwrite the type in joPAsetup
- `RNG`: random-number generator function (see help for rand/randn)

# Notes

- only float type are supported by randn (see help for randn)

# Examples

- `drandn(d)`: allocate an array with randn
- `drandn(d,DT=Float32)`: allocate array with randn of Float32
- `drandn(d,DT=Float32,RNG=MersenneTwister(1234))`: allocate array with randn of Float32 using MersenneTwister() random device

"""
function drandn(d::joPAsetup;DT::DataType=d.DT,RNG::AbstractRNG=RandomDevice())
    DT<:Integer && @warn "Cannot use Integer type in randn.\n\t Overwite joPAsetup's type using DT keyword\n\t or create Float joPAsetup.\n\t Falling back to joFloat!" key="JOLI:drandn:Integer" maxlog=1
    DT= (DT<:Integer) ? joFloat : DT
    id=DistributedArrays.next_did()
    init=I->randn(RNG,DT,map(length,I))
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

export distribute
"""
    julia> distribute(A,d)

Distributes DArray according to given joPAsetup.

# Signature

    distribute(a::AbstractArray,d::joPAsetup)

# Arguments

- `A`: array to ditribute
- `d`: see help for joPAsetup

# Notes

- the type in joPAsetup is ignored here
- distributes over last non-singleton (worker-wise) dimension
- one of the dimensions must be large enough to hold at least one element on each worker

# Examples

- `distribute(A,d)`: distribute A using given distributor
- `distribute(A,joPAsetup(size(A)...))`: distribute A using default distributor settings

"""
function distribute(A::AbstractArray,d::joPAsetup)
    size(A)==d.dims || throw(joPAsetupException("joPAsetup: array size does not match dims of joPAsetup"))
    id=DistributedArrays.next_did()
    s = DistributedArrays.verified_destination_serializer(reshape(d.procs, size(d.idxs)), size(d.idxs)) do pididx
        A[d.idxs[pididx]...]
    end
    init = I->DistributedArrays.localpart(s)
    procs = reshape(d.procs, ntuple(i->d.chunks[i], length(d.chunks)))
    return DArray(id, init, d.dims, procs, d.idxs, d.cuts)
end

