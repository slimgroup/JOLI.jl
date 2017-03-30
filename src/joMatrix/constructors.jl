############################################################
## joMatrix - outer constructors

"""
joMatrix outer constructor

    joMatrix(array::AbstractMatrix;
             DDT::DataType=eltype(array),
             RDT::DataType=promote_type(eltype(array),DDT),
             name::String="joMatrix")

Look up argument names in help to joMatrix type.

# Example
- joMatrix(rand(4,3)) # implicit domain and range
- joMatrix(rand(4,3);DDT=Float32) # implicit range
- joMatrix(rand(4,3);DDT=Float32,RDT=Float64)
- joMatrix(rand(4,3);name="my matrix") # adding name

# Notes
- if DDT:<Real for complex matrix then imaginary part will be neglected for transpose/conjugated-transpose operator
- if RDT:<Real for complex matrix then imaginary part will be neglected for forward/conjugate operator

"""
joMatrix{EDT}(array::AbstractMatrix{EDT};
    DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),name::String="joMatrix") =
        joMatrix{DDT,RDT}(name,size(array,1),size(array,2),
            v1->jo_convert(RDT,array*v1,false),
            v2->jo_convert(DDT,array.'*v2,false),
            v3->jo_convert(DDT,array'*v3,false),
            v4->jo_convert(RDT,conj(array)*v4,false),
            v5->jo_convert(DDT,array\v5,false),
            v6->jo_convert(RDT,array.'\v6,false),
            v7->jo_convert(RDT,array'\v7,false),
            v8->jo_convert(DDT,conj(array)\v8,false)
            )

