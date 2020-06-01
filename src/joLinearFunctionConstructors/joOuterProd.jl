# joOuterProd

## helper module
module joOuterProd_etc

    using JOLI: LocalVecOrMat

    @inline frwrd(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Complex,VDT<:Complex,xDT<:Number} = U*(adjoint(V)*x)
    @inline frwrd(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Complex,VDT<:Real,xDT<:Number} = U*(transpose(V)*x)
    @inline frwrd(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Real,VDT<:Complex,xDT<:Number} = U*(adjoint(V)*x)
    @inline frwrd(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Real,VDT<:Real,xDT<:Number} = U*(transpose(V)*x)

    @inline trnsp(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Complex,VDT<:Complex,xDT<:Number} = conj(V)*(transpose(U)*x)
    @inline trnsp(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Complex,VDT<:Real,xDT<:Number} = V*(transpose(U)*x)
    @inline trnsp(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Real,VDT<:Complex,xDT<:Number} = conj(V)*(transpose(U)*x)
    @inline trnsp(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Real,VDT<:Real,xDT<:Number} = V*(transpose(U)*x)

    @inline adjnt(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Complex,VDT<:Complex,xDT<:Number} = V*(adjoint(U)*x)
    @inline adjnt(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Complex,VDT<:Real,xDT<:Number} = V*(adjoint(U)*x)
    @inline adjnt(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Real,VDT<:Complex,xDT<:Number} = V*(transpose(U)*x)
    @inline adjnt(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Real,VDT<:Real,xDT<:Number} = V*(transpose(U)*x)

    @inline cnjgt(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Complex,VDT<:Complex,xDT<:Number} = conj(U)*(transpose(V)*x)
    @inline cnjgt(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Complex,VDT<:Real,xDT<:Number} = conj(U)*(transpose(V)*x)
    @inline cnjgt(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Real,VDT<:Complex,xDT<:Number} = U*(transpose(V)*x)
    @inline cnjgt(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT},x::LocalVecOrMat{xDT}) where
        {UDT<:Real,VDT<:Real,xDT<:Number} = U*(transpose(V)*x)

end
using .joOuterProd_etc

export joOuterProd
"""
    julia> op = joOuterProd(U,V;[DDT=...,][RDT=...,][name=...])

Memory efficient implementation of operator A = U*V'

# Signature

    joOuterProd(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT};
        DDT::DataType=joFloat,RDT::DataType=promote_type(UDT,VDT,DDT),name::String="joOuterProd")
            where {UDT<:Number,VDT<:Number}

# Arguments

- `U`: left vector or matrix
- `V`: right vector or matrix
- keywords
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Notes

- 2nd dimension of U and V must match

# Examples

    A=joOuterProd(rand(4),rand(5))
    A=joOuterProd(rand(4,2),rand(5,2))

examples with DDT/RDT

    A=joOuterProd(rand(4),rand(5); DDT=Float32)
    A=joOuterProd(rand(4),rand(5); DDT=Float32,RDT=Float64)

"""
function joOuterProd(U::LocalVecOrMat{UDT},V::LocalVecOrMat{VDT};
    DDT::DataType=joFloat,RDT::DataType=promote_type(UDT,VDT,DDT),name::String="joOuterProd") where {UDT<:Number,VDT<:Number}

    size(U,2)==size(V,2) || throw(joLinearFunctionException("joOuterProd: 2nd dimension of U & V must match"))
    m = size(U,1); n=size(V,1);

    return joLinearFunctionFwd(m,n,
        v1->jo_convert(RDT,joOuterProd_etc.frwrd(U,V,v1),false),
        v2->jo_convert(DDT,joOuterProd_etc.trnsp(U,V,v2),false),
        v3->jo_convert(DDT,joOuterProd_etc.adjnt(U,V,v3),false),
        v4->jo_convert(RDT,joOuterProd_etc.cnjgt(U,V,v4),false),
        DDT,RDT;
        name=name,
        fMVok=true
        )

end

