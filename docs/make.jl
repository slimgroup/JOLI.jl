using Documenter, JOLI

makedocs(
    sitename = "JOLI Reference",
    modules = [JOLI]
)

deploydocs(
    repo = "github.com/slimgroup/JOLI.jl.git"
)
