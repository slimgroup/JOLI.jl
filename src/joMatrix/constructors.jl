############################################################
## joMatrix - outer constructors

"""
joMatrix outer constructor

    joMatrix(array::AbstractMatrix;DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),name::String="joMatrix",getcopy::Bool=false)

# Example
- joMatrix(rand(4,3)) # implicit domain and range
- joMatrix(rand(4,3);DDT=Float32) # implicit range
- joMatrix(rand(4,3);DDT=Float32,RDT=Float64)
- joMatrix(rand(4,3);name="my matrix") # adding name
- joMatrix(rand(4,3);getcopy=false) # do not make deep copy of input array

# Notes
- if DDT:<Real for complex matrix then imaginary part will be neglected for transpose/conjugated-transpose operator
- if RDT:<Real for complex matrix then imaginary part will be neglected for forward/conjugate operator

"""
function joMatrix{EDT}(array::AbstractMatrix{EDT};DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),name::String="joMatrix",getcopy::Bool=true)
    Array= getcopy ? Base.deepcopy(array) : array
    joMatrix{EDT,DDT,RDT}(name,size(Array,1),size(Array,2),
        v1->jo_convert(RDT,Array*v1,false),
        v2->jo_convert(DDT,Array.'*v2,false),
        v3->jo_convert(DDT,Array'*v3,false),
        v4->jo_convert(RDT,conj(Array)*v4,false),
        v5->jo_convert(DDT,Array\v5,false),
        v6->jo_convert(RDT,Array.'\v6,false),
        v7->jo_convert(RDT,Array'\v7,false),
        v8->jo_convert(DDT,conj(Array)\v8,false)
        )
end
