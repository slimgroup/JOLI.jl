############################################################
## joAbstractSMVparallelLinearOperator(s) - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractSMVparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = promote_type(DDT,RDT)

# deltype(jo)
deltype(A::joAbstractSMVparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = DDT

# reltype(jo)
reltype(A::joAbstractSMVparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = RDT

# show(jo)
show(A::joAbstractSMVparallelLinearOperator) = println((typeof(A),A.name,(A.m,A.n),A.nvc))

# display(jo)
display(A::joAbstractSMVparallelLinearOperator) = show(A)

# size(jo)
size(A::joAbstractSMVparallelLinearOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joAbstractSMVparallelLinearOperator,ind::Integer)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	elseif ind==3
		return A.nvc
	else
		throw(joAbstractSMVparallelLinearOperatorException("invalid index"))
	end
end

# length(jo)
length(A::joAbstractSMVparallelLinearOperator) = A.m*A.n

# jo_full(jo)

# norm(jo)

# real(jo)

# imag(jo)

# conj(jo)
conj(A::joSMVLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSMVLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.PAs_in, A.PAs_out, A.fclean, A.rclean
        )
conj(A::joSMVdistributedLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSMVdistributedLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.PAs_in, A.PAs_out, A.fclean, A.rclean
        )
conj(A::joSMVdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSMVdistributingLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.PAs_out, A.gclean
        )
conj(A::joSMVgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSMVgatheringLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.PAs_in, A.gclean
        )

# transpose(jo)
transpose(A::joSMVLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSMVLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_out, A.PAs_in, A.rclean, A.fclean
        )
transpose(A::joSMVdistributedLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSMVdistributedLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_out, A.PAs_in, A.rclean, A.fclean
        )
transpose(A::joSMVdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSMVgatheringLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_out, A.gclean
        )
transpose(A::joSMVgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSMVdistributingLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_in, A.gclean
        )

# adjoint(jo)
adjoint(A::joSMVLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSMVLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.PAs_out, A.PAs_in, A.rclean, A.fclean
        )
adjoint(A::joSMVdistributedLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSMVdistributedLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.PAs_out, A.PAs_in, A.rclean, A.fclean
        )
adjoint(A::joSMVdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSMVgatheringLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.PAs_out, A.gclean
        )
adjoint(A::joSMVgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSMVdistributingLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.PAs_in, A.gclean
        )

# isreal(jo)
isreal(A :: joAbstractSMVparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = (DDT<:Real && RDT<:Real)

# issymmetric(jo)

# ishermitian(jo)

# getindex(jo,...)

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
function *(A::joSMVLinOpsUnion{CDT,ARDT,2},B::joSMVLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joSMVLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joSMVLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.PAs_in,B.PAs_out) || throw(joSMVLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joSMVLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.PAs_in,A.PAs_out,B.fclean,A.rclean)
end
function *(A::joSMVLinOpsUnion{CDT,ARDT,2},B::joSMVdistributeLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joSMVLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joSMVLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.PAs_in,B.PAs_out) || throw(joSMVLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joSMVdistributingLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               A.PAs_out,B.gclean)
end
function *(A::joSMVgatherLinOpsUnion{CDT,ARDT,2},B::joSMVLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joSMVgatheringLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joSMVgatheringLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.PAs_in,B.PAs_out) || throw(joSMVgatheringLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joSMVgatheringLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.PAs_in,B.fclean)
end
function *(A::joSMVdistributeLinOpsUnion{CDT,ARDT,2},B::joSMVgatherLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joSMVLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joSMVLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    return joSMVLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.PAs_in,A.PAs_out,B.gclean,A.gclean)
end
function *(A::joSMVgatherLinOpsUnion{CDT,ARDT,2},B::joSMVdistributeLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
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
function *(A::joSAdistribute{CDT,ARDT,2},B::joSAgather{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joSMVLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.PAs_out.dims[2]==B.PAs_in.dims[2] || throw(joSMVLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    @warn "*($(typeof(A)),$(typeof(B))) is a senseless operation. Get rid of it!"
    return joSMVLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.PAs_out.dims[2],
               v1->v1, v2->v2, v3->v3, v4->v4,
               @joNF, @joNF, @joNF, @joNF,
               B.PAs_in,A.PAs_out,B.gclean,A.gclean)
end
function *(A::joSAgather{CDT,ARDT,2},B::joSAdistribute{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.PAs_in.dims[2]==B.PAs_out.dims[2] || throw(joLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.PAs_in,B.PAs_out) || throw(joLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    @warn "*($(typeof(A)),$(typeof(B))) is a senseless operation. Get rid of it!"
    return joLinearOperator{BDDT,ARDT}("($(A.name)*$(B.name))",size(A,1),size(B,2),
               v1->v1, v2->v2, v3->v3, v4->v4,
               @joNF, @joNF, @joNF, @joNF)
end
# joSA with joAbstractLinearOperator
function *(A::joSMVdistributeLinOpsUnion{CDT,ARDT,2},B::joAbstractLinearOperator{BDDT,CDT}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    return joSMVdistributingLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               A.PAs_out,A.gclean)
end
function *(A::joAbstractLinearOperator{CDT,ARDT},B::joSMVgatherLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    return joSMVgatheringLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),B.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.PAs_in,B.gclean)
end

# *(jo,mvec)
function *(A::joSMVLinearOperator{ADDT,ARDT,2},mv::SharedArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joSMVLinearOperatorException("shape mismatch"))
    A.nvc == size(mv,2) || throw(joSMVLinearOperatorException("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    isequiv(A.PAs_in,mv) || throw(joSMVLinearOperatorException("*($(A.name),mv::SharedArray): input distributor mismatch"))
    MV=A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joSMVdistributedLinearOperator{ADDT,ARDT,2},mv::SharedArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joSMVdistributedLinearOperatorException("shape mismatch"))
    A.nvc == size(mv,2) || throw(joSMVdistributedLinearOperatorException("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    isequiv(A.PAs_in,mv) || throw(joSMVdistributedLinearOperatorException("*($(A.name),mv::SharedArray): input distributor mismatch"))
    MV=salloc(A.PAs_out)
    joSAutils.jo_x_mv!(A.fop,A.PAs_in,A.PAs_out,mv,MV)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joSMVdistributingLinearOperator{ADDT,ARDT,2},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joSMVdistributingLinearOperatorException("shape mismatch in A$(size(A))*v$(size(mv))"))
    A.nvc == size(mv,2) || throw(joSMVdistributingLinearOperatorException("nvc size mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joSMVgatheringLinearOperator{ADDT,ARDT,2},mv::SharedArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joSMVgatheringLinearOperatorException("shape mismatch in A$(size(A))*v$(size(mv))"))
    A.nvc == size(mv,2) || throw(joSMVgatheringLinearOperatorException("nvc size mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    isequiv(A.PAs_in,mv) || throw(joSMVgatheringLinearOperatorException("*($(A.name),mv::SharedArray): input distributor mismatch"))
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
#\{ADDT,ARDT}(A::joAbstractSMVparallelLinearOperator{ADDT,ARDT},a::Number) = inv(a)*A
#\{ADDT,ARDT}(A::joAbstractSMVparallelLinearOperator{ADDT,ARDT},a::joNumber{ADDT,ARDT}) = inv(a)*A

############################################################
## overloaded Base +(...jo...)

# +(jo)
+(A::joAbstractSMVparallelLinearOperator) = A

# +(jo,jo)

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)

# +(num,jo)
+(b::Number,A::joAbstractSMVparallelLinearOperator{ADDT,ARDT}) where {ADDT,ARDT} = A+b
+(b::joNumber{ADDT,ARDT},A::joAbstractSMVparallelLinearOperator{ADDT,ARDT}) where {ADDT,ARDT} = A+b

############################################################
## overloaded Base -(...jo...)

# -(jo)

# -(jo,jo)
-(A::joAbstractSMVparallelLinearOperator,B::joAbstractSMVparallelLinearOperator) = A+(-B)

# -(jo,mvec)

# -(mvec,jo)

# -(jo,vec)

# -(vec,jo)

# -(jo,num)
-(A::joAbstractSMVparallelLinearOperator,b::Number) = A+(-b)
-(A::joAbstractSMVparallelLinearOperator,b::joNumber) = A+(-b)

# -(num,jo)
-(b::Number,A::joAbstractSMVparallelLinearOperator) = -A+b
-(b::joNumber,A::joAbstractSMVparallelLinearOperator) = -A+b

############################################################
## overloaded Base .*(...jo...)

# .*(num,jo)
Base.Broadcast.broadcasted(::typeof(*),a::Number,A::joAbstractSMVparallelLinearOperator) = a*A
Base.Broadcast.broadcasted(::typeof(*),a::joNumber,A::joAbstractSMVparallelLinearOperator) = a*A

# .*(jo,num)
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractSMVparallelLinearOperator,a::Number) = a*A
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractSMVparallelLinearOperator,a::joNumber) = a*A

############################################################
## overloaded Base .\(...jo...)

############################################################
## overloaded Base .+(...jo...)

# .+(jo,num)
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractSMVparallelLinearOperator,b::Number) = A+b
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractSMVparallelLinearOperator,b::joNumber) = A+b

# .+(num,jo)
Base.Broadcast.broadcasted(::typeof(+),b::Number,A::joAbstractSMVparallelLinearOperator) = A+b
Base.Broadcast.broadcasted(::typeof(+),b::joNumber,A::joAbstractSMVparallelLinearOperator) = A+b

############################################################
## overloaded Base .-(...jo...)

# .-(jo,num)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractSMVparallelLinearOperator,b::Number) = A+(-b)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractSMVparallelLinearOperator,b::joNumber) = A+(-b)

# .-(num,jo)
Base.Broadcast.broadcasted(::typeof(-),b::Number,A::joAbstractSMVparallelLinearOperator) = -A+b
Base.Broadcast.broadcasted(::typeof(-),b::joNumber,A::joAbstractSMVparallelLinearOperator) = -A+b

############################################################
## overloaded Base block methods

# hcat(...jo...)

# vcat(...jo...)

# hvcat(...jo...)

############################################################
## overloaded LinearAlgebra functions

# mul!(...,jo,...)

# ldiv!(...,jo,...)

