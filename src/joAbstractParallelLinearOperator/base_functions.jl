############################################################
## joAbstractParallelLinearOperator(s) - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractParallelLinearOperator{DDT,RDT}) where {DDT,RDT} = promote_type(DDT,RDT)

# deltype(jo)
deltype(A::joAbstractParallelLinearOperator{DDT,RDT}) where {DDT,RDT} = DDT

# reltype(jo)
reltype(A::joAbstractParallelLinearOperator{DDT,RDT}) where {DDT,RDT} = RDT

# show(jo)
show(A::joAbstractParallelLinearOperator) = println((typeof(A),A.name,(A.m,A.n),A.nvc))

# display(jo)
display(A::joAbstractParallelLinearOperator) = show(A)

# size(jo)
size(A::joAbstractParallelLinearOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joAbstractParallelLinearOperator,ind::Integer)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	elseif ind==3
		return A.nvc
	else
		throw(joAbstractParallelLinearOperatorException("invalid index"))
	end
end

# length(jo)
length(A::joAbstractParallelLinearOperator) = A.m*A.n

# jo_full(jo)

# norm(jo)

# real(jo)

# imag(jo)

# conj(jo)
conj(A::joDALinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDALinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.dst_in, A.dst_out, A.fclean, A.rclean
        )
conj(A::joDAdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAdistributingLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.dst_out, A.gclean
        )
