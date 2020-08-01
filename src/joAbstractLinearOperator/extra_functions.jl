############################################################
## joAbstractLinearOperator - extra functions

# elements(jo)
elements(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = joHelpers_etc.elements_helper(A)
elements(A::joMatrix{DDT,RDT}) where {DDT,RDT} = A*jo_speye(DDT,A.n)

# hasinverse(jo)
hasinverse(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = !isnull(A.iop)

# issquare(jo)
issquare(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = (A.m == A.n)

# istall(jo)
istall(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = (A.m > A.n)

# iswide(jo)
iswide(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = (A.m < A.n)

# iscomplex(jo)
iscomplex(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = !(DDT<:Real && RDT<:Real)

# iscomplex(jo)
iscomplex_b(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = !(DDT<:Real && RDT<:Real)


"""
    normest(jo;numiters, tol)
Approximate spectral norm (largest singular value) through power iterations. For small matrices a single iteration 
should be enough. 
"""

function normest(A::joAbstractLinearOperator{DDT,RDT};numiters::Integer=5,tol::Float64=0.,verbose::Bool=false) where {DDT,RDT}   

    spec_norm_aprox = 0

    u_hat = DDT<:Real ? jo_convert(DDT,randn(A.m)) : jo_convert(DDT,complex.(randn(A.m),randn(A.m)))
    u_hat  = u_hat / norm(u_hat,2)
    v_hat  = deepcopy(u_hat)
    for i=1:numiters
        result_u = A'*u_hat
        v_hat    = result_u / norm(result_u,2)
      
        result_v = A*v_hat
        u_hat    = result_v / norm(result_v,2)

        spec_norm_aprox = u_hat'*(A*v_hat)
    end
    return spec_norm_aprox
end

"""
    isposdef(jo; semi=false)

approximate check that the operator is positive definite or positive semidefinite. 
"""

function isposdef(A::joAbstractLinearOperator{DDT,RDT},samples::Integer=3;tol::Float64=0.,semi::Bool=false,verbose::Bool=false) where {DDT,RDT}   
    if !(issquare(A)) 
        println("Matrix needs to be square for PD/PSD test")
        return false
    end

    Test=true
    TEST=Array{Bool,1}(undef,0)
    for s=1:samples
        x= DDT<:Real ? jo_convert(DDT,randn(A.n)) : jo_convert(DDT,complex.(randn(A.n),randn(A.n)))
        Ax =A*x
        xAx=x'*Ax #do I need to call dot()?

        #Result must be real so 
        #imaginary part must be negligible
        ε = eps(real(DDT))
        if imag(xAx) > sqrt(ε) * abs(xAx) 
            test = false
            push!(TEST,test); 
            Test=Test&&test
            result = test ? "PASSED" : "FAILED"
            if verbose println("Positive definite test [$s] $result") end
            continue
        end

        #make sure that real part is larger than (or equal to) zero
        xAx_real = real(xAx)
        if semi  
            test=xAx_real ≥ 0; 
        else
            test=xAx_real > 0; 
        end
        
        push!(TEST,test); 
        Test=Test&&test

        result = test ? "PASSED" : "FAILED"
        if verbose println("Positive definite test [$s] $result") end
    end
    return Test,TEST
end

# islinear(jo)
function islinear(A::joAbstractLinearOperator{DDT,RDT},samples::Integer=3;tol::Float64=0.,verbose::Bool=false) where {DDT,RDT}
    Test=true
    TEST=Array{Bool,1}(undef,0)
    MYTOL=Array{Float64,1}(undef,0)
    DIF=Array{Float64,1}(undef,0)
    RER=Array{Float64,1}(undef,0)
    RTO=Array{Float64,1}(undef,0)
    for s=1:samples
        x= DDT<:Real ? jo_convert(DDT,randn(A.n)) : jo_convert(DDT,complex.(randn(A.n),randn(A.n)))
        y= DDT<:Real ? jo_convert(DDT,randn(A.n)) : jo_convert(DDT,complex.(randn(A.n),randn(A.n)))
        Axy=A*(x+y)
        AxAy=(A*x+A*y)
        dif=norm(Axy-AxAy); push!(DIF,dif)
        rer=abs(dif/norm(Axy)); push!(RER,rer)
        rto=abs(norm(AxAy)/norm(Axy)); push!(RTO,rto)
        mytol=(tol>0 ? tol : sqrt(max(eps(norm(Axy)),eps(norm(AxAy))))); push!(MYTOL,mytol)
        test=(dif < mytol); push!(TEST,test); Test=Test&&test
        result = test ? "PASSED" : "FAILED"
        if verbose println("Linear test [$s] $result with\n tol=    $mytol: \n diff=   $dif \n relerr= $rer \n ratio=  $rto") end
    end
    return Test,TEST,MYTOL,DIF,RER,RTO
end

# isadjoint(jo)
function isadjoint(A::joAbstractLinearOperator{DDT,RDT},samples::Integer=3;tol::Float64=0.,normfactor::Real=1.,userange::Bool=false,verbose::Bool=false) where {DDT,RDT}
    Test=true
    TEST=Array{Bool,1}(undef,0)
    MYTOL=Array{Float64,1}(undef,0)
    DIF=Array{Float64,1}(undef,0)
    RER=Array{Float64,1}(undef,0)
    RTO=Array{Float64,1}(undef,0)
    for s=1:samples
        if userange
            x= RDT<:Real ? jo_convert(RDT,randn(A.m)) : jo_convert(RDT,complex.(randn(A.m),randn(A.m)))
            y= RDT<:Real ? jo_convert(RDT,randn(A.m)) : jo_convert(RDT,complex.(randn(A.m),randn(A.m)))
            x=adjoint(A)*x
        else
            x= DDT<:Real ? jo_convert(DDT,randn(A.n)) : jo_convert(DDT,complex.(randn(A.n),randn(A.n)))
            y= DDT<:Real ? jo_convert(DDT,randn(A.n)) : jo_convert(DDT,complex.(randn(A.n),randn(A.n)))
            y=A*y
        end
        nfr=convert(RDT, normfactor)
        nfd=convert(DDT, normfactor)
        Axy=dot((A*x)/nfr,y)
        xAty=dot(x,(adjoint(A)*y)*nfd)
        dif=abs(xAty-Axy); push!(DIF,dif)
        rer=abs(dif/Axy); push!(RER,rer)
        rto=abs(xAty/Axy); push!(RTO,rto)
        mytol=(tol>0 ? tol : sqrt(max(eps(abs(Axy)),eps(abs(xAty))))); push!(MYTOL,mytol)
        test=(dif < mytol); push!(TEST,test); Test=Test&&test
        result = test ? "PASSED" : "FAILED"
        if verbose println("Adjoint test [$s] $result with\n tol=    $mytol: \n diff=   $dif \n relerr= $rer \n ratio=  $rto") end
    end
    return Test,TEST,MYTOL,DIF,RER,RTO
end

