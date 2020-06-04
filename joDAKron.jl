using Distributed
@everywhere using Distributed
@everywhere using SparseArrays
@everywhere using DistributedArrays
@everywhere using DistributedArrays.SPMD
@everywhere using LinearAlgebra
@everywhere using JOLI

import JOLI.joDAdistributedLinOp, JOLI.joDAutils, JOLI.LocalMatrix
import Base.*, Base.ReshapedArray

d=dzeros(4,5)
r=reshape(d,20)

@info "types" typeof(d) typeof(r)
    @info typeof(r)<:Base.ReshapedArray{Float64,1,DA} where DA<:DArray
    @info typeof(r)<:Base.ReshapedArray{Float64,1,DA} where DA<:DArray{Float64}
    @info typeof(r)<:Base.ReshapedArray{Float64,1,DA} where DA<:DArray{Float64,2}

    @info typeof(r)<:Base.ReshapedArray{Float64,1,DA} where DA<:DArray{Float64,1}
    @info typeof(r)<:Base.ReshapedArray{Float64,2,DA} where DA<:DArray{Float64,1}

# constructors
# *(jo,jo)



# *(jo,mvec)

println("....................")
println("workers: $(nworkers()) / $(workers())")

#@assert false "controlled stop:)"
