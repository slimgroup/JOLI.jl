# JOLI reference

```@contents
```

## Types
```@docs
joMatrix
joLinearFunction
joLinearOperator
joNumber
```

##  Constructors

```@docs
joMatrix{EDT}(array::AbstractMatrix{EDT};DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),name::String="joMatrix")
joLinearFunctionAll(m::Integer,n::Integer, fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function, iop::Function,iop_T::Function,iop_CT::Function,iop_C::Function, DDT::DataType,RDT::DataType=DDT; name::String="joLinearFunctionAll")
joLinearFunctionT(m::Integer,n::Integer, fop::Function,fop_T::Function, iop::Function,iop_T::Function, DDT::DataType,RDT::DataType=DDT; name::String="joLinearFunctionT")
joLinearFunctionCT(m::Integer,n::Integer, fop::Function,fop_CT::Function, iop::Function,iop_CT::Function, DDT::DataType,RDT::DataType=DDT; name::String="joLinearFunctionCT")
joLinearFunctionFwdT(m::Integer,n::Integer, fop::Function,fop_T::Function, DDT::DataType,RDT::DataType=DDT; name::String="joLinearFunctionFwdT")
joLinearFunctionFwdCT(m::Integer,n::Integer, fop::Function,fop_CT::Function, DDT::DataType,RDT::DataType=DDT; name::String="joLinearFunctionFwdCT")
joNumber{NT<:Number}(num::NT)
joNumber{NT<:Number,DDT,RDT}(num::NT,A::joAbstractLinearOperator{DDT,RDT})
```

## Functions

```@docs
```

## Macros
```@docs
@joNF()
@joNF(fun::Expr)
```

## Index

```@index
```
