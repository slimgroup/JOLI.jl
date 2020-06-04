tic()
n1=96
n2=96
nbscales=3 #3 max(1,ceil(log2(min(m,n)) - 3))
nbangles_coarse=8 #16
all_crvlts=1 #0
real_crvlts=1 #1
zero_finest=0 #0
cfmap_size=ccall((:jl_fdct_sizes_map_size,:libdfdct_wrapping),Int32,(Cint,Cint,Cint),nbscales,nbangles_coarse,all_crvlts)
#cfmap=Array{Int32}(cfmap_size)
cfmap=zeros(Int32,cfmap_size)
totalcoeffs=Ref{Csize_t}(0)
ccall((:jl_fdct_sizes,:libdfdct_wrapping),Void,(Cint,Cint,Cint,Cint,Cint,Ptr{Array{Cint}},Ref{Csize_t}),nbscales,nbangles_coarse,all_crvlts,n1,n2,cfmap,totalcoeffs)
println(cfmap_size)
totalcoeffs=convert(Int128,totalcoeffs[])
println(totalcoeffs)
display(cfmap')
println()

println("##### X")
rX=[sin(x) for x in 1:n1*n2]
iX=[cos(x) for x in 1:n1*n2]
if real_crvlts==1
    X=rX
else
    X=rX+im*iX
end
display(X[1:1000:n1*n2])
println()
println((typeof(X)))
println("X before: ",norm(X))

println("##### FORWARD")
if real_crvlts==1
    C=zeros(Float64,totalcoeffs)
else
    C=zeros(Complex{Float64},totalcoeffs)
end
println(typeof(C))

if real_crvlts==1
    ccall((:jl_fdct_wrapping_real,:libdfdct_wrapping),Void,(Cint,Cint,Cint,Cint,Cint,Cint,Cint,Csize_t,Ptr{Array{Complex{Float64}}},Ptr{Array{Complex{Float64}}}),n1,n2,nbscales,nbangles_coarse,all_crvlts,real_crvlts,zero_finest,totalcoeffs,X,C)
else
    ccall((:jl_fdct_wrapping_cpx,:libdfdct_wrapping),Void,(Cint,Cint,Cint,Cint,Cint,Cint,Cint,Csize_t,Ptr{Array{Complex{Float64}}},Ptr{Array{Complex{Float64}}}),n1,n2,nbscales,nbangles_coarse,all_crvlts,real_crvlts,zero_finest,totalcoeffs,X,C)
end

println("##### C")
display(C[1:5])
println()
display(C[(totalcoeffs-5):totalcoeffs])
println()
println("C after ",norm(C))

println("##### INVERSE")
rXo=zeros(Float64,n1*n2)
iXo=zeros(Float64,n1*n2)
Xo=zeros(X)
println(size(Xo),norm(Xo))

if real_crvlts==1
    ccall((:jl_ifdct_wrapping_real,:libdfdct_wrapping),Void,(Cint,Cint,Cint,Cint,Cint,Cint,Cint,Csize_t,Ptr{Array{Complex{Float64}}},Ptr{Array{Complex{Float64}}}),n1,n2,nbscales,nbangles_coarse,all_crvlts,real_crvlts,zero_finest,totalcoeffs,C,Xo)
else
    ccall((:jl_ifdct_wrapping_cpx,:libdfdct_wrapping),Void,(Cint,Cint,Cint,Cint,Cint,Cint,Cint,Csize_t,Ptr{Array{Complex{Float64}}},Ptr{Array{Complex{Float64}}}),n1,n2,nbscales,nbangles_coarse,all_crvlts,real_crvlts,zero_finest,totalcoeffs,C,Xo)
end

println("##### Xo")
display(Xo[1:1000:n1*n2])
println()
println("Xo after: ",norm(Xo))
println("X-Xo: ",norm(X-Xo))
toc()
