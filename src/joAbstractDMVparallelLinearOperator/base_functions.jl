############################################################
## joAbstractDMVparallelLinearOperator(s) - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractDMVparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = promote_type(DDT,RDT)

# deltype(jo)
deltype(A::joAbstractDMVparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = DDT

# reltype(jo)
reltype(A::joAbstractDMVparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = RDT

# show(jo)
show(A::joAbstractDMVparallelLinearOperator) = println((typeof(A),A.name,(A.m,A.n),A.nvc))

# display(jo)
display(A::joAbstractDMVparallelLinearOperator) = show(A)

# size(jo)
size(A::joAbstractDMVparallelLinearOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joAbstractDMVparallelLinearOperator,ind::Integer)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	elseif ind==3
		return A.nvc
	else
		throw(joAbstractDMVparallelLinearOperatorException("invalid index"))
	end
end

# length(jo)
length(A::joAbstractDMVparallelLinearOperator) = A.m*A.n

# jo_full(jo)

# norm(jo)

# real(jo)

# imag(jo)

# conj(jo)
conj(A::joDMVLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDMVLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.PAs_in, A.PAs_out, A.fclean, A.rclean
        )
conj(A::joDMVdistributedLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDMVdistributedLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.PAs_in, A.PAs_out, A.fclean, A.rclean
        )
conj(A::joDMVdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDMVdistributingLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.PAs_out, A.gclean
        )
conj(A::joDMVgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDMVgatheringLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.PAs_in, A.gclean
        )

# transpose(jo)
transpose(A::joDMVLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDMVLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_out, A.PAs_in, A.rclean, A.fclean
        )
transpose(A::joDMVdistributedLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDMVdistributedLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_out, A.PAs_in, A.rclean, A.fclean
        )
transpose(A::joDMVdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDMVgatheringLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_out, A.gclean
        )
transpose(A::joDMVgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDMVdistributingLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_in, A.gclean
        )

# adjoint(jo)
adjoint(A::joDMVLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDMVLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.PAs_out, A.PAs_in, A.rclean, A.fclean
        )
adjoint(A::joDMVdistributedLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDMVdistributedLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.PAs_out, A.PAs_in, A.rclean, A.fclean
        )
adjoint(A::joDMVdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDMVgatheringLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.PAs_out, A.gclean
        )
adjoint(A::joDMVgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDMVdistributingLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.PAs_in, A.gclean
        )

# isreal(jo)
isreal(A :: joAbstractDMVparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = (DDT<:Real && RDT<:Real)

# issymmetric(jo)

# ishermitian(jo)

# getindex(jo,...)

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
function *(A::joDMVLinOpsUnion{CDT,ARDT,2},B::joDMVLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joDMVLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joDMVLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.PAs_in,B.PAs_out) || throw(joDMVLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joDMVLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.PAs_in,A.PAs_out,B.fclean,A.rclean)
end
function *(A::joDMVLinOpsUnion{CDT,ARDT,2},B::joDMVdistributeLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joDMVLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joDMVLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.PAs_in,B.PAs_out) || throw(joDMVLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joDMVdistributingLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               A.PAs_out,B.gclean)
end
function *(A::joDMVgatherLinOpsUnion{CDT,ARDT,2},B::joDMVLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joDMVgatheringLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joDMVgatheringLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.PAs_in,B.PAs_out) || throw(joDMVgatheringLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joDMVgatheringLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.PAs_in,B.fclean)
end
function *(A::joDMVdistributeLinOpsUnion{CDT,ARDT,2},B::joDMVgatherLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joDMVLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joDMVLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    return joDMVLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.PAs_in,A.PAs_out,B.gclean,A.gclean)
end
function *(A::joDMVgatherLinOpsUnion{CDT,ARDT,2},B::joDMVdistributeLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.PAs_in,B.PAs_out) || throw(joLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joLinearOperator{BDDT,ARDT}("($(A.name)*$(B.name))",size(A,1),size(B,2),
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF)
end
# extras with warnings
function *(A::joDAdistribute{CDT,ARDT,2},B::joDAgather{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joDMVLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.PAs_out.dims[2]==B.PAs_in.dims[2] || throw(joDMVLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    @warn "*($(typeof(A)),$(typeof(B))) is a senseless operation. Get rid of it!"
    return joDMVLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.PAs_out.dims[2],
               v1->v1, v2->v2, v3->v3, v4->v4,
               @joNF, @joNF, @joNF, @joNF,
               B.PAs_in,A.PAs_out,B.gclean,A.gclean)
end
function *(A::joDAgather{CDT,ARDT,2},B::joDAdistribute{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.PAs_in.dims[2]==B.PAs_out.dims[2] || throw(joLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.PAs_in,B.PAs_out) || throw(joLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    @warn "*($(typeof(A)),$(typeof(B))) is a senseless operation. Get rid of it!"
    return joLinearOperator{BDDT,ARDT}("($(A.name)*$(B.name))",size(A,1),size(B,2),
               v1->v1, v2->v2, v3->v3, v4->v4,
               @joNF, @joNF, @joNF, @joNF)
end
# joDA with joAbstractLinearOperator
function *(A::joDMVdistributeLinOpsUnion{CDT,ARDT,2},B::joAbstractLinearOperator{BDDT,CDT}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    return joDMVdistributingLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               A.PAs_out,A.gclean)
end
function *(A::joAbstractLinearOperator{CDT,ARDT},B::joDMVgatherLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    return joDMVgatheringLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),B.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.PAs_in,B.gclean)
end

# *(jo,mvec)
function *(A::joDMVLinearOperator{ADDT,ARDT,2},mv::DArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joDMVLinearOperatorException("shape mismatch"))
    A.nvc == size(mv,2) || throw(joDMVLinearOperatorException("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    isequiv(A.PAs_in,mv) || throw(joDMVLinearOperatorException("*($(A.name),mv::DArray): input distributor mismatch"))
    MV=A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joDMVdistributedLinearOperator{ADDT,ARDT,2},mv::DArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joDMVdistributedLinearOperatorException("shape mismatch"))
    A.nvc == size(mv,2) || throw(joDMVdistributedLinearOperatorException("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    isequiv(A.PAs_in,mv) || throw(joDMVdistributedLinearOperatorException("*($(A.name),mv::DArray): input distributor mismatch"))
    MV=dalloc(A.PAs_out)
    spmd(joDAutils.jo_x_mv!,A.fop,mv,MV,pids=A.PAs_out.procs)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joDMVdistributingLinearOperator{ADDT,ARDT,2},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joDMVdistributingLinearOperatorException("shape mismatch in A$(size(A))*v$(size(mv))"))
    A.nvc == size(mv,2) || throw(joDMVdistributingLinearOperatorException("nvc size mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joDMVgatheringLinearOperator{ADDT,ARDT,2},mv::DArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joDMVgatheringLinearOperatorException("shape mismatch in A$(size(A))*v$(size(mv))"))
    A.nvc == size(mv,2) || throw(joDMVgatheringLinearOperatorException("nvc size mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    isequiv(A.PAs_in,mv) || throw(joDMVgatheringLinearOperatorException("*($(A.name),mv::DArray): input distributor mismatch"))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end

# *(mvec,jo)

# *(jo,vec)

# *(vec,jo)

# *(num,jo)

# *(jo,num)

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)

# \(jo,mvec)

# \(mvec,jo)

# \(jo,vec)

# \(vec,jo)

# \(num,jo)

# \(jo,num)
#\{ADDT,ARDT}(A::joAbstractDMVparallelLinearOperator{ADDT,ARDT},a::Number) = inv(a)*A
#\{ADDT,ARDT}(A::joAbstractDMVparallelLinearOperator{ADDT,ARDT},a::joNumber{ADDT,ARDT}) = inv(a)*A

############################################################
## overloaded Base +(...jo...)

# +(jo)
+(A::joAbstractDMVparallelLinearOperator) = A

# +(jo,jo)

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)

# +(num,jo)
+(b::Number,A::joAbstractDMVparallelLinearOperator{ADDT,ARDT}) where {ADDT,ARDT} = A+b
+(b::joNumber{ADDT,ARDT},A::joAbstractDMVparallelLinearOperator{ADDT,ARDT}) where {ADDT,ARDT} = A+b

############################################################
## overloaded Base -(...jo...)

# -(jo)

# -(jo,jo)
-(A::joAbstractDMVparallelLinearOperator,B::joAbstractDMVparallelLinearOperator) = A+(-B)

# -(jo,mvec)

# -(mvec,jo)

# -(jo,vec)

# -(vec,jo)

# -(jo,num)
-(A::joAbstractDMVparallelLinearOperator,b::Number) = A+(-b)
-(A::joAbstractDMVparallelLinearOperator,b::joNumber) = A+(-b)

# -(num,jo)
-(b::Number,A::joAbstractDMVparallelLinearOperator) = -A+b
-(b::joNumber,A::joAbstractDMVparallelLinearOperator) = -A+b

############################################################
## overloaded Base .*(...jo...)

# .*(num,jo)
Base.Broadcast.broadcasted(::typeof(*),a::Number,A::joAbstractDMVparallelLinearOperator) = a*A
Base.Broadcast.broadcasted(::typeof(*),a::joNumber,A::joAbstractDMVparallelLinearOperator) = a*A

# .*(jo,num)
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractDMVparallelLinearOperator,a::Number) = a*A
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractDMVparallelLinearOperator,a::joNumber) = a*A

############################################################
## overloaded Base .\(...jo...)

############################################################
## overloaded Base .+(...jo...)

# .+(jo,num)
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractDMVparallelLinearOperator,b::Number) = A+b
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractDMVparallelLinearOperator,b::joNumber) = A+b

# .+(num,jo)
Base.Broadcast.broadcasted(::typeof(+),b::Number,A::joAbstractDMVparallelLinearOperator) = A+b
Base.Broadcast.broadcasted(::typeof(+),b::joNumber,A::joAbstractDMVparallelLinearOperator) = A+b

############################################################
## overloaded Base .-(...jo...)

# .-(jo,num)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractDMVparallelLinearOperator,b::Number) = A+(-b)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractDMVparallelLinearOperator,b::joNumber) = A+(-b)

# .-(num,jo)
Base.Broadcast.broadcasted(::typeof(-),b::Number,A::joAbstractDMVparallelLinearOperator) = -A+b
Base.Broadcast.broadcasted(::typeof(-),b::joNumber,A::joAbstractDMVparallelLinearOperator) = -A+b

############################################################
## overloaded Base block methods

# hcat(...jo...)

# vcat(...jo...)

# hvcat(...jo...)

############################################################
## overloaded LinearAlgebra functions

# mul!(...,jo,...)

# ldiv!(...,jo,...)

