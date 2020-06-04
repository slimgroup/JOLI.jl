workspace()
unshift!(LOAD_PATH,pwd())
macro JOLIreload()
#    return :(include("juliarc.jl"))
    return :(reload("JOLI"))
end
macro JOLItest()
    return :(Pkg.test("JOLI"))
end
#using LinearOperators
using Base.Test
using BenchmarkTools
using DistributedArrays
using JOLI
