Ok we were happy a bit too early. Again. This code works
```using JOLI

A = joGaussian(10,10)

W = rand(2, 10)
b  = rand(2)

using Flux

predict(x) = W*(A*x) .+ b

x, y = randn(10), randn(2)

loss(x,y) = Flux.mse(predict(x), y)

using Flux.Tracker

W = param(W)
b = param(b)

gs = Tracker.gradient(() -> loss(x, y), params(W, b))

gs[W]```


But this one does not
```using JOLI
using Flux

A = joGaussian(10,100)

m = Conv((3, 3), 1=>1, pad=1, stride=1);

x = randn(10,10,1,1);

A*vec(m(x).data)

A*vec(m(x))```

# https://fluxml.ai/Flux.jl/stable/internals/tracker/
