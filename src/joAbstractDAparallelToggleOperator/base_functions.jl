############################################################
## joDAdistribute/gather - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractDAparallelToggleOperator{DDT,RDT}) where {DDT,RDT} = promote_type(DDT,RDT)

# deltype(jo)
deltype(A::joAbstractDAparallelToggleOperator{DDT,RDT}) where {DDT,RDT} = DDT

# reltype(jo)
reltype(A::joAbstractDAparallelToggleOperator{DDT,RDT}) where {DDT,RDT} = RDT

# show(jo)
show(A::joAbstractDAparallelToggleOperator) = println((typeof(A),A.name,(A.m,A.n),A.nvc))

# display(jo)
display(A::joAbstractDAparallelToggleOperator) = show(A)

# size(jo)
size(A::joAbstractDAparallelToggleOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joAbstractDAparallelToggleOperator,ind::Integer)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	else
		throw(joAbstractDAparallelToggleOperatorException("invalid index"))
	end
end

# length(jo)
length(A::joAbstractDAparallelToggleOperator) = A.m*A.n

# jo_full(jo)

# norm(jo)

# real(jo)

# imag(jo)

# conj(jo)
conj(A::joAbstractDAparallelToggleOperator) = A

# transpose(jo)
transpose(A::joDAdistribute{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAgather{RDT,DDT,N}("regather($(A.name))",A.n,A.m,A.nvc,
        A.fop_T, A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_out, A.gclean)
transpose(A::joDAgather{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAdistribute{RDT,DDT,N}("redistribute($(A.name))",A.n,A.m,A.nvc,
        A.fop_T, A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_in, A.gclean)

# adjoint(jo)
adjoint(A::joAbstractDAparallelToggleOperator) = transpose(A)

# isreal(jo)

# issymmetric(jo)

# ishermitian(jo)

# getindex(jo,...)

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)

# *(jo,mvec)
function *(A::joDAdistribute{ADDT,ARDT,2},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joAbstractDAparallelToggleOperatorException("joDAdistributeMV: shape mismatch A$(size(A))*v$(size(mv))"))
    A.PAs_out.dims==size(mv) || throw(joAbstractDAparallelToggleOperatorException("joDAdistributeMV: shape mismatch dst$(A.PAs_out.dims)*v$(size(mv))"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joDAgather{ADDT,ARDT,2},mv::DArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joAbstractDAparallelToggleOperatorException("joDAgatherMV: shape mismatch A$(size(A))*v$(size(mv))"))
    A.PAs_in.dims==size(mv) || throw(joAbstractDAparallelToggleOperatorException("joDAgatherMV: shape mismatch dst$(A.PAs_in.dims)*v$(size(mv))"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    isequiv(A.PAs_in,mv) || throw(joAbstractDAparallelToggleOperatorException("*($(A.name),mv::Darray): input distributor mismatch"))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
# in joAbstractDMVparallelLinearOperator/base_functions.jl
#function *(A::joDAdistribute{CDT,ARDT,2},B::joAbstractLinearOperator{BDDT,CDT}) where {ARDT,BDDT,CDT}
#function *(A::joAbstractLinearOperator{CDT,ARDT},B::joDAgather{BDDT,CDT,2}) where {ARDT,BDDT,CDT}

# *(mvec,jo)

# *(jo,vec)
function *(A::joDAdistribute{ADDT,ARDT,1},v::LocalVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joAbstractDAparallelToggleOperatorException("joDAdistributeV: shape mismatch A$(size(A))*v$(size(v))"))
    A.PAs_out.dims==size(v) || throw(joAbstractDAparallelToggleOperatorException("joDAdistributeV: shape mismatch dst$(A.PAs_out.dims)*v$(size(v))"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end
function *(A::joDAgather{ADDT,ARDT,1},v::DArray{vDT,1}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joAbstractDAparallelToggleOperatorException("joDAgatherV: shape mismatch A$(size(A))*v$(size(v))"))
    A.PAs_in.dims==size(v) || throw(joAbstractDAparallelToggleOperatorException("joDAgatherV: shape mismatch dst$(A.PAs_in.dims)*v$(size(v))"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end

# *(vec,jo)

# *(num,jo)

# *(jo,num)

