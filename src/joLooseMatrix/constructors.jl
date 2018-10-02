############################################################
## joLooseMatrix - outer constructors

"""
joLooseMatrix outer constructor

    joLooseMatrix(array::AbstractMatrix;
             DDT::DataType=eltype(array),
             RDT::DataType=promote_type(eltype(array),DDT),
             name::String="joLooseMatrix")

Look up argument names in help to joLooseMatrix type.

# Example
- joLooseMatrix(rand(4,3)) # implicit domain and range
- joLooseMatrix(rand(4,3);DDT=Float32) # implicit range
- joLooseMatrix(rand(4,3);DDT=Float32,RDT=Float64)
- joLooseMatrix(rand(4,3);name="my matrix") # adding name

# Notes
- if DDT:<Real for complex matrix then imaginary part will be neglected for transpose/adjoint operator
- if RDT:<Real for complex matrix then imaginary part will be neglected for forward/conjugate operator

"""
joLooseMatrix(array::AbstractMatrix{EDT};
    DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),name::String="joLooseMatrix") where {EDT} =
        joLooseMatrix{DDT,RDT}(name,size(array,1),size(array,2),
            v1->jo_convert(RDT,array*v1,false),
            v2->jo_convert(DDT,transpose(array)*v2,false),
            v3->jo_convert(DDT,adjoint(array)*v3,false),
            v4->jo_convert(RDT,conj(array)*v4,false),
            v5->jo_convert(DDT,array\v5,false),
            v6->jo_convert(RDT,transpose(array)\v6,false),
            v7->jo_convert(RDT,adjoint(array)\v7,false),
            v8->jo_convert(DDT,conj(array)\v8,false)
            )

joLoosen(A::joMatrix{DDT,RDT}) where {DDT,RDT} =
    joLooseMatrix{DDT,RDT}("joLoosen("*A.name*")",A.m,A.n,
        v1->A.fop(v1),
        v2->A.fop_T(v2),
        v3->A.fop_CT(v3),
        v4->A.fop_C(v4),
        v5->get(A.iop)(v5),
        v6->get(A.iop_T)(v6),
        v7->get(A.iop_CT)(v7),
        v8->get(A.iop_C)(v8)
        )
