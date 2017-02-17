############################################################
## joMatrix - outer constructors

"""
joMatrix outer constructor

    joMatrix(array::AbstractMatrix,DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT);name::String="joMatrix")

# Example
- joMatrix(rand(4,3)) # implicit domain and range
- joMatrix(rand(4,3),Float32) # implicit range
- joMatrix(rand(4,3),Float32,Float64)
- joMatrix(rand(4,3);name="my matrix") # adding name

"""
joMatrix{EDT}(array::AbstractMatrix{EDT},DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT);name::String="joMatrix") =
    joMatrix{EDT,DDT,RDT}(name,size(array,1),size(array,2),
        v1->array*v1,
        v2->array.'*v2,
        v3->array'*v3,
        v4->conj(array)*v4,
        v5->array\v5,
        v6->array.'\v6,
        v7->array'\v7,
        v8->conj(array)\v8
        )

