############################################################
## joAbstractSAparallelLinearOperator(s) - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractSAparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = promote_type(DDT,RDT)

# deltype(jo)
deltype(A::joAbstractSAparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = DDT

# reltype(jo)
reltype(A::joAbstractSAparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = RDT

# show(jo)
function show(A::joAbstractSAparallelLinearOperator)
    println("Type: $(typeof(A).name)")
    println("Name: $(A.name)")
    println("Size: $(size(A))")
    println(" NVC: $(A.nvc)")
    println(" DDT: $(deltype(A))")
    println(" RDT: $(reltype(A))")
    return nothing
end

# display(jo)
display(A::joAbstractSAparallelLinearOperator) = println((typeof(A),((A.m,A.n),A.nvc),A.name))

# size(jo)
size(A::joAbstractSAparallelLinearOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joAbstractSAparallelLinearOperator,ind::Integer)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	elseif ind==3
		return A.nvc
	else
		throw(joAbstractSAparallelLinearOperatorException("invalid index"))
	end
end

# length(jo)
length(A::joAbstractSAparallelLinearOperator) = A.m*A.n

# jo_full(jo)

# norm(jo)

# real(jo)

# imag(jo)

# conj(jo)
conj(A::joSALinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSALinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.PAs_in, A.PAs_out, A.fclean, A.rclean
        )
conj(A::joSAdistributedLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSAdistributedLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.PAs_in, A.PAs_out, A.fclean, A.rclean
        )
conj(A::joSAdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSAdistributingLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.PAs_out, A.gclean
        )
conj(A::joSAgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSAgatheringLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.PAs_in, A.gclean
        )

# transpose(jo)
transpose(A::joSALinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSALinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_out, A.PAs_in, A.rclean, A.fclean
        )
transpose(A::joSAdistributedLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSAdistributedLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_out, A.PAs_in, A.rclean, A.fclean
        )
transpose(A::joSAdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSAgatheringLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_out, A.gclean
        )
transpose(A::joSAgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSAdistributingLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_in, A.gclean
        )

# adjoint(jo)
adjoint(A::joSALinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSALinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.PAs_out, A.PAs_in, A.rclean, A.fclean
        )
adjoint(A::joSAdistributedLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSAdistributedLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.PAs_out, A.PAs_in, A.rclean, A.fclean
        )
adjoint(A::joSAdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSAgatheringLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.PAs_out, A.gclean
        )
adjoint(A::joSAgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joSAdistributingLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.PAs_in, A.gclean
        )

# isreal(jo)
isreal(A :: joAbstractSAparallelLinearOperator{DDT,RDT}) where {DDT,RDT} = (DDT<:Real && RDT<:Real)

# issymmetric(jo)

# ishermitian(jo)

# getindex(jo,...)

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
function *(A::joSALinOpsUnion{CDT,ARDT,2},B::joSALinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joSALinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joSALinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.PAs_in,B.PAs_out) || throw(joSALinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joSALinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.PAs_in,A.PAs_out,B.fclean,A.rclean)
end
function *(A::joSALinOpsUnion{CDT,ARDT,2},B::joSAdistributeLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joSALinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joSALinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.PAs_in,B.PAs_out) || throw(joSALinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joSAdistributingLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               A.PAs_out,B.gclean)
end
function *(A::joSAgatherLinOpsUnion{CDT,ARDT,2},B::joSALinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joSAgatheringLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joSAgatheringLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.PAs_in,B.PAs_out) || throw(joSAgatheringLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joSAgatheringLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.PAs_in,B.fclean)
end
function *(A::joSAdistributeLinOpsUnion{CDT,ARDT,2},B::joSAgatherLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joSALinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joSALinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    return joSALinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.PAs_in,A.PAs_out,B.gclean,A.gclean)
end
function *(A::joSAgatherLinOpsUnion{CDT,ARDT,2},B::joSAdistributeLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
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
    size(A,2) == size(B,1) || throw(joSALinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.PAs_out.dims[2]==B.PAs_in.dims[2] || throw(joSALinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    @warn "*($(typeof(A)),$(typeof(B))) is a senseless operation. Get rid of it!"
    return joSALinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.PAs_out.dims[2],
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
function *(A::joSAdistributeLinOpsUnion{CDT,ARDT,2},B::joAbstractLinearOperator{BDDT,CDT}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    return joSAdistributingLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               A.PAs_out,A.gclean)
end
function *(A::joAbstractLinearOperator{CDT,ARDT},B::joSAgatherLinOpsUnion{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    return joSAgatheringLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),B.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.PAs_in,B.gclean)
end

# *(jo,mvec)
function *(A::joSALinearOperator{ADDT,ARDT,2},mv::SharedArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joSALinearOperatorException("shape mismatch"))
    A.nvc == size(mv,2) || throw(joSALinearOperatorException("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    isequiv(A.PAs_in,mv) || throw(joSALinearOperatorException("*($(A.name),mv::SharedArray): input distributor mismatch"))
    MV=A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joSAdistributedLinearOperator{ADDT,ARDT,2},mv::SharedArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joSAdistributedLinearOperatorException("shape mismatch"))
    A.nvc == size(mv,2) || throw(joSAdistributedLinearOperatorException("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    isequiv(A.PAs_in,mv) || throw(joSAdistributedLinearOperatorException("*($(A.name),mv::SharedArray): input distributor mismatch"))
    MV=salloc(A.PAs_out)
    joSAutils.jo_x_mv!(A.fop,A.PAs_in,A.PAs_out,mv,MV)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joSAdistributingLinearOperator{ADDT,ARDT,2},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joSAdistributingLinearOperatorException("shape mismatch in A$(size(A))*v$(size(mv))"))
    A.nvc == size(mv,2) || throw(joSAdistributingLinearOperatorException("nvc size mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joSAgatheringLinearOperator{ADDT,ARDT,2},mv::SharedArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joSAgatheringLinearOperatorException("shape mismatch in A$(size(A))*v$(size(mv))"))
    A.nvc == size(mv,2) || throw(joSAgatheringLinearOperatorException("nvc size mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    isequiv(A.PAs_in,mv) || throw(joSAgatheringLinearOperatorException("*($(A.name),mv::SharedArray): input distributor mismatch"))
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
#\{ADDT,ARDT}(A::joAbstractSAparallelLinearOperator{ADDT,ARDT},a::Number) = inv(a)*A
#\{ADDT,ARDT}(A::joAbstractSAparallelLinearOperator{ADDT,ARDT},a::joNumber{ADDT,ARDT}) = inv(a)*A

############################################################
## overloaded Base +(...jo...)

# +(jo)
+(A::joAbstractSAparallelLinearOperator) = A

# +(jo,jo)

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)

# +(num,jo)
+(b::Number,A::joAbstractSAparallelLinearOperator{ADDT,ARDT}) where {ADDT,ARDT} = A+b
+(b::joNumber{ADDT,ARDT},A::joAbstractSAparallelLinearOperator{ADDT,ARDT}) where {ADDT,ARDT} = A+b

############################################################
## overloaded Base -(...jo...)

# -(jo)

# -(jo,jo)
-(A::joAbstractSAparallelLinearOperator,B::joAbstractSAparallelLinearOperator) = A+(-B)

# -(jo,mvec)

# -(mvec,jo)

# -(jo,vec)

# -(vec,jo)

# -(jo,num)
-(A::joAbstractSAparallelLinearOperator,b::Number) = A+(-b)
-(A::joAbstractSAparallelLinearOperator,b::joNumber) = A+(-b)

# -(num,jo)
-(b::Number,A::joAbstractSAparallelLinearOperator) = -A+b
-(b::joNumber,A::joAbstractSAparallelLinearOperator) = -A+b

############################################################
## overloaded Base .*(...jo...)

# .*(num,jo)
Base.Broadcast.broadcasted(::typeof(*),a::Number,A::joAbstractSAparallelLinearOperator) = a*A
Base.Broadcast.broadcasted(::typeof(*),a::joNumber,A::joAbstractSAparallelLinearOperator) = a*A

# .*(jo,num)
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractSAparallelLinearOperator,a::Number) = a*A
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractSAparallelLinearOperator,a::joNumber) = a*A

############################################################
## overloaded Base .\(...jo...)

############################################################
## overloaded Base .+(...jo...)

# .+(jo,num)
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractSAparallelLinearOperator,b::Number) = A+b
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractSAparallelLinearOperator,b::joNumber) = A+b

# .+(num,jo)
Base.Broadcast.broadcasted(::typeof(+),b::Number,A::joAbstractSAparallelLinearOperator) = A+b
Base.Broadcast.broadcasted(::typeof(+),b::joNumber,A::joAbstractSAparallelLinearOperator) = A+b

############################################################
## overloaded Base .-(...jo...)

# .-(jo,num)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractSAparallelLinearOperator,b::Number) = A+(-b)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractSAparallelLinearOperator,b::joNumber) = A+(-b)

# .-(num,jo)
Base.Broadcast.broadcasted(::typeof(-),b::Number,A::joAbstractSAparallelLinearOperator) = -A+b
Base.Broadcast.broadcasted(::typeof(-),b::joNumber,A::joAbstractSAparallelLinearOperator) = -A+b

############################################################
## overloaded Base block methods

# hcat(...jo...)

# vcat(...jo...)

# hvcat(...jo...)

############################################################
## overloaded LinearAlgebra functions

# mul!(...,jo,...)

# ldiv!(...,jo,...)

