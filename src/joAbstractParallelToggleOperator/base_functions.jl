############################################################
## joDAdistribute/gather - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractParallelToggleOperator{DDT,RDT}) where {DDT,RDT} = promote_type(DDT,RDT)

# deltype(jo)
deltype(A::joAbstractParallelToggleOperator{DDT,RDT}) where {DDT,RDT} = DDT

# reltype(jo)
reltype(A::joAbstractParallelToggleOperator{DDT,RDT}) where {DDT,RDT} = RDT

# show(jo)
show(A::joAbstractParallelToggleOperator) = println((typeof(A),A.name,A.m,A.n))

# display(jo)
display(A::joAbstractParallelToggleOperator) = show(A)
function display(d::joDAdistributor)
    println("joDAdistributor: ",d.name)
    println(" DataType: ",d.DT)
    println(" Dims    : ",d.dims)
    println(" Chunks  : ",d.chunks)
    println(" Workers : ",d.procs)
    for i=1:length(d.procs)
        @printf "  Worker/ranges: %3d " d.procs[i]
        println(d.idxs[i])
    end
end

# size(jo)
size(A::joAbstractParallelToggleOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joAbstractParallelToggleOperator,ind::Integer)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	else
		throw(joAbstractParallelToggleOperatorException("invalid index"))
	end
end

# length(jo)
length(A::joAbstractParallelToggleOperator) = A.m*A.n

# jo_full(jo)

# norm(jo)

# real(jo)

# imag(jo)

# conj(jo)
@inline conj(A::joDAtoggle) = A

# transpose(jo)
function transpose(in::joDAdistributor)
    dims=reverse(in.dims)
    length(dims)==2 || throw(joDAdistributorException("joDAdistributor: transpose(joDAdistributor) makes sense only for 2D distributed arrays"))
    nlabs=length(in.procs)
    ddim=findfirst(i->i>1,in.chunks)
    ldim=findlast(i->i>1,in.chunks)
    ddim==ldim || throw(joDAdistributorException("joDAdistributor: cannot transpose and array with more then one distributed dimension"))
    parts=joDAdistributor_etc.balanced_partition(nlabs,dims[ddim])
    return joDAdistributor(dims,ddim,DT=in.DT,parts=parts,name="transpose($(in.name))")
end
transpose(A::joDAdistributeV{DDT,RDT}) where {DDT,RDT} =
    joDAgatherV{RDT,DDT}("regather($(A.name))",A.n,A.m,
        A.fop_T, A.fop, A.fop_C, A.fop_A, A.iop_T, A.iop, A.iop_C, A.iop_A, A.dst)
transpose(A::joDAdistributeMV{DDT,RDT}) where {DDT,RDT} =
    joDAgatherMV{RDT,DDT}("regather($(A.name))",A.n,A.m,
        A.fop_T, A.fop, A.fop_C, A.fop_A, A.iop_T, A.iop, A.iop_C, A.iop_A, A.dst)
transpose(A::joDAgatherV{DDT,RDT}) where {DDT,RDT} =
    joDAdistributeV{RDT,DDT}("redistribute($(A.name))",A.n,A.m,
        A.fop_T, A.fop, A.fop_C, A.fop_A, A.iop_T, A.iop, A.iop_C, A.iop_A, A.dst)
transpose(A::joDAgatherMV{DDT,RDT}) where {DDT,RDT} =
    joDAdistributeMV{RDT,DDT}("redistribute($(A.name))",A.n,A.m,
        A.fop_T, A.fop, A.fop_C, A.fop_A, A.iop_T, A.iop, A.iop_C, A.iop_A, A.dst)

# adjoint(jo)
@inline adjoint(A::joDAtoggle) = transpose(A)

# isreal(jo)

# issymmetric(jo)

# ishermitian(jo)

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)

# *(jo,mvec)
function *(A::joDAdistributeMV{ADDT,ARDT},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joDAtoggleException("joDAdistributeMV: shape mismatch A$(size(A))*v$(size(mv))"))
    A.dst.dims==size(mv) || throw(joDAtoggleException("sjoDAdistributeMV: hape mismatch dst$(A.dst.dims)*v$(size(mv))"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joDAgatherMV{ADDT,ARDT},mv::DArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joDAtoggleException("joDAgatherMV: shape mismatch A$(size(A))*v$(size(mv))"))
    A.dst.dims==size(mv) || throw(joDAtoggleException("joDAgatherMV: hape mismatch dst$(A.dst.dims)*v$(size(mv))"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end

# *(mvec,jo)

# *(jo,vec)
function *(A::joDAdistributeV{ADDT,ARDT},v::LocalVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joDAtoggleException("joDAdistributeV: shape mismatch A$(size(A))*v$(size(v))"))
    A.dst.dims==size(v) || throw(joDAtoggleException("joDAdistributeV: shape mismatch dst$(A.dst.dims)*v$(size(v))"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end
function *(A::joDAgatherV{ADDT,ARDT},v::DArray{vDT,1}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joDAtoggleException("joDAgatherV: shape mismatch A$(size(A))*v$(size(v))"))
    A.dst.dims==size(v) || throw(joDAtoggleException("joDAgatherV: shape mismatch dst$(A.dst.dims)*v$(size(v))"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end

# *(vec,jo)

# *(num,jo)

# *(jo,num)

