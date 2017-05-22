############################################################
## joLinearOperator - extra functions
# commons methods class for jo[Abstract]LinearOperator

# elements(jo)
elements{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT}) = A*eye(DDT,A.n)

# iscomplex(jo)
iscomplex{DDT,RDT}(A :: joAbstractLinearOperator{DDT,RDT}) = !(DDT<:Real && RDT<:Real)

# isinvertible(jo)
isinvertible{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT}) = !isnull(A.iop)

# islinear(jo)
function islinear{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT};tol::Float64=0.,verbose::Bool=false)
    x= DDT<:Real ? jo_convert(DDT,randn(A.n)) : jo_convert(DDT,complex(randn(A.n),randn(A.n)))
    y= DDT<:Real ? jo_convert(DDT,randn(A.n)) : jo_convert(DDT,complex(randn(A.n),randn(A.n)))
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

# isadjoint(jo)
function isadjoint{DDT,RDT}(A::joAbstractLinearOperator{DDT,RDT};tol::Float64=0.,normfactor::Real=1.,userange::Bool=false,verbose::Bool=false)
    if userange
        x= RDT<:Real ? jo_convert(RDT,randn(A.m)) : jo_convert(RDT,complex(randn(A.m),randn(A.m)))
        y= RDT<:Real ? jo_convert(RDT,randn(A.m)) : jo_convert(RDT,complex(randn(A.m),randn(A.m)))
        x=A'*x
    else
        x= DDT<:Real ? jo_convert(DDT,randn(A.n)) : jo_convert(DDT,complex(randn(A.n),randn(A.n)))
        y= DDT<:Real ? jo_convert(DDT,randn(A.n)) : jo_convert(DDT,complex(randn(A.n),randn(A.n)))
        y=A*y
    end
    nfr=convert(RDT,normfactor)
    nfd=convert(DDT,normfactor)
    Axy=dot((A*x)/nfr,y)
    xAty=dot(x,(A'*y)*nfd)
    dif=abs(xAty-Axy)
    rto=abs(xAty/Axy)
    rer=abs(dif/Axy)
    mytol=(tol>0 ? tol : sqrt(max(eps(abs(Axy)),eps(abs(xAty)))))
    test=(dif < mytol)
    if verbose println("Adjoint test passed ($test) with tol=$mytol: \n diff=   $dif \n relerr= $rer \n ratio=  $rto") end
    return test,mytol,dif,rer,rto
end

