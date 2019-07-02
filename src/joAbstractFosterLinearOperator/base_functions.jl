############################################################
## joAbstractFosterLinearOperator - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractFosterLinearOperator{DDT,RDT}) where {DDT,RDT} = promote_type(DDT,RDT)

# deltype(jo)
deltype(A::joAbstractFosterLinearOperator{DDT,RDT}) where {DDT,RDT} = DDT

# reltype(jo)
reltype(A::joAbstractFosterLinearOperator{DDT,RDT}) where {DDT,RDT} = RDT

# show(jo)
show(A::joAbstractFosterLinearOperator) = println((typeof(A),A.name,(A.m,A.n)))

# display(jo)
display(A::joAbstractFosterLinearOperator) = show(A)

# size(jo)
size(A::joAbstractFosterLinearOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joAbstractFosterLinearOperator,ind::Integer)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	else
		throw(joAbstractFosterLinearOperatorException("invalid index"))
	end
end

# length(jo)
length(A::joAbstractFosterLinearOperator) = A.m*A.n

# jo_full(jo)

# norm(jo)

# real(jo)

# imag(jo)

# conj(jo)
conj(A::joLooseMatrix{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrix{DDT,RDT}("conj("*A.name*")",A.m,A.n,
        A.fop_C, A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop
        )
conj(A::joLooseLinearFunction{DDT,RDT}) where {DDT,RDT} =
    joLooseLinearFunction{DDT,RDT}("conj("*A.name*")",A.m,A.n,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop, A.fMVok,
        A.iop_C, A.iop_A, A.iop_T, A.iop, A.iMVok
        )

# transpose(jo)
transpose(A::joLooseMatrix{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrix{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
        A.fop_T, A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A
        )
transpose(A::joLooseLinearFunction{DDT,RDT}) where {DDT,RDT} =
    joLooseLinearFunction{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A, A.fMVok,
        A.iop_T, A.iop, A.iop_C, A.iop_A, A.iMVok
        )

# adjoint(jo)
adjoint(A::joLooseMatrix{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrix{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
        A.fop_A, A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T
        )
adjoint(A::joLooseLinearFunction{DDT,RDT}) where {DDT,RDT} =
    joLooseLinearFunction{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T, A.fMVok,
        A.iop_A, A.iop_C, A.iop, A.iop_T, A.iMVok
        )

# isreal(jo)
isreal(A :: joAbstractFosterLinearOperator{DDT,RDT}) where {DDT,RDT} = (DDT<:Real && RDT<:Real)

# issymmetric(jo)

# ishermitian(jo)

# getindex(jo,...)
getindex(A::joAbstractFosterLinearOperator{DDT,RDT},::Colon,i::Integer) where {DDT,RDT} =
    joHelpers_etc.elements_column_helper(A,i)
getindex(A::joAbstractFosterLinearOperator{DDT,RDT},::Colon,r::UnitRange{URT}) where {DDT,RDT,URT<:Integer}  =
    joHelpers_etc.elements_column_helper(A,r)

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)

# *(jo,mvec)
function *(A::joLooseMatrix{ADDT,ARDT},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joLooseMatrixException("shape mismatch"))
    MV = A.fop(mv)
    return MV
end
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
function *(A::joLooseMatrix{ADDT,ARDT},v::LocalVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joLooseMatrixException("shape mismatch"))
    V=A.fop(v)
    return V
end
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
function \(A::joLooseMatrix{ADDT,ARDT},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.m == size(mv,1) || throw(joLooseMatrixException("shape mismatch"))
    if hasinverse(A)
        MV=get(A.iop)(mv)
    else
        throw(joLooseMatrixException("\\(jo,Vector) not supplied"))
    end
    return MV
end
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
function \(A::joLooseMatrix{ADDT,ARDT},v::LocalVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.m == size(v,1) || throw(joLooseMatrixException("shape mismatch"))
    if hasinverse(A)
        V=get(A.iop)(v)
    else
        throw(joLooseMatrixException("\\(jo,Vector) not supplied"))
    end
    return V
end
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
-(A::joLooseMatrix{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrix{DDT,RDT}("(-"*A.name*")",A.m,A.n,
        v1->-A.fop(v1),
        v2->-A.fop_T(v2),
        v3->-A.fop_A(v3),
        v4->-A.fop_C(v4),
        v5->-get(A.iop)(v5),
        v6->-get(A.iop_T)(v6),
        v7->-get(A.iop_A)(v7),
        v8->-get(A.iop_C)(v8)
        )
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

# .*(num,jo)
Base.Broadcast.broadcasted(::typeof(*),a::Number,A::joAbstractFosterLinearOperator) = a*A
Base.Broadcast.broadcasted(::typeof(*),a::joNumber,A::joAbstractFosterLinearOperator) = a*A

# .*(jo,num)
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractFosterLinearOperator,a::Number) = a*A
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractFosterLinearOperator,a::joNumber) = a*A

############################################################
## overloaded Base .\(...jo...)

############################################################
## overloaded Base .+(...jo...)

# .+(jo,num)
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractFosterLinearOperator,b::Number) = A+b
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractFosterLinearOperator,b::joNumber) = A+b

# .+(num,jo)
Base.Broadcast.broadcasted(::typeof(+),b::Number,A::joAbstractFosterLinearOperator) = A+b
Base.Broadcast.broadcasted(::typeof(+),b::joNumber,A::joAbstractFosterLinearOperator) = A+b

############################################################
## overloaded Base .-(...jo...)

# .-(jo,num)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractFosterLinearOperator,b::Number) = A+(-b)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractFosterLinearOperator,b::joNumber) = A+(-b)

# .-(num,jo)
Base.Broadcast.broadcasted(::typeof(-),b::Number,A::joAbstractFosterLinearOperator) = -A+b
Base.Broadcast.broadcasted(::typeof(-),b::joNumber,A::joAbstractFosterLinearOperator) = -A+b

############################################################
## overloaded Base block methods

# hcat(...jo...)

# vcat(...jo...)

# hvcat(...jo...)

############################################################
## overloaded LinearAlgebra functions

# mul!(...,jo,...)
mul!(y::LocalVector{YDT},A::joLooseMatrix{DDT,RDT},x::LocalVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:] = A * x
mul!(y::LocalMatrix{YDT},A::joLooseMatrix{DDT,RDT},x::LocalMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:,:] = A * x
mul!(y::LocalVector{YDT},A::joLooseLinearFunction{DDT,RDT},x::LocalVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:] = A * x
mul!(y::LocalMatrix{YDT},A::joLooseLinearFunction{DDT,RDT},x::LocalMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:,:] = A * x

# ldiv!(...,jo,...)
ldiv!(y::LocalVector{YDT},A::joLooseMatrix{DDT,RDT},x::LocalVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:] = A \ x
ldiv!(y::LocalMatrix{YDT},A::joLooseMatrix{DDT,RDT},x::LocalMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:,:] = A \ x
ldiv!(y::LocalVector{YDT},A::joLooseLinearFunction{DDT,RDT},x::LocalVector{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:] = A \ x
ldiv!(y::LocalMatrix{YDT},A::joLooseLinearFunction{DDT,RDT},x::LocalMatrix{XDT}) where {DDT,RDT,YDT<:Number,XDT<:Number} = y[:,:] = A \ x

