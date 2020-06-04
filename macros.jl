workspace()
using JOLI

a=x->x
b(x)=x
println(a(1))
println((@NF , @NF()))
println("1:",@NF Nullable{Function}(a->a))
println("2:",@NF(Nullable{Function}(a->a)))
println("3:",@NF x->b(x))
println("4:",@NF(x->b(x)))
