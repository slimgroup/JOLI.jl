############################################################
## joLinearOperator - extra functions

# double(jo)
double{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) = A*eye(DDT,A.n)

# iscomplex(jo)
iscomplex{EDT,DDT,RDT}(A :: joAbstractLinearOperator{EDT,DDT,RDT}) = !(EDT <: Real)

# isinvertible(jo)
isinvertible{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) = !isnull(A.iop)

# islinear(jo) # fix,DDT,RDT
function islinear{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT};tol::Float64=0.,verbose::Bool=false)
    x=rand(DDT,A.n)
    y=rand(DDT,A.n)
    Axy=A*(x+y)
    AxAy=(A*x+A*y)
    dif=vecnorm(Axy-AxAy)
    rto=abs(vecnorm(AxAy)/vecnorm(Axy))
    rer=abs(dif/vecnorm(Axy))
    mytol=(tol>0 ? tol : sqrt(max(eps(vecnorm(Axy)),eps(vecnorm(AxAy)))))
    test=(dif < mytol)
    if verbose println("Linear test passed ($test) with tol=$mytol: \n diff=   $dif \n relerr= $rer \n ratio=  $rto") end
    return test,mytol,dif,rer,rto
end

# isadjoint(jo) # fix,DDT,RDT
function isadjoint{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT};tol::Float64=0.,ctmult::Number=1.,verbose::Bool=false)
    x=rand(DDT,A.n)
    y=A*rand(DDT,A.n)
    Axy=dot(A*x,y)
    xAty=dot(x,convert(DDT,ctmult)*(A'*y))
    dif=abs(xAty-Axy)
    rto=abs(xAty/Axy)
    rer=abs(dif/Axy)
    mytol=(tol>0 ? tol : sqrt(max(eps(abs(Axy)),eps(abs(xAty)))))
    test=(dif < mytol)
    if verbose println("Adjoint test passed ($test) with tol=$mytol: \n diff=   $dif \n relerr= $rer \n ratio=  $rto") end
    return test,mytol,dif,rer,rto
end
