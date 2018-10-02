############################################################
## joMatrixInplace - outer constructors

"""
joMatrixInplace outer constructor

    joMatrixInplace(array::AbstractMatrix;
             DDT::DataType=eltype(array),
             RDT::DataType=promote_type(eltype(array),DDT),
             name::String="joMatrixInplace")

Look up argument names in help to joMatrixInplace type.

# Example
- joMatrixInplace(rand(4,3)) # implicit domain and range
- joMatrixInplace(rand(4,3);DDT=Float32) # implicit range
- joMatrixInplace(rand(4,3);DDT=Float32,RDT=Float64)
- joMatrixInplace(rand(4,3);name="my matrix") # adding name

# Notes
- if DDT:<Real for complex matrix then imaginary part will be neglected for transpose/adjoint operator
- if RDT:<Real for complex matrix then imaginary part will be neglected for forward/conjugate operator

"""
function joMatrixInplace(array::AbstractMatrix{EDT};
    DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),name::String="joMatrixInplace") where {EDT}
        farray=factorize(array)
        return joMatrixInplace{DDT,RDT}(name,size(array,1),size(array,2),
            (y1,x1)->A_mul_B!(y1,array,x1),
            (y2,x2)->At_mul_B!(y2,array,x2),
            (y3,x3)->Ac_mul_B!(y3,array,x3),
            (y5,x5)->A_ldiv_B!(y5,farray,x5),
            (y6,x6)->At_ldiv_B!(y6,farray,x6),
            (y7,x7)->Ac_ldiv_B!(y7,farray,x7),
            )
end

