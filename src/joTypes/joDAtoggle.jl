############################################################
# joDAdistribute #########################################
############################################################

export joDAdistributeV, joDAgatherV, joDAdistributeMV, joDAgatherMV, joDAtoggleException

# type definition
"""
    joDAdistribute(V/MV) is DAarray toggle type & constructor

    !!! Do not use it to create the operators
    !!! Use joMatrix and joLinearFunction constructors

"""
struct joDAdistributeV{DDT<:Number,RDT<:Number} <: joAbstractLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function    # forward
    fop_T::Function  # transpose
    fop_A::Function  # adjoint
    fop_C::Function  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    dst::joDAdistributor
end
struct joDAdistributeMV{DDT<:Number,RDT<:Number} <: joAbstractLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function    # forward
    fop_T::Function  # transpose
    fop_A::Function  # adjoint
    fop_C::Function  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    dst::joDAdistributor
end
const joDAdistribute{D,T}=Union{joDAdistributeV{D,T},joDAdistributeMV{D,T}} where {D,T}
"""
    joDAgather(V/MV) is DAarray toggle type & constructor

    !!! Do not use it to create the operators
    !!! Use joMatrix and joLinearFunction constructors

"""
struct joDAgatherV{DDT<:Number,RDT<:Number} <: joAbstractLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function    # forward
    fop_T::Function  # transpose
    fop_A::Function  # adjoint
    fop_C::Function  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    dst::joDAdistributor
end
struct joDAgatherMV{DDT<:Number,RDT<:Number} <: joAbstractLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    fop::Function    # forward
    fop_T::Function  # transpose
    fop_A::Function  # adjoint
    fop_C::Function  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    dst::joDAdistributor
end
const joDAgather{D,T}=Union{joDAgatherV{D,T},joDAgatherMV{D,T}} where {D,T}

# toggle unions
const joDAtoggleV{D,T}=Union{joDAdistributeV{D,T},joDAgatherV{D,T}} where {D,T}
const joDAtoggleMV{D,T}=Union{joDAdistributeMV{D,T},joDAgatherMV{D,T}} where {D,T}
const joDAtoggle{D,T}=Union{joDAtoggleV{D,T},joDAtoggleMV{D,T}} where {D,T}

# type exception
struct joDAtoggleException <: Exception
    msg :: String
end

