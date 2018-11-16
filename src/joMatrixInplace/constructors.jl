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

        (typeof(array)<:DArray || typeof(array)<:SharedArray) && @warn "Creating joMatrixInplace from non-local array like $(typeof(array)) is likely going to have adverse impact on JOLI's health. Please, avoid it."

        farray=factorize(array)
        return joMatrixInplace{DDT,RDT}(name,size(array,1),size(array,2),
            (y1,x1)->mul!(y1,array,x1),
            (y2,x2)->mul!(y2,transpose(array),x2),
            (y3,x3)->mul!(y3,adjoint(array),x3),
            (y4,x4)->mul!(y4,conj(array),x4),
            (y5,x5)->ldiv!(y5,farray,x5),
            (y6,x6)->ldiv!(y6,transpose(farray),x6),
            (y7,x7)->ldiv!(y7,adjoint(farray),x7),
            (y8,x8)->ldiv!(y8,factorize(conj(array)),x8),
            )
end