conj(A::joDAgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAgatheringLinearOperator{DDT,RDT,N}("conj("*A.name*")",A.m,A.n,A.nvc,
        get(A.fop_C), A.fop_A, A.fop_T, A.fop,
        A.iop_C, A.iop_A, A.iop_T, A.iop,
        A.dst_in, A.gclean
        )

# transpose(jo)
transpose(A::joDALinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDALinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.dst_out, A.dst_in, A.rclean, A.fclean
        )
transpose(A::joDAdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAgatheringLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.dst_out, A.gclean
        )
transpose(A::joDAgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAdistributingLinearOperator{RDT,DDT,N}("transpose("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_T), A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.dst_in, A.gclean
        )

# adjoint(jo)
adjoint(A::joDALinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDALinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.dst_out, A.dst_in, A.rclean, A.fclean
        )
adjoint(A::joDAdistributingLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAgatheringLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.dst_out, A.gclean
        )
adjoint(A::joDAgatheringLinearOperator{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAdistributingLinearOperator{RDT,DDT,N}("adjoint("*A.name*")",A.n,A.m,A.nvc,
        get(A.fop_A), A.fop_C, A.fop, A.fop_T,
        A.iop_A, A.iop_C, A.iop, A.iop_T,
        A.dst_in, A.gclean
        )

# isreal(jo)
isreal(A :: joAbstractParallelLinearOperator{DDT,RDT}) where {DDT,RDT} = (DDT<:Real && RDT<:Real)

# issymmetric(jo)

# ishermitian(jo)

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
function *(A::joDALinearOperator{CDT,ARDT,2},B::joDALinearOperator{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joDALinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joDALinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.dst_in,B.dst_out) || throw(joDALinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joDALinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.dst_in,A.dst_out,B.fclean,A.rclean)
end
function *(A::joDALinearOperator{CDT,ARDT,2},B::joDAdistribute{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joDALinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.dst_out.dims[2] || throw(joDALinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.dst_in,B.dst_out) || throw(joDALinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joDAdistributingLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               A.dst_out,A.gclean)
end
function *(A::joDALinearOperator{CDT,ARDT,2},B::joDAdistributingLinearOperator{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joDALinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joDALinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.dst_in,B.dst_out) || throw(joDALinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joDAdistributingLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               A.dst_out,A.gclean)
end
function *(A::joDAdistribute{CDT,ARDT,2},B::joDAgather{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joDALinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.dst_out.dims[2]==B.dst_in.dims[2] || throw(joDALinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    @warn "*($(typeof(A)),$(typeof(B))) is a senseless operation. Get rid of it!"
    return joDALinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.dst_out.dims[2],
               v1->v1, v2->v2, v3->v3, v4->v4,
               @joNF, @joNF, @joNF, @joNF,
               B.dst_in,A.dst_out,B.gclean,A.gclean)
end
function *(A::joDAdistribute{CDT,ARDT,2},B::joDAgatheringLinearOperator{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joDALinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.dst_out.dims[2]==B.nvc || throw(joDALinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    return joDALinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.dst_out.dims[2],
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.dst_in,A.dst_out,B.gclean,A.gclean)
end
function *(A::joDAdistributingLinearOperator{CDT,ARDT,2},B::joDAgather{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joDALinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.dst_in.dims[2] || throw(joDALinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    #@info "*($(typeof(A)),$(typeof(B))) is a questionable operation. Try to eliminate it."
    return joDALinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.dst_in,A.dst_out,B.gclean,A.gclean)
end
function *(A::joDAdistributingLinearOperator{CDT,ARDT,2},B::joDAgatheringLinearOperator{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joDALinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joDALinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    return joDALinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.dst_in,A.dst_out,B.gclean,A.gclean)
end
function *(A::joDAgather{CDT,ARDT,2},B::joDALinearOperator{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joDAgatheringLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.dst_in.dims[2]==B.nvc || throw(joDAgatheringLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.dst_in,B.dst_out) || throw(joDAgatheringLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joDAgatheringLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.dst_in.dims[2],
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.dst_in,A.gclean)
end
function *(A::joDAgatheringLinearOperator{CDT,ARDT,2},B::joDALinearOperator{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joDAgatheringLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joDAgatheringLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.dst_in,B.dst_out) || throw(joDAgatheringLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joDAgatheringLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.dst_in,A.gclean)
end
function *(A::joDAgather{CDT,ARDT,2},B::joDAdistribute{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.dst_in.dims[2]==B.dst_out.dims[2] || throw(joLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.dst_in,B.dst_out) || throw(joLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    @warn "*($(typeof(A)),$(typeof(B))) is a senseless operation. Get rid of it!"
    return joLinearOperator{BDDT,ARDT}("($(A.name)*$(B.name))",size(A,1),size(B,2),
               v1->v1, v2->v2, v3->v3, v4->v4,
               @joNF, @joNF, @joNF, @joNF)
end
function *(A::joDAgather{CDT,ARDT,2},B::joDAdistributingLinearOperator{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.dst_in.dims[2]==B.nvc || throw(joLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.dst_in,B.dst_out) || throw(joLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    #@info "*($(typeof(A)),$(typeof(B))) is a questionable operation. Try to eliminate it."
    return joLinearOperator{BDDT,ARDT}("($(A.name)*$(B.name))",size(A,1),size(B,2),
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF)
end
function *(A::joDAgatheringLinearOperator{CDT,ARDT,2},B::joDAdistribute{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.dst_out.dims[2] || throw(joLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.dst_in,B.dst_out) || throw(joLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joLinearOperator{BDDT,ARDT}("($(A.name)*$(B.name))",size(A,1),size(B,2),
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF)
end
function *(A::joDAgatheringLinearOperator{CDT,ARDT,2},B::joDAdistributingLinearOperator{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    A.nvc==B.nvc || throw(joLinearOperatorException("*($(A.name),$(B.name)): nvc mismatch"))
    isapprox(A.dst_in,B.dst_out) || throw(joLinearOperatorException("*($(A.name),$(B.name)): distributor mismatch"))
    return joLinearOperator{BDDT,ARDT}("($(A.name)*$(B.name))",size(A,1),size(B,2),
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF)
end
# joDA with joAbstractLinearOperator
function *(A::joDAdistribute{CDT,ARDT,2},B::joAbstractLinearOperator{BDDT,CDT}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    return joDAdistributingLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.dst_out.dims[2],
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               A.dst_out,A.gclean)
end
function *(A::joDAdistributingLinearOperator{CDT,ARDT,2},B::joAbstractLinearOperator{BDDT,CDT}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    return joDAdistributingLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),A.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               A.dst_out,A.gclean)
end
function *(A::joAbstractLinearOperator{CDT,ARDT},B::joDAgather{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    return joDAgatheringLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),B.dst_in.dims[2],
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.dst_in,B.gclean)
end
function *(A::joAbstractLinearOperator{CDT,ARDT},B::joDAgatheringLinearOperator{BDDT,CDT,2}) where {ARDT,BDDT,CDT}
    size(A,2) == size(B,1) || throw(joAbstractLinearOperatorException("*($(A.name),$(B.name)): shape mismatch"))
    return joDAgatheringLinearOperator{BDDT,ARDT,2}("($(A.name)*$(B.name))",size(A,1),size(B,2),B.nvc,
               v1->A*(B*v1),
               v2->transpose(B)*(transpose(A)*v2),
               v3->adjoint(B)*(adjoint(A)*v3),
               v4->conj(A)*(conj(B)*v4),
               @joNF, @joNF, @joNF, @joNF,
               B.dst_in,B.gclean)
end

# *(jo,mvec)
function *(A::joDALinearOperator{ADDT,ARDT,2},mv::DArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joDALinearOperatorException("shape mismatch"))
    A.nvc == size(mv,2) || throw(joDALinearOperatorException("shape mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    isequiv(A.dst_in,mv) || throw(joDALinearOperatorException("*($(A.name),mv::Darray): input distributor mismatch"))
    MV=dalloc(A.dst_out)
    spmd(joDAutils.jo_x_mv!,A.fop,mv,MV,pids=A.dst_out.procs)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joDAdistributingLinearOperator{ADDT,ARDT,2},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joDAdistributingLinearOperatorException("shape mismatch in A$(size(A))*v$(size(mv))"))
    A.nvc == size(mv,2) || throw(joDAdistrbutingLinearOperatorException("nvc size mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joDAgatheringLinearOperator{ADDT,ARDT,2},mv::DArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joDAgatheringLinearOperatorException("shape mismatch in A$(size(A))*v$(size(mv))"))
    A.nvc == size(mv,2) || throw(joDAgatheringLinearOperatorException("nvc size mismatch"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    isequiv(A.dst_in,mv) || throw(joDAgatheringLinearOperatorException("*($(A.name),mv::Darray): input distributor mismatch"))
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
#\{ADDT,ARDT}(A::joAbstractParallelLinearOperator{ADDT,ARDT},a::Number) = inv(a)*A
#\{ADDT,ARDT}(A::joAbstractParallelLinearOperator{ADDT,ARDT},a::joNumber{ADDT,ARDT}) = inv(a)*A

############################################################
## overloaded Base +(...jo...)

# +(jo)
+(A::joAbstractParallelLinearOperator) = A

# +(jo,jo)

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)

# +(num,jo)
+(b::Number,A::joAbstractParallelLinearOperator{ADDT,ARDT}) where {ADDT,ARDT} = A+b
+(b::joNumber{ADDT,ARDT},A::joAbstractParallelLinearOperator{ADDT,ARDT}) where {ADDT,ARDT} = A+b

############################################################
## overloaded Base -(...jo...)

# -(jo)

# -(jo,jo)
-(A::joAbstractParallelLinearOperator,B::joAbstractParallelLinearOperator) = A+(-B)

# -(jo,mvec)

# -(mvec,jo)

# -(jo,vec)

# -(vec,jo)

# -(jo,num)
-(A::joAbstractParallelLinearOperator,b::Number) = A+(-b)
-(A::joAbstractParallelLinearOperator,b::joNumber) = A+(-b)

# -(num,jo)
-(b::Number,A::joAbstractParallelLinearOperator) = -A+b
-(b::joNumber,A::joAbstractParallelLinearOperator) = -A+b

############################################################
## overloaded Base .*(...jo...)

# .*(num,jo)
Base.Broadcast.broadcasted(::typeof(*),a::Number,A::joAbstractParallelLinearOperator) = a*A
Base.Broadcast.broadcasted(::typeof(*),a::joNumber,A::joAbstractParallelLinearOperator) = a*A

# .*(jo,num)
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractParallelLinearOperator,a::Number) = a*A
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractParallelLinearOperator,a::joNumber) = a*A

############################################################
## overloaded Base .\(...jo...)

############################################################
## overloaded Base .+(...jo...)

# .+(jo,num)
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractParallelLinearOperator,b::Number) = A+b
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractParallelLinearOperator,b::joNumber) = A+b

# .+(num,jo)
Base.Broadcast.broadcasted(::typeof(+),b::Number,A::joAbstractParallelLinearOperator) = A+b
Base.Broadcast.broadcasted(::typeof(+),b::joNumber,A::joAbstractParallelLinearOperator) = A+b

############################################################
## overloaded Base .-(...jo...)

# .-(jo,num)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractParallelLinearOperator,b::Number) = A+(-b)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractParallelLinearOperator,b::joNumber) = A+(-b)

# .-(num,jo)
Base.Broadcast.broadcasted(::typeof(-),b::Number,A::joAbstractParallelLinearOperator) = -A+b
Base.Broadcast.broadcasted(::typeof(-),b::joNumber,A::joAbstractParallelLinearOperator) = -A+b

############################################################
## overloaded Base block methods

# hcat(...jo...)

# vcat(...jo...)

# hvcat(...jo...)

############################################################
## overloaded LinearAlgebra functions

# mul!(...,jo,...)

# ldiv!(...,jo,...)

