using Flux

x = rand(Float32, 3)

W = randn(Float32, 3, 3)
W_JOLI = joMatrix(W)

g = gradient(x -> sum(W*x), x)[1]
g_JOLI = gradient(x -> sum(W_JOLI*x), x)[1]

@test isapprox(sum((g - g_JOLI).^2)/sum(g_JOLI.^2), 0f0; atol=1f-8)
