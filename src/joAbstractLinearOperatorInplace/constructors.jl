############################################################
## joAbstractLinearOperatorInplace - outer constructors
############################################################

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

############################################################
## joLooseMatrixInplace - outer constructors

"""
joLooseMatrixInplace outer constructor

    joLooseMatrixInplace(array::AbstractMatrix;
             DDT::DataType=eltype(array),
             RDT::DataType=promote_type(eltype(array),DDT),
             name::String="joLooseMatrixInplace")

Look up argument names in help to joLooseMatrixInplace type.

# Example
- joLooseMatrixInplace(rand(4,3)) # implicit domain and range
- joLooseMatrixInplace(rand(4,3);DDT=Float32) # implicit range
- joLooseMatrixInplace(rand(4,3);DDT=Float32,RDT=Float64)
- joLooseMatrixInplace(rand(4,3);name="my matrix") # adding name

# Notes
- if DDT:<Real for complex matrix then imaginary part will be neglected for transpose/adjoint operator
- if RDT:<Real for complex matrix then imaginary part will be neglected for forward/conjugate operator

"""
function joLooseMatrixInplace(array::AbstractMatrix{EDT};
    DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),name::String="joLooseMatrixInplace") where {EDT}

        (typeof(array)<:DArray || typeof(array)<:SharedArray) && @warn "Creating joLooseMatrixInplace from non-local array like $(typeof(array)) is likely going to have adverse impact on JOLI's health. Please, avoid it."

        farray=factorize(array)
        return joLooseMatrixInplace{DDT,RDT}(name,size(array,1),size(array,2),
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

############################################################
## joLinearFunctionInplace - outer constructors

export joLinearFunctionInplaceAll, joLinearFunctionInplace_T, joLinearFunctionInplace_A,
       joLinearFunctionInplaceFwd, joLinearFunctionInplaceFwd_T, joLinearFunctionInplaceFwd_A


"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplaceAll(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
        iop::Function,iop_T::Function,iop_A::Function,iop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplaceAll")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplaceAll(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
    iop::Function,iop_T::Function,iop_A::Function,iop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceAll") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop,fop_T,fop_A,fop_C,
            iop,iop_T,iop_A,iop_C
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplace_T(m::Integer,n::Integer,
        fop::Function,fop_T::Function, iop::Function,iop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplace_T")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplace_T(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplace_T") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, fop_T, @joNF, @joNF,
            iop, iop_T, @joNF, @joNF
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplace_A(m::Integer,n::Integer,
        fop::Function,fop_A::Function, iop::Function,iop_A::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplace_A")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplace_A(m::Integer,n::Integer,
    fop::Function,fop_A::Function, iop::Function,iop_A::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplace_A") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, @joNF, fop_A, @joNF,
            iop, @joNF, iop_A, @joNF
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplaceFwd(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplaceAll")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplaceFwd(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceAll") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop,fop_T,fop_A,fop_C,
            @joNF, @joNF, @joNF, @joNF
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplaceFwd_T(m::Integer,n::Integer,
        fop::Function,fop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplaceFwd_T")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplaceFwd_T(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceFwd_T") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, fop_T, @joNF, @joNF,
            @joNF, @joNF, @joNF, @joNF
            )
"""
joLinearFunctionInplace outer constructor

    joLinearFunctionInplaceFwd_A(m::Integer,n::Integer,
        fop::Function,fop_A::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLinearFunctionInplaceFwd_A")

Look up argument names in help to joLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLinearFunctionInplaceFwd_A(m::Integer,n::Integer,
    fop::Function,fop_A::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceFwd_A") =
        joLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, @joNF, fop_A, @joNF,
            @joNF, @joNF, @joNF, @joNF
            )

############################################################
## joLooseLinearFunctionInplace - outer constructors

export joLooseLinearFunctionInplaceAll, joLooseLinearFunctionInplace_T, joLooseLinearFunctionInplace_A,
       joLooseLinearFunctionInplaceFwd, joLooseLinearFunctionInplaceFwd_T, joLooseLinearFunctionInplaceFwd_A


"""
joLooseLinearFunctionInplace outer constructor

    joLooseLinearFunctionInplaceAll(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
        iop::Function,iop_T::Function,iop_A::Function,iop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplaceAll")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplaceAll(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
    iop::Function,iop_T::Function,iop_A::Function,iop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceAll") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop,fop_T,fop_A,fop_C,
            iop,iop_T,iop_A,iop_C
            )
"""
joLooseLinearFunctionInplace outer constructor

    joLooseLinearFunctionInplace_T(m::Integer,n::Integer,
        fop::Function,fop_T::Function, iop::Function,iop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplace_T")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplace_T(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplace_T") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, fop_T, @joNF, @joNF,
            iop, iop_T, @joNF, @joNF
            )
"""
joLooseLinearFunctionInplace outer constructor

    joLooseLinearFunctionInplace_A(m::Integer,n::Integer,
        fop::Function,fop_A::Function, iop::Function,iop_A::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplace_A")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplace_A(m::Integer,n::Integer,
    fop::Function,fop_A::Function, iop::Function,iop_A::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplace_A") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, @joNF, fop_A, @joNF,
            iop, @joNF, iop_A, @joNF
            )
"""
joLooseLinearFunctionInplace outer constructor

    joLooseLinearFunctionInplaceFwd(m::Integer,n::Integer,
        fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplaceAll")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplaceFwd(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_A::Function,fop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceAll") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop,fop_T,fop_A,fop_C,
            @joNF, @joNF, @joNF, @joNF
            )
"""
joLooseLinearFunctionInplace outer constructor

    joLooseLinearFunctionInplaceFwd_T(m::Integer,n::Integer,
        fop::Function,fop_T::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplaceFwd_T")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplaceFwd_T(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceFwd_T") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, fop_T, @joNF, @joNF,
            @joNF, @joNF, @joNF, @joNF
            )
"""
joLooseLinearFunctionInplace outer constructor

    joLooseLinearFunctionInplaceFwd_A(m::Integer,n::Integer,
        fop::Function,fop_A::Function,
        DDT::DataType,RDT::DataType=DDT;
        name::String="joLooseLinearFunctionInplaceFwd_A")

Look up argument names in help to joLooseLinearFunctionInplace type.

# Notes
- the developer is responsible for ensuring that used functions provide correct DDT & RDT

"""
joLooseLinearFunctionInplaceFwd_A(m::Integer,n::Integer,
    fop::Function,fop_A::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceFwd_A") =
        joLooseLinearFunctionInplace{DDT,RDT}(name,m,n,
            fop, @joNF, fop_A, @joNF,
            @joNF, @joNF, @joNF, @joNF
            )

