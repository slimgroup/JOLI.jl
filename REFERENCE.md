
<a id='JOLI-reference-1'></a>

# JOLI reference

- [JOLI reference](REFERENCE.md#JOLI-reference-1)
    - [Types](REFERENCE.md#Types-1)
    - [Constructors](REFERENCE.md#Constructors-1)
    - [Functions](REFERENCE.md#Functions-1)
    - [Macros](REFERENCE.md#Macros-1)
    - [Index](REFERENCE.md#Index-1)


<a id='Types-1'></a>

## Types

<a id='JOLI.joMatrix' href='#JOLI.joMatrix'>#</a>
**`JOLI.joMatrix`** &mdash; *Type*.



joMatrix type

**TYPE PARAMETERS**

  * DDT::DataType : domain DataType
  * RDT::DataType : range DataType

**FIELDS**

  * name::String : given name
  * m::Integer : # of rows
  * n::Integer : # of columns
  * fop::Function : forward matrix
  * fop_T::Function : transpose matrix
  * fop_CT::Function : conj transpose matrix
  * fop_C::Function : conj matrix
  * iop::Nullable{Function} : inverse for fop
  * iop_T::Nullable{Function} : inverse for fop_T
  * iop_CT::Nullable{Function} : inverse for fop_CT
  * iop_C::Nullable{Function} : inverse for fop_C


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/798ecfc383bc75dcfbe9a3718671c0aed42c2621/src/joMatrix.jl#L10-L30' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunction' href='#JOLI.joLinearFunction'>#</a>
**`JOLI.joLinearFunction`** &mdash; *Type*.



joLinearFunction type

**TYPE PARAMETERS**

  * DDT::DataType : domain DataType
  * RDT::DataType : range DataType

**FIELDS**

  * name::String : given name
  * m::Integer : # of rows
  * n::Integer : # of columns
  * fop::Function : forward function
  * fop_T::Nullable{Function} : transpose function
  * fop_CT::Nullable{Function} : conj transpose function
  * fop_C::Nullable{Function} : conj function
  * iop::Nullable{Function} : inverse for fop
  * iop_T::Nullable{Function} : inverse for fop_T
  * iop_CT::Nullable{Function} : inverse for fop_CT
  * iop_C::Nullable{Function} : inverse for fop_C


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/798ecfc383bc75dcfbe9a3718671c0aed42c2621/src/joLinearFunction.jl#L11-L31' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearOperator' href='#JOLI.joLinearOperator'>#</a>
**`JOLI.joLinearOperator`** &mdash; *Type*.



```
joLinearOperator is glueing type & constructor

!!! Do not use it to create the operators
!!! Use joMatrix and joLinearFunction constructors
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/798ecfc383bc75dcfbe9a3718671c0aed42c2621/src/joLinearOperator.jl#L13-L19' class='documenter-source'>source</a><br>

<a id='JOLI.joNumber' href='#JOLI.joNumber'>#</a>
**`JOLI.joNumber`** &mdash; *Type*.



joNumber type

A number type to use for jo operations with number

**TYPE PARAMETERS**

  * DDT::DataType : domain DataType
  * RDT::DataType : range DataType

**FIELDS**

  * ddt::DDT : number to use when acting on vector to return domain vector
  * rdt::RDT : number to use when acting on vector to return range vector


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/798ecfc383bc75dcfbe9a3718671c0aed42c2621/src/MiscTypes.jl#L8-L21' class='documenter-source'>source</a><br>


<a id='Constructors-1'></a>

## Constructors

<a id='JOLI.joMatrix-Tuple{AbstractArray{EDT,2}}' href='#JOLI.joMatrix-Tuple{AbstractArray{EDT,2}}'>#</a>
**`JOLI.joMatrix`** &mdash; *Method*.



joMatrix outer constructor

```
joMatrix(array::AbstractMatrix;
         DDT::DataType=eltype(array),
         RDT::DataType=promote_type(eltype(array),DDT),
         name::String="joMatrix")
```

Look up argument names in help to joMatrix.

**Example**

  * joMatrix(rand(4,3)) # implicit domain and range
  * joMatrix(rand(4,3);DDT=Float32) # implicit range
  * joMatrix(rand(4,3);DDT=Float32,RDT=Float64)
  * joMatrix(rand(4,3);name="my matrix") # adding name

**Notes**

  * if DDT:<Real for complex matrix then imaginary part will be neglected for transpose/conjugated-transpose operator
  * if RDT:<Real for complex matrix then imaginary part will be neglected for forward/conjugate operator


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/798ecfc383bc75dcfbe9a3718671c0aed42c2621/src/joMatrix/constructors.jl#L4-L24' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionAll' href='#JOLI.joLinearFunctionAll'>#</a>
**`JOLI.joLinearFunctionAll`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionAll(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
    iop::Function,iop_T::Function,iop_CT::Function,iop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionAll")
```

Look up argument names in help to joLinearFunction.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/798ecfc383bc75dcfbe9a3718671c0aed42c2621/src/joLinearFunction/constructors.jl#L4-L18' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionT' href='#JOLI.joLinearFunctionT'>#</a>
**`JOLI.joLinearFunctionT`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionT(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionT")
```

Look up argument names in help to joLinearFunction.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/798ecfc383bc75dcfbe9a3718671c0aed42c2621/src/joLinearFunction/constructors.jl#L28-L41' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionCT' href='#JOLI.joLinearFunctionCT'>#</a>
**`JOLI.joLinearFunctionCT`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionCT")
```

Look up argument names in help to joLinearFunction.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/798ecfc383bc75dcfbe9a3718671c0aed42c2621/src/joLinearFunction/constructors.jl#L56-L69' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionFwdT' href='#JOLI.joLinearFunctionFwdT'>#</a>
**`JOLI.joLinearFunctionFwdT`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionFwdT(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionFwdT")
```

Look up argument names in help to joLinearFunction.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/798ecfc383bc75dcfbe9a3718671c0aed42c2621/src/joLinearFunction/constructors.jl#L84-L97' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionFwdCT' href='#JOLI.joLinearFunctionFwdCT'>#</a>
**`JOLI.joLinearFunctionFwdCT`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionFwdCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionFwdCT")
```

Look up argument names in help to joLinearFunction.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/798ecfc383bc75dcfbe9a3718671c0aed42c2621/src/joLinearFunction/constructors.jl#L109-L122' class='documenter-source'>source</a><br>

<a id='JOLI.joNumber-Tuple{NT<:Number}' href='#JOLI.joNumber-Tuple{NT<:Number}'>#</a>
**`JOLI.joNumber`** &mdash; *Method*.



joNumber outer constructor

```
joNumber(num)
```

Create joNumber with types matching given number


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/798ecfc383bc75dcfbe9a3718671c0aed42c2621/src/MiscTypes.jl#L26-L33' class='documenter-source'>source</a><br>

<a id='JOLI.joNumber-Tuple{NT<:Number,JOLI.joAbstractLinearOperator{DDT,RDT}}' href='#JOLI.joNumber-Tuple{NT<:Number,JOLI.joAbstractLinearOperator{DDT,RDT}}'>#</a>
**`JOLI.joNumber`** &mdash; *Method*.



joNumber outer constructor

```
joNumber(num,A::joAbstractLinearOperator{DDT,RDT})
```

Create joNumber with types matching the given operator.


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/798ecfc383bc75dcfbe9a3718671c0aed42c2621/src/joLinearOperator/constructors.jl#L6-L13' class='documenter-source'>source</a><br>


<a id='Functions-1'></a>

## Functions


<a id='Macros-1'></a>

## Macros

<a id='JOLI.@joNF-Tuple{}' href='#JOLI.@joNF-Tuple{}'>#</a>
**`JOLI.@joNF`** &mdash; *Macro*.



Nullable{Function} macro for null function

```
@joNF
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/798ecfc383bc75dcfbe9a3718671c0aed42c2621/src/Utils.jl#L14-L18' class='documenter-source'>source</a><br>

<a id='JOLI.@joNF-Tuple{Expr}' href='#JOLI.@joNF-Tuple{Expr}'>#</a>
**`JOLI.@joNF`** &mdash; *Macro*.



Nullable{Function} macro for given function

```
@joNF ... | @joNF(...)
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/798ecfc383bc75dcfbe9a3718671c0aed42c2621/src/Utils.jl#L23-L27' class='documenter-source'>source</a><br>


<a id='Index-1'></a>

## Index

- [`JOLI.joLinearFunction`](REFERENCE.md#JOLI.joLinearFunction)
- [`JOLI.joLinearOperator`](REFERENCE.md#JOLI.joLinearOperator)
- [`JOLI.joMatrix`](REFERENCE.md#JOLI.joMatrix-Tuple{AbstractArray{EDT,2}})
- [`JOLI.joMatrix`](REFERENCE.md#JOLI.joMatrix)
- [`JOLI.joNumber`](REFERENCE.md#JOLI.joNumber-Tuple{NT<:Number})
- [`JOLI.joNumber`](REFERENCE.md#JOLI.joNumber-Tuple{NT<:Number,JOLI.joAbstractLinearOperator{DDT,RDT}})
- [`JOLI.joNumber`](REFERENCE.md#JOLI.joNumber)
- [`JOLI.joLinearFunctionAll`](REFERENCE.md#JOLI.joLinearFunctionAll)
- [`JOLI.joLinearFunctionCT`](REFERENCE.md#JOLI.joLinearFunctionCT)
- [`JOLI.joLinearFunctionFwdCT`](REFERENCE.md#JOLI.joLinearFunctionFwdCT)
- [`JOLI.joLinearFunctionFwdT`](REFERENCE.md#JOLI.joLinearFunctionFwdT)
- [`JOLI.joLinearFunctionT`](REFERENCE.md#JOLI.joLinearFunctionT)
- [`JOLI.@joNF`](REFERENCE.md#JOLI.@joNF-Tuple{})
- [`JOLI.@joNF`](REFERENCE.md#JOLI.@joNF-Tuple{Expr})

