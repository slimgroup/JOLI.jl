############################################################
## joDAdistribute/gather - overloaded Base functions

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
@inline conj(A::joDAtoggle) = A

# transpose(jo)
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

