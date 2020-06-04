using Distributed
using SharedArrays
using DistributedArrays

module SAtest
    using SharedArrays

    export SAsetup
    struct SAsetup
        name::String        # name for identification
        dims::Dims          # dimensions of the array
        procs::Vector{Int}  # ids of workers to use
        DT::DataType        # DataType
    end

    export SAoperator
    struct SAoperator
        dst::SAsetup
    end

    export salloc
    function salloc(d::SAsetup;DT::DataType=d.DT)
        S = SharedArray{DT}(d.dims, pids=d.procs)
        #S = SharedArray{DT}(d.dims)
        return S
    end
end
using .SAtest

nm="test"
sz=(100,100)
wk=workers()
dt=Float64

dst=SAsetup(nm,sz,wk,dt)
op=SAoperator(dst)

for i=1:100
    a=salloc(op.dst);
    b=salloc(op.dst);
    c=a+b
    @assert sz==dst.dims "sz gone at $i"
    @assert wk==dst.procs "wk gone at $i"
end

nothing
