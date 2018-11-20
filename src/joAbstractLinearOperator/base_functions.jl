############################################################
## joAbstractLinearOperator(s) - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = promote_type(DDT,RDT)

# deltype(jo)
deltype(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = DDT

# reltype(jo)
reltype(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = RDT

# show(jo)
show(A::joAbstractLinearOperator) = println((typeof(A),A.name,A.m,A.n))

# display(jo)
display(A::joAbstractLinearOperator) = show(A)

# size(jo)
size(A::joAbstractLinearOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joAbstractLinearOperator,ind::Integer)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	else
		throw(joAbstractLinearOperatorException("invalid index"))
	end
end

# length(jo)
length(A::joAbstractLinearOperator) = A.m*A.n

# jo_full(jo)
jo_full(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = A*jo_eye(DDT,A.n)

# norm(jo)
norm(A::joAbstractLinearOperator,p::Real=2) = norm(elements(A),p)

# real(jo)
#real{DDT<:Real,RDT<:Real}(A::joAbstractLinearOperator{DDT,RDT}) = A
function real(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT}
    throw(joAbstractLinearOperatorException("real(jo) not implemented"))
end
joReal(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = real(A)

# imag(jo)
#imag{DDT<:Real,RDT<:Real}(A::joAbstractLinearOperator{DDT,RDT}) = joZeros(A.m,A.n,DDT,RDT)
function imag(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT}
    throw(joAbstractLinearOperatorException("imag(jo) not implemented"))
end
joImag(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = imag(A)

# conj(jo)
joConj(A::joAbstractLinearOperator) = conj(A)
conj(A::joLinearOperator{DDT,RDT}) where {DDT,RDT} =
    joLinearOperator{DDT,RDT}("conj("*A.name*")",A.m,A.n,
        get(A.fop_C),
        A.fop_A,
        A.fop_T,
        A.fop,
        A.iop_C,
        A.iop_A,
        A.iop_T,
        A.iop
        )
conj(A::joMatrix{DDT,RDT}) where {DDT,RDT} =
    joMatrix{DDT,RDT}("conj("*A.name*")",A.m,A.n,
        A.fop_C,
        A.fop_A,
        A.fop_T,
        A.fop,
        A.iop_C,
        A.iop_A,
        A.iop_T,
        A.iop
        )
conj(A::joLinearFunction{DDT,RDT}) where {DDT,RDT} =
    joLinearFunction{DDT,RDT}("conj("*A.name*")",A.m,A.n,
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
transpose(A::joLinearOperator{DDT,RDT}) where {DDT,RDT} =
    joLinearOperator{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
        get(A.fop_T),
        A.fop,
        A.fop_C,
        A.fop_A,
        A.iop_T,
        A.iop,
        A.iop_C,
        A.iop_A
        )
transpose(A::joMatrix{DDT,RDT}) where {DDT,RDT} =
    joMatrix{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
        A.fop_T,
        A.fop,
        A.fop_C,
        A.fop_A,
        A.iop_T,
        A.iop,
        A.iop_C,
        A.iop_A
        )
transpose(A::joLinearFunction{DDT,RDT}) where {DDT,RDT} =
    joLinearFunction{RDT,DDT}("transpose("*A.name*")",A.n,A.m,
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
adjoint(A::joLinearOperator{DDT,RDT}) where {DDT,RDT} =
    joLinearOperator{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
        get(A.fop_A),
        A.fop_C,
        A.fop,
        A.fop_T,
        A.iop_A,
        A.iop_C,
        A.iop,
        A.iop_T
        )
adjoint(A::joMatrix{DDT,RDT}) where {DDT,RDT} =
    joMatrix{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
        A.fop_A,
        A.fop_C,
        A.fop,
        A.fop_T,
        A.iop_A,
        A.iop_C,
        A.iop,
        A.iop_T
        )
adjoint(A::joLinearFunction{DDT,RDT}) where {DDT,RDT} =
    joLinearFunction{RDT,DDT}("adjoint("*A.name*")",A.n,A.m,
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
isreal(A :: joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} = (DDT<:Real && RDT<:Real)

# issymmetric(jo)
issymmetric(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} =
    (A.m == A.n && (norm(elements(A)-elements(transpose(A))) < joTol))

# ishermitian(jo)
ishermitian(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT} =
    (A.m == A.n && (norm(elements(A)-elements(adjoint(A))) < joTol))

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
function *(A::joAbstractLinearOperator{CDT,ARDT},B::joAbstractLinearOperator{BDDT,CDT}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("shape mismatch"))
    return joLinearOperator{BDDT,ARDT}("("*A.name*"*"*B.name*")",size(A,1),size(B,2),
        v1->A*(B*v1),
        v2->transpose(B)*(transpose(A)*v2),
        v3->adjoint(B)*(adjoint(A)*v3),
        v4->conj(A)*(conj(B)*v4),
        @joNF, @joNF, @joNF, @joNF
        )
end

# *(jo,mvec)
function *(A::joLinearOperator{ADDT,ARDT},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joLinearOperatorException("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joMatrix{ADDT,ARDT},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joMatrixException("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joLinearFunction{ADDT,ARDT},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joLinearFunction("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    if A.fMVok
        MV=A.fop(mv)
        jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    else
        MV=Matrix{ARDT}(undef,A.m,size(mv,2))
        for i=1:size(mv,2)
            V=A.fop(mv[:,i])
            i==1 && jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(V)]," / "))
            MV[:,i]=V
        end
    end
    return MV
end

# *(mvec,jo)

# *(jo,vec)
function *(A::joLinearOperator{ADDT,ARDT},v::LocalVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joLinearOperatorException("shape mismatch"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end
function *(A::joMatrix{ADDT,ARDT},v::LocalVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joMatrixException("shape mismatch"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end
function *(A::joLinearFunction{ADDT,ARDT},v::LocalVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joLinearFunctionException("shape mismatch"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end

# *(vec,jo)

# *(num,jo)
function *(a::Number,A::joAbstractLinearOperator{ADDT,ARDT}) where {ADDT,ARDT}
    return joLinearOperator{ADDT,ARDT}("(N*"*A.name*")",A.m,A.n,
        v1->jo_convert(ARDT,a*(A*v1),false),
        v2->jo_convert(ADDT,a*(transpose(A)*v2),false),
        v3->jo_convert(ADDT,conj(a)*(adjoint(A)*v3),false),
        v4->jo_convert(ARDT,conj(a)*(conj(A)*v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
end
function *(a::joNumber{ADDT,ARDT},A::joAbstractLinearOperator{ADDT,ARDT}) where {ADDT,ARDT}
    return joLinearOperator{ADDT,ARDT}("(N*"*A.name*")",A.m,A.n,
        v1->jo_convert(ARDT,a.rdt*(A*v1),false),
        v2->jo_convert(ADDT,a.ddt*(transpose(A)*v2),false),
        v3->jo_convert(ADDT,conj(a.ddt)*(adjoint(A)*v3),false),
        v4->jo_convert(ARDT,conj(a.rdt)*(conj(A)*v4),false),
        @joNF, @joNF, @joNF, @joNF
        )
end

# *(jo,num)
*(A::joAbstractLinearOperator{ADDT,ARDT},a::Number) where {ADDT,ARDT} = a*A
*(A::joAbstractLinearOperator{ADDT,ARDT},a::joNumber{ADDT,ARDT}) where {ADDT,ARDT} = a*A

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)

# \(jo,mvec)
function \(A::joLinearOperator{ADDT,ARDT},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.m == size(mv,1) || throw(joLinearOperatorException("shape mismatch"))
    jo_check_type_match(ARDT,mvDT,join(["RDT for \\(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    if hasinverse(A)
        MV=get(A.iop)(mv)
        jo_check_type_match(ADDT,eltype(MV),join(["DDT from \\(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    elseif issquare(A)
        MV=Matrix{ADDT}(undef,A.n,size(mv,2))
        for i=1:size(mv,2)
            V=jo_convert(ADDT,jo_iterative_solver4square(A,mv[:,i]))
            i==1 && jo_check_type_match(ADDT,eltype(V),join(["DDT from \\(jo,mvec):",A.name,typeof(A),eltype(V)]," / "))
            MV[:,i]=V
        end
    elseif (istall(A) && !isnull(jo_iterative_solver4tall))
        MV=Matrix{ADDT}(undef,A.n,size(mv,2))
        for i=1:size(mv,2)
            V=jo_convert(ADDT,jo_iterative_solver4tall(A,mv[:,i]))
            i==1 && jo_check_type_match(ADDT,eltype(V),join(["DDT from \\(jo,mvec):",A.name,typeof(A),eltype(V)]," / "))
            MV[:,i]=V
        end
    elseif (iswide(A) && !isnull(jo_iterative_solver4wide))
        MV=Matrix{ADDT}(undef,A.n,size(mv,2))
        for i=1:size(mv,2)
            V=jo_convert(ADDT,jo_iterative_solver4wide(A,mv[:,i]))
            i==1 && jo_check_type_match(ADDT,eltype(V),join(["DDT from \\(jo,mvec):",A.name,typeof(A),eltype(V)]," / "))
            MV[:,i]=V
        end
    else
        throw(joLinearOperatorException("\\(jo,MultiVector) not supplied"))
    end
    return MV
end
function \(A::joMatrix{ADDT,ARDT},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.m == size(mv,1) || throw(joMatrixException("shape mismatch"))
    jo_check_type_match(ARDT,mvDT,join(["RDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    if hasinverse(A)
        MV=get(A.iop)(mv)
        jo_check_type_match(ADDT,eltype(MV),join(["DDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    else
        throw(joMatrixException("\\(jo,Vector) not supplied"))
    end
    return MV
end
function \(A::joLinearFunction{ADDT,ARDT},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.m == size(mv,1) || throw(joLinearFunctionException("shape mismatch"))
    jo_check_type_match(ARDT,mvDT,join(["RDT for \\(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    if hasinverse(A)
        if A.iMVok
            MV = get(A.iop)(mv)
        else
            MV=Matrix{ADDT}(undef,A.n,size(mv,2))
            for i=1:size(mv,2)
                V=get(A.iop)(mv[:,i])
                i==1 && jo_check_type_match(ADDT,eltype(V),join(["DDT from \\(jo,mvec):",A.name,typeof(A),eltype(V)]," / "))
                MV[:,i]=V
            end
        end
    elseif issquare(A)
        MV=Matrix{ADDT}(undef,A.n,size(mv,2))
        for i=1:size(mv,2)
            V=jo_convert(ADDT,jo_iterative_solver4square(A,mv[:,i]))
            i==1 && jo_check_type_match(ADDT,eltype(V),join(["DDT from \\(jo,mvec):",A.name,typeof(A),eltype(V)]," / "))
            MV[:,i]=V
        end
    elseif (istall(A) && !isnull(jo_iterative_solver4tall))
        MV=Matrix{ADDT}(undef,A.n,size(mv,2))
        for i=1:size(mv,2)
            V=jo_convert(ADDT,jo_iterative_solver4tall(A,mv[:,i]))
            i==1 && jo_check_type_match(ADDT,eltype(V),join(["DDT from \\(jo,mvec):",A.name,typeof(A),eltype(V)]," / "))
            MV[:,i]=V
        end
    elseif (iswide(A) && !isnull(jo_iterative_solver4wide))
        MV=Matrix{ADDT}(undef,A.n,size(mv,2))
        for i=1:size(mv,2)
            V=jo_convert(ADDT,jo_iterative_solver4wide(A,mv[:,i]))
            i==1 && jo_check_type_match(ADDT,eltype(V),join(["DDT from \\(jo,mvec):",A.name,typeof(A),eltype(V)]," / "))
            MV[:,i]=V
        end
    else
        throw(joLinearFunctionException("\\(jo,MultiVector) not supplied"))
    end
    return MV
end

# \(mvec,jo)

# \(jo,vec)
function \(A::joLinearOperator{ADDT,ARDT},v::LocalVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.m == size(v,1) || throw(joLinearOperatorException("shape mismatch"))
    jo_check_type_match(ARDT,vDT,join(["RDT for \\(jo,vec):",A.name,typeof(A),vDT]," / "))
    if hasinverse(A)
        V=get(A.iop)(v)
        jo_check_type_match(ADDT,eltype(V),join(["DDT from \\(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    elseif issquare(A)
        V=jo_convert(ADDT,jo_iterative_solver4square(A,v))
    elseif (istall(A) && !isnull(jo_iterative_solver4tall))
        V=jo_convert(ADDT,jo_iterative_solver4tall(A,v))
    elseif (iswide(A) && !isnull(jo_iterative_solver4wide))
        V=jo_convert(ADDT,jo_iterative_solver4wide(A,v))
    else
        throw(joLinearOperatorException("\\(jo,Vector) not supplied"))
    end
    return V
end
function \(A::joMatrix{ADDT,ARDT},v::LocalVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.m == size(v,1) || throw(joMatrixException("shape mismatch"))
    jo_check_type_match(ARDT,vDT,join(["RDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    if hasinverse(A)
        V=get(A.iop)(v)
        jo_check_type_match(ADDT,eltype(V),join(["DDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    else
        throw(joMatrixException("\\(jo,Vector) not supplied"))
    end
    return V
end
function \(A::joLinearFunction{ADDT,ARDT},v::LocalVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.m == size(v,1) || throw(joLinearFunctionException("shape mismatch"))
    jo_check_type_match(ARDT,vDT,join(["RDT for \\(jo,vec):",A.name,typeof(A),vDT]," / "))
    if hasinverse(A)
        V=get(A.iop)(v)
        jo_check_type_match(ADDT,eltype(V),join(["DDT from \\(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    elseif issquare(A)
        V=jo_convert(ADDT,jo_iterative_solver4square(A,v))
    elseif (istall(A) && !isnull(jo_iterative_solver4tall))
        V=jo_convert(ADDT,jo_iterative_solver4tall(A,v))
    elseif (iswide(A) && !isnull(jo_iterative_solver4wide))
        V=jo_convert(ADDT,jo_iterative_solver4wide(A,v))
    else
        throw(joLinearFunctionException("\\(jo,Vector) not supplied"))
    end
    return V
end

# \(vec,jo)

# \(num,jo)

# \(jo,num)
#\{ADDT,ARDT}(A::joAbstractLinearOperator{ADDT,ARDT},a::Number) = inv(a)*A
#\{ADDT,ARDT}(A::joAbstractLinearOperator{ADDT,ARDT},a::joNumber{ADDT,ARDT}) = inv(a)*A

############################################################
## overloaded Base +(...jo...)

# +(jo)
+(A::joAbstractLinearOperator) = A

# +(jo,jo)
function +(A::joAbstractLinearOperator{DDT,RDT},B::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT}
    size(A) == size(B) || throw(joAbstractLinearOperatorException("shape mismatch"))
    return joLinearOperator{DDT,RDT}("("*A.name*"+"*B.name*")",size(A,1),size(B,2),
        v1->A*v1+B*v1,
        v2->transpose(A)*v2+transpose(B)*v2,
        v3->adjoint(A)*v3+adjoint(B)*v3,
        v4->conj(A)*v4+conj(B)*v4,
        @joNF, @joNF, @joNF, @joNF
        )
end

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)
function +(A::joAbstractLinearOperator{ADDT,ARDT},b::Number) where {ADDT,ARDT}
    return joLinearOperator{ADDT,ARDT}("("*A.name*"+N)",size(A,1),size(A,2),
        v1->A*v1+joConstants(A.m,A.n,b;DDT=ADDT,RDT=ARDT)*v1,
        v2->transpose(A)*v2+joConstants(A.n,A.m,b;DDT=ARDT,RDT=ADDT)*v2,
        v3->adjoint(A)*v3+joConstants(A.n,A.m,conj(b);DDT=ARDT,RDT=ADDT)*v3,
        v4->conj(A)*v4+joConstants(A.m,A.n,conj(b);DDT=ADDT,RDT=ARDT)*v4,
        @joNF, @joNF, @joNF, @joNF
        )
end
function +(A::joAbstractLinearOperator{ADDT,ARDT},b::joNumber{ADDT,ARDT}) where {ADDT,ARDT}
    return joLinearOperator{ADDT,ARDT}("("*A.name*"+N)",size(A,1),size(A,2),
        v1->A*v1+joConstants(A.m,A.n,b.rdt;DDT=ADDT,RDT=ARDT)*v1,
        v2->transpose(A)*v2+joConstants(A.n,A.m,b.ddt;DDT=ARDT,RDT=ADDT)*v2,
        v3->adjoint(A)*v3+joConstants(A.n,A.m,conj(b.ddt);DDT=ARDT,RDT=ADDT)*v3,
        v4->conj(A)*v4+joConstants(A.m,A.n,conj(b.rdt);DDT=ADDT,RDT=ARDT)*v4,
        @joNF, @joNF, @joNF, @joNF
        )
end

# +(num,jo)
+(b::Number,A::joAbstractLinearOperator{ADDT,ARDT}) where {ADDT,ARDT} = A+b
+(b::joNumber{ADDT,ARDT},A::joAbstractLinearOperator{ADDT,ARDT}) where {ADDT,ARDT} = A+b

############################################################
## overloaded Base -(...jo...)

# -(jo)
-(A::joLinearOperator{DDT,RDT}) where {DDT,RDT} =
    joLinearOperator{DDT,RDT}("(-"*A.name*")",A.m,A.n,
        v1->-A.fop(v1),
        v2->-get(A.fop_T)(v2),
        v3->-get(A.fop_A)(v3),
        v4->-get(A.fop_C)(v4),
        v5->-get(A.iop)(v5),
        v6->-get(A.iop_T)(v6),
        v7->-get(A.iop_A)(v7),
        v8->-get(A.iop_C)(v8)
        )
-(A::joMatrix{DDT,RDT}) where {DDT,RDT} =
    joMatrix{DDT,RDT}("(-"*A.name*")",A.m,A.n,
        v1->-A.fop(v1),
        v2->-A.fop_T(v2),
        v3->-A.fop_A(v3),
        v4->-A.fop_C(v4),
        v5->-get(A.iop)(v5),
        v6->-get(A.iop_T)(v6),
        v7->-get(A.iop_A)(v7),
        v8->-get(A.iop_C)(v8)
        )
-(A::joLinearFunction{DDT,RDT}) where {DDT,RDT} =
    joLinearFunction{DDT,RDT}("(-"*A.name*")",A.m,A.n,
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
-(A::joAbstractLinearOperator,B::joAbstractLinearOperator) = A+(-B)

# -(jo,mvec)

# -(mvec,jo)

# -(jo,vec)

# -(vec,jo)

# -(jo,num)
-(A::joAbstractLinearOperator,b::Number) = A+(-b)
-(A::joAbstractLinearOperator,b::joNumber) = A+(-b)

# -(num,jo)
-(b::Number,A::joAbstractLinearOperator) = -A+b
-(b::joNumber,A::joAbstractLinearOperator) = -A+b

############################################################
## overloaded Base .*(...jo...)

# .*(num,jo)
Base.Broadcast.broadcasted(::typeof(*),a::Number,A::joAbstractLinearOperator) = a*A
Base.Broadcast.broadcasted(::typeof(*),a::joNumber,A::joAbstractLinearOperator) = a*A

# .*(jo,num)
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractLinearOperator,a::Number) = a*A
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractLinearOperator,a::joNumber) = a*A

############################################################
## overloaded Base .\(...jo...)

############################################################
## overloaded Base .+(...jo...)

# .+(jo,num)
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractLinearOperator,b::Number) = A+b
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractLinearOperator,b::joNumber) = A+b

# .+(num,jo)
Base.Broadcast.broadcasted(::typeof(+),b::Number,A::joAbstractLinearOperator) = A+b
Base.Broadcast.broadcasted(::typeof(+),b::joNumber,A::joAbstractLinearOperator) = A+b

############################################################
## overloaded Base .-(...jo...)

# .-(jo,num)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractLinearOperator,b::Number) = A+(-b)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractLinearOperator,b::joNumber) = A+(-b)

# .-(num,jo)
Base.Broadcast.broadcasted(::typeof(-),b::Number,A::joAbstractLinearOperator) = -A+b
Base.Broadcast.broadcasted(::typeof(-),b::joNumber,A::joAbstractLinearOperator) = -A+b

############################################################
## overloaded Base block methods

# hcat(...jo...)
hcat(ops::joAbstractLinearOperator...) = joDict(ops...)

# vcat(...jo...)
vcat(ops::joAbstractLinearOperator...) = joStack(ops...)

# hvcat(...jo...)
hvcat(rows::Tuple{Vararg{Int}}, ops::joAbstractLinearOperator...) = joBlock(collect(rows),ops...)

############################################################
## overloaded LinearAlgebra functions

# mul!(...,jo,...)
mul!(y::LocalVector{RDT},A::joAbstractLinearOperator{DDT,RDT},x::LocalVector{DDT}) where {DDT,RDT} = y[:] = A * x
mul!(y::LocalMatrix{RDT},A::joAbstractLinearOperator{DDT,RDT},x::LocalMatrix{DDT}) where {DDT,RDT} = y[:,:] = A * x

# ldiv!(...,jo,...)
ldiv!(y::LocalVector{DDT},A::joAbstractLinearOperator{DDT,RDT},x::LocalVector{RDT}) where {DDT,RDT} = y[:] = A \ x
ldiv!(y::LocalMatrix{DDT},A::joAbstractLinearOperator{DDT,RDT},x::LocalMatrix{RDT}) where {DDT,RDT} = y[:,:] = A \ x

