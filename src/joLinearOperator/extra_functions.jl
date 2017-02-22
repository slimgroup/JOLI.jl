############################################################
## joLinearOperator - extra functions

# double(jo)
double{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) = A*eye(DDT,A.n)

# iscomplex(jo)
iscomplex{EDT,DDT,RDT}(A :: joAbstractLinearOperator{EDT,DDT,RDT}) = !(EDT <: Real)

# isinvertible(jo)
isinvertible{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT}) = !isnull(A.iop)

# islinear(jo) # fix,DDT,RDT
function islinear{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT};tol::Number=joTol,verbose::Bool=false)
    x=rand(DDT,A.n)
    y=rand(DDT,A.n)
    Axy=A*(x+y)
    AxAy=(A*x+A*y)
    dif=vecnorm(Axy-AxAy)
    test=(dif < tol)
    if verbose println("Linear test passed ($test) with tol=$tol: / diff=$dif") end
    return test,dif
end
function islinear{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT},nDDT::DataType;tol::Number=joTol,verbose::Bool=false)
    x=rand(nDDT,A.n)
    y=rand(nDDT,A.n)
    Axy=A*(x+y)
    AxAy=(A*x+A*y)
    dif=vecnorm(Axy-AxAy)
    test=(dif < tol)
    if verbose println("Linear test passed ($test) with tol=$tol: / diff=$dif") end
    return test,dif
end

# isadjoint(jo) # fix,DDT,RDT
function isadjoint{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT};tol::Float64=0.,ctmult::Number=1.,verbose::Bool=false)
    x=rand(DDT,A.n)
    y=A*rand(DDT,A.n)
    Axy=dot(A*x,y)
    xAty=dot(x,convert(EDT,ctmult)*A'*y)
    dif=abs(xAty-Axy)
    rto=abs(xAty/Axy)
    rer=abs(dif/xAty)
    mytol=(tol>0 ? tol : sqrt(eps(max(abs(Axy),abs(xAty)))))
    test=(dif < mytol)
    if verbose println("Adjoint test passed ($test) with tol=$mytol: \n diff=   $dif \n relerr= $rer \n ratio=  $rto") end
    return test,dif,rer,rto
end
function isadjoint{EDT,DDT,RDT}(A::joAbstractLinearOperator{EDT,DDT,RDT},nDDT::DataType;tol::Float64=0.,ctmult::Number=1.,verbose::Bool=false)
    x=rand(nDDT,A.n)
    y=A*rand(nDDT,A.n)
    Axy=dot(A*x,y)
    xAty=dot(x,convert(EDT,ctmult)*A'*y)
    dif=abs(xAty-Axy)
    rto=abs(xAty/Axy)
    mytol=(tol>0 ? tol : sqrt(eps(max(abs(Axy),abs(xAty)))))
    test=(dif < mytol)
    rer=abs(dif/xAty)
    if verbose println("Adjoint test passed ($test) with tol=$mytol: \n diff=   $dif \n relerr= $rer \n ratio=  $rto") end
    return test,dif,rer,rto
end

