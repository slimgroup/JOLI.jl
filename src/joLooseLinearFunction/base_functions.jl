############################################################
## joLooseLinearFunction - overloaded Base functions

# eltype(jo)

# deltype(jo)

# reltype(jo)

# show(jo)

# display(jo)

# size(jo)

# size(jo,1/2)

# length(jo)

# jo_full(jo)

# norm(jo)

# real(jo)

# imag(jo)

# conj(jo)
conj(A::joLooseLinearFunction{DDT,RDT}) where {DDT,RDT} =
    joLooseLinearFunction{DDT,RDT}("conj("*A.name*")",A.m,A.n,
        get(A.fop_C),
        A.fop_A,
        A.fop_T,
        A.fop,
        A.fMVok,
        A.iop_C,
        A.iop_A,
        A.iop_T,
        A.iop,
        A.iMVok
        )

# transpose(jo)
transpose(A::joLooseLinearFunction{DDT,RDT}) where {DDT,RDT} =
    joLooseLinearFunction{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
        get(A.fop_T),
        A.fop,
        A.fop_C,
        A.fop_A,
        A.fMVok,
        A.iop_T,
        A.iop,
        A.iop_C,
        A.iop_A,
        A.iMVok
        )

# adjoint(jo)
adjoint(A::joLooseLinearFunction{DDT,RDT}) where {DDT,RDT} =
    joLooseLinearFunction{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
        get(A.fop_A),
        A.fop_C,
        A.fop,
        A.fop_T,
        A.fMVok,
        A.iop_A,
        A.iop_C,
        A.iop,
        A.iop_T,
        A.iMVok
        )

# isreal(jo)

# issymmetric(jo)

# ishermitian(jo)

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)

# *(jo,mvec)
function *(A::joLooseLinearFunction{ADDT,ARDT},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joLooseLinearFunction("shape mismatch"))
    if A.fMVok
        MV=A.fop(mv)
    else
        MV=Matrix{ARDT}(undef,A.m,size(mv,2))
        for i=1:size(mv,2)
            V=A.fop(mv[:,i])
            MV[:,i]=V
        end
    end
    return MV
end

# *(mvec,jo)

# *(jo,vec)
function *(A::joLooseLinearFunction{ADDT,ARDT},v::LocalVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joLooseLinearFunctionException("shape mismatch"))
    V=A.fop(v)
    return V
end

# *(vec,jo)

# *(num,jo)

# *(jo,num)

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)

# \(jo,mvec)
function \(A::joLooseLinearFunction{ADDT,ARDT},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.m == size(mv,1) || throw(joLooseLinearFunctionException("shape mismatch"))
    if hasinverse(A)
        if A.iMVok
            MV = get(A.iop)(mv)
        else
            MV=Matrix{ADDT}(undef,A.n,size(mv,2))
            for i=1:size(mv,2)
                V=get(A.iop)(mv[:,i])
                MV[:,i]=V
            end
        end
    elseif issquare(A)
        MV=Matrix{ADDT}(undef,A.n,size(mv,2))
        for i=1:size(mv,2)
            V=jo_convert(ADDT,jo_iterative_solver4square(A,mv[:,i]))
            MV[:,i]=V
        end
    elseif (istall(A) && !isnull(jo_iterative_solver4tall))
        MV=Matrix{ADDT}(undef,A.n,size(mv,2))
        for i=1:size(mv,2)
            V=jo_convert(ADDT,jo_iterative_solver4tall(A,mv[:,i]))
            MV[:,i]=V
        end
    elseif (iswide(A) && !isnull(jo_iterative_solver4wide))
        MV=Matrix{ADDT}(undef,A.n,size(mv,2))
        for i=1:size(mv,2)
            V=jo_convert(ADDT,jo_iterative_solver4wide(A,mv[:,i]))
            MV[:,i]=V
        end
    else
        throw(joLooseLinearFunctionException("\\(jo,MultiVector) not supplied"))
    end
    return MV
end

# \(mvec,jo)

# \(jo,vec)
function \(A::joLooseLinearFunction{ADDT,ARDT},v::LocalVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.m == size(v,1) || throw(joLooseLinearFunctionException("shape mismatch"))
    if hasinverse(A)
        V=get(A.iop)(v)
    elseif issquare(A)
        V=jo_convert(ADDT,jo_iterative_solver4square(A,v))
    elseif (istall(A) && !isnull(jo_iterative_solver4tall))
        V=jo_convert(ADDT,jo_iterative_solver4tall(A,v))
    elseif (iswide(A) && !isnull(jo_iterative_solver4wide))
        V=jo_convert(ADDT,jo_iterative_solver4wide(A,v))
    else
        throw(joLooseLinearFunctionException("\\(jo,Vector) not supplied"))
    end
    return V
end

# \(vec,jo)

# \(num,jo)

# \(jo,num)

############################################################
## overloaded Base +(...jo...)

# +(jo)

# +(jo,jo)

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)

# +(num,jo)

############################################################
## overloaded Base -(...jo...)

# -(jo)
-(A::joLooseLinearFunction{DDT,RDT}) where {DDT,RDT} =
    joLooseLinearFunction{DDT,RDT}("(-"*A.name*")",A.m,A.n,
        v1->-A.fop(v1),
        v2->-get(A.fop_T)(v2),
        v3->-get(A.fop_A)(v3),
        v4->-get(A.fop_C)(v4),
        A.fMVok,
        v5->-get(A.iop)(v5),
        v6->-get(A.iop_T)(v6),
        v7->-get(A.iop_A)(v7),
        v8->-get(A.iop_C)(v8),
        A.iMVok
        )

# -(jo,jo)

# -(jo,mvec)

# -(mvec,jo)

# -(jo,vec)

# -(vec,jo)

# -(jo,num)

# -(num,jo)

############################################################
## overloaded Base .*(...jo...)

############################################################
## overloaded Base .\(...jo...)

############################################################
## overloaded Base .+(...jo...)

############################################################
## overloaded Base .-(...jo...)

############################################################
## overloaded Base block methods

# hcat(...jo...)

# vcat(...jo...)

# hvcat(...jo...)

############################################################
## overloaded LinearAlgebra functions

# mul!(...,jo,...)
mul!(y::LocalVector{YDT},A::joLooseLinearFunction{DDT,RDT},x::LocalVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:] = A * x
mul!(y::LocalMatrix{YDT},A::joLooseLinearFunction{DDT,RDT},x::LocalMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:,:] = A * x

# ldiv!(...,jo,...)
ldiv!(y::LocalVector{YDT},A::joLooseLinearFunction{DDT,RDT},x::LocalVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:] = A \ x
ldiv!(y::LocalMatrix{YDT},A::joLooseLinearFunction{DDT,RDT},x::LocalMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:,:] = A \ x

