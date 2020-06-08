############################################################
## joSAdistribute/gather - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractSAparallelToggleOperator{DDT,RDT}) where {DDT,RDT} = promote_type(DDT,RDT)

# deltype(jo)
deltype(A::joAbstractSAparallelToggleOperator{DDT,RDT}) where {DDT,RDT} = DDT

# reltype(jo)
reltype(A::joAbstractSAparallelToggleOperator{DDT,RDT}) where {DDT,RDT} = RDT

# show(jo)
function show(A::joAbstractSAparallelToggleOperator)
    println("Type: $(typeof(A).name)")
    println("Name: $(A.name)")
    println("Size: $(size(A))")
    println(" NVC: $(A.nvc)")
    println(" DDT: $(deltype(A))")
    println(" RDT: $(reltype(A))")
    return nothing
end

# display(jo)
display(A::joAbstractSAparallelToggleOperator) = println((typeof(A),((A.m,A.n),A.nvc),A.name))

# size(jo)
size(A::joAbstractSAparallelToggleOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joAbstractSAparallelToggleOperator,ind::Integer)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	else
		throw(joAbstractSAparallelToggleOperatorException("invalid index"))
	end
end

# length(jo)
length(A::joAbstractSAparallelToggleOperator) = A.m*A.n

# jo_full(jo)

# norm(jo)

# real(jo)

# imag(jo)

# conj(jo)
conj(A::joAbstractSAparallelToggleOperator) = A

# transpose(jo)
transpose(A::joSAdistribute{DDT,RDT,N}) where {DDT,RDT,N} =
    joSAgather{RDT,DDT,N}("regather($(A.name))",A.n,A.m,A.nvc,
        A.fop_T, A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_out, A.gclean)
transpose(A::joSAgather{DDT,RDT,N}) where {DDT,RDT,N} =
    joSAdistribute{RDT,DDT,N}("redistribute($(A.name))",A.n,A.m,A.nvc,
        A.fop_T, A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.PAs_in, A.gclean)

# adjoint(jo)
adjoint(A::joAbstractSAparallelToggleOperator) = transpose(A)

# isreal(jo)

# issymmetric(jo)

# ishermitian(jo)

# getindex(jo,...)

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)

# *(jo,mvec)
function *(A::joSAdistribute{ADDT,ARDT,2},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joAbstractSAparallelToggleOperatorException("joSAdistributeMV: shape mismatch A$(size(A))*v$(size(mv))"))
    A.PAs_out.dims==size(mv) || throw(joAbstractSAparallelToggleOperatorException("joSAdistributeMV: shape mismatch dst$(A.PAs_out.dims)*v$(size(mv))"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joSAgather{ADDT,ARDT,2},mv::SharedArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joAbstractSAparallelToggleOperatorException("joSAgatherMV: shape mismatch A$(size(A))*v$(size(mv))"))
    A.PAs_in.dims==size(mv) || throw(joAbstractSAparallelToggleOperatorException("joSAgatherMV: shape mismatch dst$(A.PAs_in.dims)*v$(size(mv))"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    isequiv(A.PAs_in,mv) || throw(joAbstractSAparallelToggleOperatorException("*($(A.name),mv::Darray): input distributor mismatch"))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
# in joAbstractSAparallelLinearOperator/base_functions.jl
#function *(A::joSAdistribute{CDT,ARDT,2},B::joAbstractLinearOperator{BDDT,CDT}) where {ARDT,BDDT,CDT}
#function *(A::joAbstractLinearOperator{CDT,ARDT},B::joSAgather{BDDT,CDT,2}) where {ARDT,BDDT,CDT}

# *(mvec,jo)

# *(jo,vec)
function *(A::joSAdistribute{ADDT,ARDT,1},v::LocalVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joAbstractSAparallelToggleOperatorException("joSAdistributeV: shape mismatch A$(size(A))*v$(size(v))"))
    A.PAs_out.dims==size(v) || throw(joAbstractSAparallelToggleOperatorException("joSAdistributeV: shape mismatch dst$(A.PAs_out.dims)*v$(size(v))"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end
function *(A::joSAgather{ADDT,ARDT,1},v::SharedArray{vDT,1}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joAbstractSAparallelToggleOperatorException("joSAgatherV: shape mismatch A$(size(A))*v$(size(v))"))
    A.PAs_in.dims==size(v) || throw(joAbstractSAparallelToggleOperatorException("joSAgatherV: shape mismatch dst$(A.PAs_in.dims)*v$(size(v))"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end

# *(vec,jo)

# *(num,jo)

# *(jo,num)

