############################################################
## types supporting conversion from local to SA arrays #####
############################################################

############################################################
# joSA{distribute,gather} ##################################

export joSAdistribute, joSAgather

# type definition
"""
    joSAdistribute is SharedArray toggle type & constructor

    !!! Do not use it to create the operators

"""
struct joSAdistribute{DDT<:Number,RDT<:Number,N} <: joAbstractSAparallelToggleOperator{DDT,RDT,N}
    name::String
    m::Integer
    n::Integer
    nvc::Integer
    fop::Function    # forward
    fop_T::Function  # transpose
    fop_A::Function  # adjoint
    fop_C::Function  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    PAs_out::joPAsetup  # output distributor
    gclean::Bool        # clean input vector post gathering
end
"""
    joSAgather is SharedArray toggle type & constructor

    !!! Do not use it to create the operators

"""
struct joSAgather{DDT<:Number,RDT<:Number,N} <: joAbstractSAparallelToggleOperator{DDT,RDT,N}
    name::String
    m::Integer
    n::Integer
    nvc::Integer
    fop::Function    # forward
    fop_T::Function  # transpose
    fop_A::Function  # adjoint
    fop_C::Function  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    PAs_in::joPAsetup  # input distributor
    gclean::Bool       # clean input vector post gathering
end

