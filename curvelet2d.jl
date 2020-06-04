workspace()
using JOLI
jo_type_mismatch_error_set(false)

T=8
for t=1:T # start test loop
    m=32*t
    Awr=joCurvelet2D(m,m)
    Awc=joCurvelet2D(m,m;real_crvlts=false)
    Acr=joCurvelet2D(m,m;all_crvlts=true)
    Acc=joCurvelet2D(m,m;all_crvlts=true,real_crvlts=false)

    println("($m,$m)")
    isadjoint(Awr;verbose=true)
    isadjoint(Awc;verbose=true)
    isadjoint(Acr;verbose=true)
    isadjoint(Acc;verbose=true)
    
end # end test loop
