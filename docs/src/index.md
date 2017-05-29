# JOLI reference

```@contents
Depth = 3
```

##  Constructors

### Matrix-based operators

```@docs
joMatrix{EDT}(array::AbstractMatrix{EDT};DDT::DataType=EDT,RDT::DataType=promote_type(EDT,DDT),name::String="joMatrix")
joSincInterp{T<:AbstractFloat,I<:Integer}(xin::AbstractArray{T,1},xout::AbstractArray{T,1};r::I=0)
```

### Function-based operators

```@docs
joLinearFunctionAll(m::Integer,n::Integer,fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,iop::Function,iop_T::Function,iop_CT::Function,iop_C::Function,DDT::DataType,RDT::DataType=DDT;fMVok::Bool=false,iMVok::Bool=false,name::String="joLinearFunctionAll")
joLinearFunctionT(m::Integer,n::Integer,fop::Function,fop_T::Function,iop::Function,iop_T::Function,DDT::DataType,RDT::DataType=DDT;fMVok::Bool=false,iMVok::Bool=false,name::String="joLinearFunctionT")
joLinearFunctionCT(m::Integer,n::Integer,fop::Function,fop_CT::Function,iop::Function,iop_CT::Function,DDT::DataType,RDT::DataType=DDT;fMVok::Bool=false,iMVok::Bool=false,name::String="joLinearFunctionCT")
joLinearFunctionFwdT(m::Integer,n::Integer,fop::Function,fop_T::Function,DDT::DataType,RDT::DataType=DDT;fMVok::Bool=false,iMVok::Bool=false,name::String="joLinearFunctionFwdT")
joLinearFunctionFwdCT(m::Integer,n::Integer,fop::Function,fop_CT::Function,DDT::DataType,RDT::DataType=DDT;fMVok::Bool=false,iMVok::Bool=false,name::String="joLinearFunctionFwdCT")
```

### Composite operators

```@docs
joKron(ops::joAbstractLinearOperator...)
joBlockDiag{WDT<:Number}(ops::joAbstractLinearOperator...;weights::AbstractVector{WDT}=zeros(0),name::String="joBlockDiag")
joBlockDiag{WDT<:Number}(l::Integer,op::joAbstractLinearOperator;weights::AbstractVector{WDT}=zeros(0),name::String="joBlockDiag")
joDict{WDT<:Number}(ops::joAbstractLinearOperator...;weights::AbstractVector{WDT}=zeros(0),name::String="joDict")
joDict{WDT<:Number}(l::Integer,op::joAbstractLinearOperator;weights::AbstractVector{WDT}=zeros(0),name::String="joDict")
joStack{WDT<:Number}(ops::joAbstractLinearOperator...;weights::AbstractVector{WDT}=zeros(0),name::String="joStack")
joStack{WDT<:Number}(l::Integer,op::joAbstractLinearOperator;weights::AbstractVector{WDT}=zeros(0),name::String="joStack")
joBlock{RVDT<:Integer,WDT<:Number}(rows::Vector{RVDT},ops::joAbstractLinearOperator...;weights::AbstractVector{WDT}=zeros(0),name::String="joBlock")
joCoreBlock(ops::joAbstractLinearOperator...;kwargs...)
```

### Miscaleneous

```@docs
joNumber{NT<:Number}(num::NT)
joNumber{NT<:Number,DDT,RDT}(num::NT,A::joAbstractLinearOperator{DDT,RDT})
```

## Pre-built operators

### joMatrix based

```@docs
```

### joLinearFunction based

```@docs
joDCT(ms::Integer...;DDT::DataType=Float64,RDT::DataType=DDT)
joDFT(ms::Integer...;centered::Bool=false,DDT::DataType=Float64,RDT::DataType=(DDT<:Real?Complex{DDT}:DDT))
joCurvelet2D(n1::Integer,n2::Integer;DDT::DataType=Float64,RDT::DataType=DDT,nbscales::Integer=0,nbangles_coarse::Integer=16,all_crvlts::Bool=false,real_crvlts::Bool=true,zero_finest::Bool=false)
joExtension{T<:Integer}(n::T,pad_type::EXT_TYPE;pad_upper::T=0,pad_lower::T=0,DDT::DataType=Float64,RDT::DataType=DDT)
```

## Functions

```@docs
jo_complex_eltype(DT::DataType)
jo_complex_eltype{T}(a::Complex{T})
jo_type_mismatch_error_set(flag::Bool)
jo_check_type_match(DT1::DataType,DT2::DataType,where::String)
jo_convert_warn_set(flag::Bool)
jo_convert{VT<:Integer}(DT::DataType,vin::AbstractArray{VT},warning::Bool=true)
jo_convert{NT<:Integer}(DT::DataType,nin::NT,warning::Bool=true)

```

## Macros
```@docs
@joNF()
@joNF(fun::Expr)
```

## Types

```@docs
joMatrix
joLinearFunction
joLinearOperator
joNumber
```

## Index

```@index
```
