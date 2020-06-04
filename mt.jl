function test(a,v)
    a*v
end

a=rand(10000,10000)
v=rand(10000)
test(a,v)
#println(Threads.nthreads())
for t=1:20
    BLAS.set_num_threads(t)
    tic()
    #Threads.@threads for i=1:100
    for i=1:100
        b=test(a,v)
    end
    println((t,toc()))
end
