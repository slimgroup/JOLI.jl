############################################################
## joMatrix - outer constructors

"""
joMatrix outer constructor

    joMatrix(m::AbstractMatrix;DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),name::String="joMatrix",makecopy::Bool=false)

# Example
- joMatrix(rand(4,3)) # implicit domain and range
- joMatrix(rand(4,3);DDT=Float32) # implicit range
- joMatrix(rand(4,3);DDT=Float32,RDT=Float64)
- joMatrix(rand(4,3);name="my matrix") # adding name
- joMatrix(rand(4,3);makecopy=true) # make deep copy of input m

# Notes
- if DDT:<Real for complex matrix then imaginary part will be neglected for transpose/conjugated-transpose operator
- if RDT:<Real for complex matrix then imaginary part will be neglected for forward/conjugate operator

"""
function joMatrix{EDT}(m::AbstractMatrix{EDT};DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),name::String="joMatrix",makecopy::Bool=false)
    mc= makecopy ? Base.deepcopy(m) : m
    return joMatrix{EDT,DDT,RDT}(name,size(mc,1),size(mc,2),
        v1->jo_convert(RDT,mc*v1,false),
        v2->jo_convert(DDT,mc.'*v2,false),
        v3->jo_convert(DDT,mc'*v3,false),
        v4->jo_convert(RDT,conj(mc)*v4,false),
        v5->jo_convert(DDT,mc\v5,false),
        v6->jo_convert(RDT,mc.'\v6,false),
        v7->jo_convert(RDT,mc'\v7,false),
        v8->jo_convert(DDT,conj(mc)\v8,false)
        )
end

