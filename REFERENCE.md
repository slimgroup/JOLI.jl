
<a id='JOLI-reference-1'></a>

# JOLI reference

- [JOLI reference](REFERENCE.md#JOLI-reference-1)
    - [Constructors](REFERENCE.md#Constructors-1)
        - [Matrix-based operators](REFERENCE.md#Matrix-based-operators-1)
        - [Function-based operators](REFERENCE.md#Function-based-operators-1)
        - [Composite operators](REFERENCE.md#Composite-operators-1)
        - [Miscaleneous](REFERENCE.md#Miscaleneous-1)
    - [Functions](REFERENCE.md#Functions-1)
    - [Macros](REFERENCE.md#Macros-1)
    - [Types](REFERENCE.md#Types-1)
    - [Index](REFERENCE.md#Index-1)


<a id='Constructors-1'></a>

## Constructors


<a id='Matrix-based-operators-1'></a>

### Matrix-based operators

<a id='JOLI.joMatrix-Tuple{AbstractArray{EDT,2}}' href='#JOLI.joMatrix-Tuple{AbstractArray{EDT,2}}'>#</a>
**`JOLI.joMatrix`** &mdash; *Method*.



joMatrix outer constructor

```
joMatrix(array::AbstractMatrix;
         DDT::DataType=eltype(array),
         RDT::DataType=promote_type(eltype(array),DDT),
         name::String="joMatrix")
```

Look up argument names in help to joMatrix type.

**Example**

  * joMatrix(rand(4,3)) # implicit domain and range
  * joMatrix(rand(4,3);DDT=Float32) # implicit range
  * joMatrix(rand(4,3);DDT=Float32,RDT=Float64)
  * joMatrix(rand(4,3);name="my matrix") # adding name

**Notes**

  * if DDT:<Real for complex matrix then imaginary part will be neglected for transpose/conjugated-transpose operator
  * if RDT:<Real for complex matrix then imaginary part will be neglected for forward/conjugate operator


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joMatrix/constructors.jl#L4-L24' class='documenter-source'>source</a><br>


<a id='Function-based-operators-1'></a>

### Function-based operators

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

Look up argument names in help to joLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearFunction/constructors.jl#L4-L18' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionT' href='#JOLI.joLinearFunctionT'>#</a>
**`JOLI.joLinearFunctionT`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionT(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionT")
```

Look up argument names in help to joLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearFunction/constructors.jl#L28-L41' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionCT' href='#JOLI.joLinearFunctionCT'>#</a>
**`JOLI.joLinearFunctionCT`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionCT")
```

Look up argument names in help to joLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearFunction/constructors.jl#L56-L69' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionFwdT' href='#JOLI.joLinearFunctionFwdT'>#</a>
**`JOLI.joLinearFunctionFwdT`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionFwdT(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionFwdT")
```

Look up argument names in help to joLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearFunction/constructors.jl#L84-L97' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionFwdCT' href='#JOLI.joLinearFunctionFwdCT'>#</a>
**`JOLI.joLinearFunctionFwdCT`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionFwdCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionFwdCT")
```

Look up argument names in help to joLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearFunction/constructors.jl#L109-L122' class='documenter-source'>source</a><br>


<a id='Composite-operators-1'></a>

### Composite operators

<a id='JOLI.joKron-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}}' href='#JOLI.joKron-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}}'>#</a>
**`JOLI.joKron`** &mdash; *Method*.



```
joKron(ops::joAbstractLinearOperator...)
```

Kronecker product

**Example**

```
a=rand(Complex{Float64},6,4);
A=joMatrix(a;name="A")
b=rand(Complex{Float64},6,8);
B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
c=rand(Complex{Float64},6,4);
C=joMatrix(c;DDT=Complex{Float64},RDT=Complex{Float32},name="C")
K=joKron(A,B,C)
```

**Notes**

  * the domain and range types of joKron are equal respectively to domain type of rightmost operator and range type of leftmost operator
  * all operators in the chain must have consistent passing domain/range types, i.e. domain type of operator on the left have to be the same as range type of operator on the right


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearOperatorConstructors/joKron.jl#L38-L56' class='documenter-source'>source</a><br>

<a id='JOLI.joBlockDiag-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}}' href='#JOLI.joBlockDiag-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}}'>#</a>
**`JOLI.joBlockDiag`** &mdash; *Method*.



Block-diagonal operator composed from different square JOLI operators

```
joBlockDiag(ops::joAbstractLinearOperator...;
    weights::AbstractVector,name::String)
```

**Example**

```
a=rand(Complex{Float64},4,4);
A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
b=rand(Complex{Float64},8,8);
B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
c=rand(Complex{Float64},6,6);
C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64},name="C")
BD=joBlockDiag(A,B,C) # basic block diagonal
w=rand(Complex{Float64},3)
BD=joBlockDiag(A,B,C;weights=w) # weighted block diagonal
```

**Notes**

  * all operators must be square (M(i)==N(i))
  * all given operators must have same domain/range types
  * the domain/range types of joBlockDiag are equal to domain/range types of the given operators


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearOperatorConstructors/joCoreBlockConstructors/joBlockDiag.jl#L14-L36' class='documenter-source'>source</a><br>

<a id='JOLI.joBlockDiag-Tuple{Integer,JOLI.joAbstractLinearOperator}' href='#JOLI.joBlockDiag-Tuple{Integer,JOLI.joAbstractLinearOperator}'>#</a>
**`JOLI.joBlockDiag`** &mdash; *Method*.



Block-diagonal operator composed from l-times replicated square JOLI operator

```
joBlockDiag(l::Int,op::joAbstractLinearOperator;weights::AbstractVector,name::String)
```

**Example**

```
a=rand(Complex{Float64},4,4);
w=rand(Complex{Float64},3)
A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
BD=joBlockDiag(3,A) # basic block diagonal
BD=joBlockDiag(3,A;weights=w) # weighted block diagonal
```

**Notes**

  * all given operators must have same domain/range types
  * the domain/range types of joBlockDiag are equal to domain/range types of the given operators


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearOperatorConstructors/joCoreBlockConstructors/joBlockDiag.jl#L87-L103' class='documenter-source'>source</a><br>

<a id='JOLI.joDict-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}}' href='#JOLI.joDict-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}}'>#</a>
**`JOLI.joDict`** &mdash; *Method*.



Dictionary operator composed from different square JOLI operators

```
joDict(ops::joAbstractLinearOperator...;
    weights::AbstractVector,name::String)
```

**Example**

```
a=rand(Complex{Float64},4,4);
A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
b=rand(Complex{Float64},4,8);
B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
c=rand(Complex{Float64},4,6);
C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64},name="C")
# either
    D=joDict(A,B,C) # basic dictionary in function syntax
#or
    D=[A B C] # basic dictionary in [] syntax
w=rand(Complex{Float64},3)
D=joDict(A,B,C;weights=w) # weighted dictionary
```

**Notes**

  * all operators must have the same # of rows (M)
  * all given operators must have same domain/range types
  * the domain/range types of joDict are equal to domain/range types of the given operators


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearOperatorConstructors/joCoreBlockConstructors/joDict.jl#L14-L39' class='documenter-source'>source</a><br>

<a id='JOLI.joDict-Tuple{Integer,JOLI.joAbstractLinearOperator}' href='#JOLI.joDict-Tuple{Integer,JOLI.joAbstractLinearOperator}'>#</a>
**`JOLI.joDict`** &mdash; *Method*.



Dictionary operator composed from l-times replicated square JOLI operator

```
joDict(l::Int,op::joAbstractLinearOperator;
    weights::AbstractVector,name::String)
```

**Example**

```
a=rand(Complex{Float64},4,4);
w=rand(Complex{Float64},3)
A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
D=joDict(3,A) # basic dictionary
D=joDict(3,A;weights=w) # weighted dictionary
```

**Notes**

  * all operators must have the same # of rows (M)
  * all given operators must have same domain/range types
  * the domain/range types of joDict are equal to domain/range types of the given operators


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearOperatorConstructors/joCoreBlockConstructors/joDict.jl#L89-L107' class='documenter-source'>source</a><br>

<a id='JOLI.joStack-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}}' href='#JOLI.joStack-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}}'>#</a>
**`JOLI.joStack`** &mdash; *Method*.



Stack operator composed from different square JOLI operators

```
joStack(ops::joAbstractLinearOperator...;
    weights::AbstractVector,name::String)
```

**Example**

```
a=rand(Complex{Float64},4,4);
A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
b=rand(Complex{Float64},8,4);
B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
c=rand(Complex{Float64},6,4);
C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64},name="C")
# either
    S=joStack(A,B,C) # basic stack in function syntax
# or
    S=[A; B; C] # basic stack in [] syntax
w=rand(Complex{Float64},3)
S=joStack(A,B,C;weights=w) # weighted stack
```

**Notes**

  * all operators must have the same # of columns (N)
  * all given operators must have same domain/range types
  * the domain/range types of joStack are equal to domain/range types of the given operators


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearOperatorConstructors/joCoreBlockConstructors/joStack.jl#L14-L39' class='documenter-source'>source</a><br>

<a id='JOLI.joStack-Tuple{Integer,JOLI.joAbstractLinearOperator}' href='#JOLI.joStack-Tuple{Integer,JOLI.joAbstractLinearOperator}'>#</a>
**`JOLI.joStack`** &mdash; *Method*.



Stack operator composed from l-times replicated square JOLI operator

```
joStack(l::Int,op::joAbstractLinearOperator;
    weights::AbstractVector,name::String)
```

**Example**

```
a=rand(Complex{Float64},4,4);
w=rand(Complex{Float64},3)
A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
S=joStack(3,A) # basic stack
S=joStack(3,A;weights=w) # weighted stack
```

**Notes**

  * all operators must have the same # of columns (N)
  * all given operators must have same domain/range types
  * the domain/range types of joStack are equal to domain/range types of the given operators


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearOperatorConstructors/joCoreBlockConstructors/joStack.jl#L89-L107' class='documenter-source'>source</a><br>

<a id='JOLI.joBlock-Tuple{Array{RVDT<:Integer,1},Vararg{JOLI.joAbstractLinearOperator,N}}' href='#JOLI.joBlock-Tuple{Array{RVDT<:Integer,1},Vararg{JOLI.joAbstractLinearOperator,N}}'>#</a>
**`JOLI.joBlock`** &mdash; *Method*.



Block operator composed from different square JOLI operators

```
joBlock(rows::Tuple{Vararg{Int}},ops::joAbstractLinearOperator...;
    weights::AbstractVector,name::String)
```

**Example**

```
a=rand(Complex{Float64},4,4);
A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
b=rand(Complex{Float64},4,8);
B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
c=rand(Complex{Float64},6,6);
C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64},name="C")
d=rand(Complex{Float64},6,6);
D=joMatrix(d;DDT=Complex{Float32},RDT=Complex{Float64},name="D")
# either
    S=joBlock([2,2],A,B,C,D) # basic stack in function syntax
# or
    S=[A B; C D] # basic stack in [] syntax
w=rand(Complex{Float64},4)
S=joBlock(A,B,C;weights=w) # weighted stack
```

**Notes**

  * operators are to be given in row-major order
  * all operators in a row must have the same # of rows (M)
  * sum of Ns for operators in each row must be the same
  * all given operators must have same domain/range types
  * the domain/range types of joBlock are equal to domain/range types of the given operators


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearOperatorConstructors/joCoreBlockConstructors/joBlock.jl#L14-L43' class='documenter-source'>source</a><br>

<a id='JOLI.joCoreBlock-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}}' href='#JOLI.joCoreBlock-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}}'>#</a>
**`JOLI.joCoreBlock`** &mdash; *Method*.



Universal (Core) block operator composed from different JOLI operators

```
joCoreBlock(ops::joAbstractLinearOperator...;
    moffsets::Vector{Integer},noffsets::Vector{Integer},weights::AbstractVector,name::String)
```

**Example**

```
a=rand(Complex{Float64},4,5);
A=joMatrix(a;DDT=Complex{Float32},RDT=Complex{Float64},name="A")
b=rand(Complex{Float64},7,8);
B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
c=rand(Complex{Float64},6,8);
C=joMatrix(c;DDT=Complex{Float32},RDT=Complex{Float64},name="C")
moff=[0;5;13]
noff=[0;6;15]
BD=joCoreBlock(A,B,C;moffsets=moff,noffsets=noff) # sparse blocks
BD=joCoreBlock(A,B,C) # basic diagonal-corners adjacent blocks
w=rand(Complex{Float64},3)
BD=joCoreBlock(A,B,C;weights=w) # weighted basic diagonal-corners adjacent blocks
```

**Notes**

  * all given operators must have same domain/range types
  * the domain/range types of joCoreBlock are equal to domain/range types of the given operators


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearOperatorConstructors/joCoreBlock.jl#L40-L64' class='documenter-source'>source</a><br>


<a id='Miscaleneous-1'></a>

### Miscaleneous

<a id='JOLI.joNumber-Tuple{NT<:Number}' href='#JOLI.joNumber-Tuple{NT<:Number}'>#</a>
**`JOLI.joNumber`** &mdash; *Method*.



joNumber outer constructor

```
joNumber(num)
```

Create joNumber with types matching given number


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/MiscTypes.jl#L26-L33' class='documenter-source'>source</a><br>

<a id='JOLI.joNumber-Tuple{NT<:Number,JOLI.joAbstractLinearOperator{DDT,RDT}}' href='#JOLI.joNumber-Tuple{NT<:Number,JOLI.joAbstractLinearOperator{DDT,RDT}}'>#</a>
**`JOLI.joNumber`** &mdash; *Method*.



joNumber outer constructor

```
joNumber(num,A::joAbstractLinearOperator{DDT,RDT})
```

Create joNumber with types matching the given operator.


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearOperator/constructors.jl#L6-L13' class='documenter-source'>source</a><br>


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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/Utils.jl#L14-L18' class='documenter-source'>source</a><br>

<a id='JOLI.@joNF-Tuple{Expr}' href='#JOLI.@joNF-Tuple{Expr}'>#</a>
**`JOLI.@joNF`** &mdash; *Macro*.



Nullable{Function} macro for given function

```
@joNF ... | @joNF(...)
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/Utils.jl#L23-L27' class='documenter-source'>source</a><br>


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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joMatrix.jl#L10-L30' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearFunction.jl#L11-L31' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearOperator' href='#JOLI.joLinearOperator'>#</a>
**`JOLI.joLinearOperator`** &mdash; *Type*.



```
joLinearOperator is glueing type & constructor

!!! Do not use it to create the operators
!!! Use joMatrix and joLinearFunction constructors
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/joLinearOperator.jl#L13-L19' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/5fa3e4c9023aba5505e24ae2da51f42abdcafcb1/src/MiscTypes.jl#L8-L21' class='documenter-source'>source</a><br>


<a id='Index-1'></a>

## Index

- [`JOLI.joCoreBlock`](REFERENCE.md#JOLI.joCoreBlock-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}})
- [`JOLI.joKron`](REFERENCE.md#JOLI.joKron-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}})
- [`JOLI.joLinearFunction`](REFERENCE.md#JOLI.joLinearFunction)
- [`JOLI.joLinearOperator`](REFERENCE.md#JOLI.joLinearOperator)
- [`JOLI.joMatrix`](REFERENCE.md#JOLI.joMatrix-Tuple{AbstractArray{EDT,2}})
- [`JOLI.joMatrix`](REFERENCE.md#JOLI.joMatrix)
- [`JOLI.joNumber`](REFERENCE.md#JOLI.joNumber-Tuple{NT<:Number,JOLI.joAbstractLinearOperator{DDT,RDT}})
- [`JOLI.joNumber`](REFERENCE.md#JOLI.joNumber-Tuple{NT<:Number})
- [`JOLI.joNumber`](REFERENCE.md#JOLI.joNumber)
- [`JOLI.joBlock`](REFERENCE.md#JOLI.joBlock-Tuple{Array{RVDT<:Integer,1},Vararg{JOLI.joAbstractLinearOperator,N}})
- [`JOLI.joBlockDiag`](REFERENCE.md#JOLI.joBlockDiag-Tuple{Integer,JOLI.joAbstractLinearOperator})
- [`JOLI.joBlockDiag`](REFERENCE.md#JOLI.joBlockDiag-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}})
- [`JOLI.joDict`](REFERENCE.md#JOLI.joDict-Tuple{Integer,JOLI.joAbstractLinearOperator})
- [`JOLI.joDict`](REFERENCE.md#JOLI.joDict-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}})
- [`JOLI.joLinearFunctionAll`](REFERENCE.md#JOLI.joLinearFunctionAll)
- [`JOLI.joLinearFunctionCT`](REFERENCE.md#JOLI.joLinearFunctionCT)
- [`JOLI.joLinearFunctionFwdCT`](REFERENCE.md#JOLI.joLinearFunctionFwdCT)
- [`JOLI.joLinearFunctionFwdT`](REFERENCE.md#JOLI.joLinearFunctionFwdT)
- [`JOLI.joLinearFunctionT`](REFERENCE.md#JOLI.joLinearFunctionT)
- [`JOLI.joStack`](REFERENCE.md#JOLI.joStack-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}})
- [`JOLI.joStack`](REFERENCE.md#JOLI.joStack-Tuple{Integer,JOLI.joAbstractLinearOperator})
- [`JOLI.@joNF`](REFERENCE.md#JOLI.@joNF-Tuple{Expr})
- [`JOLI.@joNF`](REFERENCE.md#JOLI.@joNF-Tuple{})
