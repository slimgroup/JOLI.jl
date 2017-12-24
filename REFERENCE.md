
<a id='JOLI-reference-1'></a>

# JOLI reference

- [JOLI reference](REFERENCE.md#JOLI-reference-1)
    - [Functions](REFERENCE.md#Functions-1)
    - [Macros](REFERENCE.md#Macros-1)
    - [Types](REFERENCE.md#Types-1)
    - [Index](REFERENCE.md#Index-1)


<a id='Functions-1'></a>

## Functions

<a id='JOLI.dalloc-Tuple{JOLI.joDAdistributor}' href='#JOLI.dalloc-Tuple{JOLI.joDAdistributor}'>#</a>
**`JOLI.dalloc`** &mdash; *Method*.



```
julia> dalloc(d; [DT])
```

Allocates a DistributedArrays.DArray without value assigment.

Use it to allocate quicker the array that will have all elements overwritten.

**Signature**

```
dalloc(d::joDAdistributor;DT::DataType=d.DT)
```

**Arguments**

  * d: see help for joDAdistributor
  * DT: keyword argument to overwrite the type in joDAdistributor


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joAbstractLinearOperator/DistributedArraysSupport.jl#L128-L144' class='documenter-source'>source</a><br>

<a id='JOLI.dalloc-Tuple{Tuple{Vararg{Int64,N}} where N,Vararg{Any,N} where N}' href='#JOLI.dalloc-Tuple{Tuple{Vararg{Int64,N}} where N,Vararg{Any,N} where N}'>#</a>
**`JOLI.dalloc`** &mdash; *Method*.



```
julia> dalloc(dims, [...])
```

Allocates a DistributedArrays.DArray without value assigment.

Use it to allocate quicker the array that will have all elements overwritten.

**Signature**

```
dalloc(dims::Dims, [...])
```

**Arguments**

  * optional trailing arguments are the same as those accepted by `DArray`.


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joAbstractLinearOperator/DistributedArraysSupport.jl#L106-L121' class='documenter-source'>source</a><br>

<a id='JOLI.joAddSolverAll-Union{Tuple{DDT}, Tuple{JOLI.joAbstractLinearOperator{DDT,RDT},Function,Function,Function,Function}, Tuple{RDT}} where RDT where DDT' href='#JOLI.joAddSolverAll-Union{Tuple{DDT}, Tuple{JOLI.joAbstractLinearOperator{DDT,RDT},Function,Function,Function,Function}, Tuple{RDT}} where RDT where DDT'>#</a>
**`JOLI.joAddSolverAll`** &mdash; *Method*.



joAddSolver outer constructor

```
joAddSolverAll(A::joAbstractLinearOperator{DDT,RDT},
    solver::Function,solver_T::Function,solver_CT::Function,solver_C::Function)
```

Create joLinearOperator with added specific solver(s) for (jo,[m]vec), distinct for each form of the operator.

**Examples**

```
O=joAddSolverAll(O,
    (s,x)->my_solver(s,x),
    (s,x)->my_solver_T(s,x),
    (s,x)->my_solver_CT(s,x),
    (s,x)->my_solver_C(s,x))

O=joAddSolverAll(O,
    (s,x)->my_solver(s,x),
    @joNF,
    (s,x)->my_solver_CT(s,x),
    @joNF)

O=joAddSolverAll(O,
    (s,x)->my_solver(s,x),
    @joNF,
    @joNF,
    @joNF)
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joAbstractLinearOperator/constructors.jl#L31-L60' class='documenter-source'>source</a><br>

<a id='JOLI.joAddSolverAny-Union{Tuple{DDT}, Tuple{JOLI.joAbstractLinearOperator{DDT,RDT},Function}, Tuple{RDT}} where RDT where DDT' href='#JOLI.joAddSolverAny-Union{Tuple{DDT}, Tuple{JOLI.joAbstractLinearOperator{DDT,RDT},Function}, Tuple{RDT}} where RDT where DDT'>#</a>
**`JOLI.joAddSolverAny`** &mdash; *Method*.



joAddSolver outer constructor

```
joAddSolverAny(A::joAbstractLinearOperator{DDT,RDT},solver::Function)
```

Create joLinearOperator with added solver for (jo,[m]vec), same for each form of the operator

**Example (for all forms of O)**

```
O=joAddSolverAny(O,(s,x)->my_solver(s,x))
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joAbstractLinearOperator/constructors.jl#L7-L19' class='documenter-source'>source</a><br>

<a id='JOLI.joBlock-Union{Tuple{Array{RVDT,1},Vararg{JOLI.joAbstractLinearOperator,N} where N}, Tuple{RVDT}, Tuple{WDT}} where WDT<:Number where RVDT<:Integer' href='#JOLI.joBlock-Union{Tuple{Array{RVDT,1},Vararg{JOLI.joAbstractLinearOperator,N} where N}, Tuple{RVDT}, Tuple{WDT}} where WDT<:Number where RVDT<:Integer'>#</a>
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
    S=joBlock([2,2],A,B,C,D) # basic block in function syntax
# or
    S=[A B; C D] # basic block in [] syntax
w=rand(Complex{Float64},4)
S=joBlock(A,B,C;weights=w) # weighted block
```

**Notes**

  * operators are to be given in row-major order
  * all operators in a row must have the same # of rows (M)
  * sum of Ns for operators in each row must be the same
  * all given operators must have same domain/range types
  * the domain/range types of joBlock are equal to domain/range types of the given operators


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearOperatorConstructors/joCoreBlockConstructors/joBlock.jl#L14-L45' class='documenter-source'>source</a><br>

<a id='JOLI.joBlockDiag-Union{Tuple{Integer,JOLI.joAbstractLinearOperator}, Tuple{WDT}} where WDT<:Number' href='#JOLI.joBlockDiag-Union{Tuple{Integer,JOLI.joAbstractLinearOperator}, Tuple{WDT}} where WDT<:Number'>#</a>
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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearOperatorConstructors/joCoreBlockConstructors/joBlockDiag.jl#L85-L103' class='documenter-source'>source</a><br>

<a id='JOLI.joBlockDiag-Union{Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N}, Tuple{WDT}} where WDT<:Number' href='#JOLI.joBlockDiag-Union{Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N}, Tuple{WDT}} where WDT<:Number'>#</a>
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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearOperatorConstructors/joCoreBlockConstructors/joBlockDiag.jl#L14-L38' class='documenter-source'>source</a><br>

<a id='JOLI.joCurvelet2D-Tuple{Integer,Integer}' href='#JOLI.joCurvelet2D-Tuple{Integer,Integer}'>#</a>
**`JOLI.joCurvelet2D`** &mdash; *Method*.



2D Curvelet transform (wrapping) over fast dimensions

```
joCurvelet2D(n1,n2 [;DDT=joFloat,RDT=DDT,
    nbscales=#,nbangles_coarse=16,all_crvlts=false,real_crvlts=true,zero_finest=false])
```

**Arguments**

  * n1,n2 - image sizes
  * nbscales - # of scales (requires #>=default; defaults to max(1,ceil(log2(min(n1,n2))-3)))
  * nbangles_coarse - # of angles at coarse scale (requires #%4==0, #>=8; defaults to 16)
  * all_crvlts - curvelets at finnest scales (defaults to false)
  * real_crvlts - real transform (defaults to true) and requires real input
  * zero_finest - zero out finnest scales (defaults to false)

**Examples**

  * joCurvelet2D(32,32) - real transform (64-bit)
  * joCurvelet2D(32,32;real_crvlts=false) - complex transform (64-bit)
  * joCurvelet2D(32,32;all_crvlts=true) - real transform with curevelts at the finnest scales (64-bit)
  * joCurvelet2D(32,32;zero_finest=true) - real transform with zeros at the finnest scales (64-bit)
  * joCurvelet2D(32,32;DDT=Float64,real_crvlts=false) - complex transform with real 64-bit input for forward
  * joCurvelet2D(32,32;DDT=Float32,RDT=Float64,real_crvlts=false) - complex transform with just precision specification for curvelets
  * joCurvelet2D(32,32;DDT=Float32,RDT=Complex{Float64},real_crvlts=false) - complex transform with full type specification for curvelets (same as above)

**Notes**

  * if DDT:<Real for complex transform then imaginary part will be neglected for transpose/ctranspose
  * isadjoint test at larger sizes (above 128) might require reseting tollerance to bigger number.


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionConstructors/joCurvelet2D.jl#L48-L78' class='documenter-source'>source</a><br>

<a id='JOLI.joCurvelet2DnoFFT-Tuple{Integer,Integer}' href='#JOLI.joCurvelet2DnoFFT-Tuple{Integer,Integer}'>#</a>
**`JOLI.joCurvelet2DnoFFT`** &mdash; *Method*.



2D Curvelet transform (wrapping) over fast dimensions without FFT

```
joCurvelet2DnoFFT(n1,n2 [;DDT=joComplex,RDT=DDT,
    nbscales=#,nbangles_coarse=16,all_crvlts=false,real_crvlts=true,zero_finest=false])
```

**Arguments**

  * n1,n2 - image sizes
  * nbscales - # of scales (requires #>=default; defaults to max(1,ceil(log2(min(n1,n2))-3)))
  * nbangles_coarse - # of angles at coarse scale (requires #%4==0, #>=8; defaults to 16)
  * all_crvlts - curvelets at finnest scales (defaults to false)
  * real_crvlts - real transform (defaults to true) and requires real input
  * zero_finest - zero out finnest scales (defaults to false)

**Examples**

  * joCurvelet2DnoFFT(32,32) - real transform (64-bit)
  * joCurvelet2DnoFFT(32,32;real_crvlts=false) - complex transform (64-bit)
  * joCurvelet2DnoFFT(32,32;all_crvlts=true) - real transform with curevelts at the finnest scales (64-bit)
  * joCurvelet2DnoFFT(32,32;zero_finest=true) - real transform with zeros at the finnest scales (64-bit)
  * joCurvelet2DnoFFT(32,32;DDT=Float64,real_crvlts=false) - complex transform with complex 64-bit input for forward
  * joCurvelet2DnoFFT(32,32;DDT=Float32,RDT=Float64,real_crvlts=false) - complex transform with just precision specification for curvelets
  * joCurvelet2DnoFFT(32,32;DDT=Float32,RDT=Complex{Float64},real_crvlts=false) - complex transform with full type specification for curvelets (same as above)

**Notes**

  * real joCurvelet2DnoFFT passed adjoint test while either combined with joDFT, or with isadjont flag userange=true
  * isadjoint test at larger sizes (above 128) might require reseting tollerance to bigger number.


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionConstructors/joCurvelet2DnoFFT.jl#L49-L79' class='documenter-source'>source</a><br>

<a id='JOLI.joDCT-Tuple{Vararg{Integer,N} where N}' href='#JOLI.joDCT-Tuple{Vararg{Integer,N} where N}'>#</a>
**`JOLI.joDCT`** &mdash; *Method*.



Multi-dimensional DCT transform over fast dimension(s)

```
joDCT(m[,n[, ...]] [;planned::Bool=true,DDT=joFloat,RDT=DDT])
```

**Examples**

  * joDCT(m) - 1D DCT
  * joDCT(m; planned=false) - 1D FFT without the precomputed plan
  * joDCT(m,n) - 2D DCT
  * joDCT(m; DDT=Float32) - 1D DCT for 32-bit vectors
  * joDCT(m; DDT=Float32,RDT=Float64) - 1D DCT for 32-bit input and 64-bit output

**Notes**

  * if you intend to use joDCT in remote* calls, you have to either set planned=false or create the operator on the worker


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionConstructors/joDCT.jl#L64-L81' class='documenter-source'>source</a><br>

<a id='JOLI.joDFT-Tuple{Vararg{Integer,N} where N}' href='#JOLI.joDFT-Tuple{Vararg{Integer,N} where N}'>#</a>
**`JOLI.joDFT`** &mdash; *Method*.



Multi-dimensional FFT transform over fast dimension(s)

```
joDFT(m[,n[, ...]]
        [;planned=true,centered=false,DDT=joFloat,RDT=(DDT:<Real?Complex{DDT}:DDT)])
```

**Examples**

  * joDFT(m) - 1D FFT
  * joDFT(m; centered=true) - 1D FFT with centered coefficients
  * joDFT(m; planned=false) - 1D FFT without the precomputed plan
  * joDFT(m,n) - 2D FFT
  * joDFT(m; DDT=Float32) - 1D FFT for 32-bit input
  * joDFT(m; DDT=Float32,RDT=Complex{Float64}) - 1D FFT for 32-bit input and 64-bit output

**Notes**

  * if DDT:<Real then imaginary part will be neglected for transpose/ctranspose
  * if you intend to use joDFT in remote* calls, you have to either set planned=false or create the operator on the worker


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionConstructors/joDFT.jl#L120-L140' class='documenter-source'>source</a><br>

<a id='JOLI.joDict-Union{Tuple{Integer,JOLI.joAbstractLinearOperator}, Tuple{WDT}} where WDT<:Number' href='#JOLI.joDict-Union{Tuple{Integer,JOLI.joAbstractLinearOperator}, Tuple{WDT}} where WDT<:Number'>#</a>
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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearOperatorConstructors/joCoreBlockConstructors/joDict.jl#L87-L107' class='documenter-source'>source</a><br>

<a id='JOLI.joDict-Union{Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N}, Tuple{WDT}} where WDT<:Number' href='#JOLI.joDict-Union{Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N}, Tuple{WDT}} where WDT<:Number'>#</a>
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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearOperatorConstructors/joCoreBlockConstructors/joDict.jl#L14-L41' class='documenter-source'>source</a><br>

<a id='JOLI.joExtend-Tuple{Integer,Symbol}' href='#JOLI.joExtend-Tuple{Integer,Symbol}'>#</a>
**`JOLI.joExtend`** &mdash; *Method*.



1D extension operator

```
joExtend(n,pad_type; pad_lower=0,pad_upper=0,DDT=joFloat,RDT=DDT)
```

**Arguments**

  * n : size of input vector
  * pad_type : one of the symbols

      * :zeros - pad signal with zeros
      * :border - pad signal with values at the edge of the domain
      * :mirror - mirror extension of the signal
      * :periodic - periodic extension of the signal
  * pad_lower : number of points to pad on the lower index end (keyword arg, default=0)
  * pad_upper : number of points to pad on the upper index end (keyword arg, default=0)

**Examples**

extend a n-length vector with 10 zeros on either side

```
joExtend(n,:zeros,pad_lower=10,pad_upper=10)
```

append, to a n-length vector, so that x[n+1:n+10] = x[n]

```
joExtend(n,:border,pad_upper=10)
```

prepend, to a n-length vector, its mirror extension: y=[reverse(x[1:10]);x]

```
joExtend(n,:mirror,pad_lower=10)
```

append, to a n-length vector, its periodic extension: y=[x;x[1:10]]

```
joExtend(n,:periodic,pad_upper=10)
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionConstructors/joExtend.jl#L90-L124' class='documenter-source'>source</a><br>

<a id='JOLI.joExtension-Union{Tuple{T,JOLI.EXT_TYPE}, Tuple{T}} where T<:Integer' href='#JOLI.joExtension-Union{Tuple{T,JOLI.EXT_TYPE}, Tuple{T}} where T<:Integer'>#</a>
**`JOLI.joExtension`** &mdash; *Method*.



1D extension operator 

joExtension(n,pad_type; pad_lower=0,pad_upper=0,DDT=joFloat,RDT=DDT)

**Arguments**

  * n : size of input vector
  * pad_type : one of EXT_TYPE 

      * pad_zeros - pad signal with zeros
      * pad_border - pad signal with values at the edge of the domain
      * pad_periodic - periodic extension of the signal
  * pad_lower : number of points to pad on the low end index (keyword arg, default=0)
  * pad_upper : number of points to pad on the upper index (keyword arg, default=0)

**Examples**

  * joExtension(n,pad_zeros,pad_lower=10,pad_upper=10)

      * pads a n- length vector with 10 zeros on either side
  * joExtension(n,pad_periodic,pad_lower=10)

      * extends an n-length vector by its periodic extension starting at index 1
  * joExtension(n,pad_border,pad_upper=10)

      * extends a n-length vector so that x[n+1:n+10] = x[n]


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionConstructors/joExtension.jl#L40-L65' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionAll' href='#JOLI.joLinearFunctionAll'>#</a>
**`JOLI.joLinearFunctionAll`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionAll(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
    iop::Function,iop_T::Function,iop_CT::Function,iop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLinearFunctionAll")
```

Look up argument names in help to joLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunction/constructors.jl#L9-L24' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionCT' href='#JOLI.joLinearFunctionCT'>#</a>
**`JOLI.joLinearFunctionCT`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLinearFunctionCT")
```

Look up argument names in help to joLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunction/constructors.jl#L67-L81' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionFwd' href='#JOLI.joLinearFunctionFwd'>#</a>
**`JOLI.joLinearFunctionFwd`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionFwd(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLinearFunctionAll")
```

Look up argument names in help to joLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunction/constructors.jl#L99-L113' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionFwdCT' href='#JOLI.joLinearFunctionFwdCT'>#</a>
**`JOLI.joLinearFunctionFwdCT`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionFwdCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLinearFunctionFwdCT")
```

Look up argument names in help to joLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunction/constructors.jl#L151-L165' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionFwdT' href='#JOLI.joLinearFunctionFwdT'>#</a>
**`JOLI.joLinearFunctionFwdT`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionFwdT(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLinearFunctionFwdT")
```

Look up argument names in help to joLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunction/constructors.jl#L123-L137' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionInplaceAll' href='#JOLI.joLinearFunctionInplaceAll'>#</a>
**`JOLI.joLinearFunctionInplaceAll`** &mdash; *Function*.



joLinearFunctionInplace outer constructor

```
joLinearFunctionInplaceAll(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,
    iop::Function,iop_T::Function,iop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceAll")
```

Look up argument names in help to joLinearFunctionInplace type.

**Notes**

  * the developer is responsible for ensuring that used functions provide correct DDT & RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionInplace/constructors.jl#L8-L22' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionInplaceCT' href='#JOLI.joLinearFunctionInplaceCT'>#</a>
**`JOLI.joLinearFunctionInplaceCT`** &mdash; *Function*.



joLinearFunctionInplace outer constructor

```
joLinearFunctionInplaceCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceCT")
```

Look up argument names in help to joLinearFunctionInplace type.

**Notes**

  * the developer is responsible for ensuring that used functions provide correct DDT & RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionInplace/constructors.jl#L58-L71' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionInplaceFwd' href='#JOLI.joLinearFunctionInplaceFwd'>#</a>
**`JOLI.joLinearFunctionInplaceFwd`** &mdash; *Function*.



joLinearFunctionInplace outer constructor

```
joLinearFunctionInplaceFwd(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceAll")
```

Look up argument names in help to joLinearFunctionInplace type.

**Notes**

  * the developer is responsible for ensuring that used functions provide correct DDT & RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionInplace/constructors.jl#L84-L97' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionInplaceFwdCT' href='#JOLI.joLinearFunctionInplaceFwdCT'>#</a>
**`JOLI.joLinearFunctionInplaceFwdCT`** &mdash; *Function*.



joLinearFunctionInplace outer constructor

```
joLinearFunctionInplaceFwdCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceFwdCT")
```

Look up argument names in help to joLinearFunctionInplace type.

**Notes**

  * the developer is responsible for ensuring that used functions provide correct DDT & RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionInplace/constructors.jl#L130-L143' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionInplaceFwdT' href='#JOLI.joLinearFunctionInplaceFwdT'>#</a>
**`JOLI.joLinearFunctionInplaceFwdT`** &mdash; *Function*.



joLinearFunctionInplace outer constructor

```
joLinearFunctionInplaceFwdT(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceFwdT")
```

Look up argument names in help to joLinearFunctionInplace type.

**Notes**

  * the developer is responsible for ensuring that used functions provide correct DDT & RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionInplace/constructors.jl#L106-L119' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionInplaceT' href='#JOLI.joLinearFunctionInplaceT'>#</a>
**`JOLI.joLinearFunctionInplaceT`** &mdash; *Function*.



joLinearFunctionInplace outer constructor

```
joLinearFunctionInplaceT(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLinearFunctionInplaceT")
```

Look up argument names in help to joLinearFunctionInplace type.

**Notes**

  * the developer is responsible for ensuring that used functions provide correct DDT & RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionInplace/constructors.jl#L32-L45' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionT' href='#JOLI.joLinearFunctionT'>#</a>
**`JOLI.joLinearFunctionT`** &mdash; *Function*.



joLinearFunction outer constructor

```
joLinearFunctionT(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLinearFunctionT")
```

Look up argument names in help to joLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunction/constructors.jl#L35-L49' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseLinearFunctionAll' href='#JOLI.joLooseLinearFunctionAll'>#</a>
**`JOLI.joLooseLinearFunctionAll`** &mdash; *Function*.



joLooseLinearFunction outer constructor

```
joLooseLinearFunctionAll(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
    iop::Function,iop_T::Function,iop_CT::Function,iop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLooseLinearFunctionAll")
```

Look up argument names in help to joLooseLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLooseLinearFunction/constructors.jl#L8-L23' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseLinearFunctionCT' href='#JOLI.joLooseLinearFunctionCT'>#</a>
**`JOLI.joLooseLinearFunctionCT`** &mdash; *Function*.



joLooseLinearFunction outer constructor

```
joLooseLinearFunctionCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLooseLinearFunctionCT")
```

Look up argument names in help to joLooseLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLooseLinearFunction/constructors.jl#L66-L80' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseLinearFunctionFwd' href='#JOLI.joLooseLinearFunctionFwd'>#</a>
**`JOLI.joLooseLinearFunctionFwd`** &mdash; *Function*.



joLooseLinearFunction outer constructor

```
joLooseLinearFunctionFwd(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLooseLinearFunctionAll")
```

Look up argument names in help to joLooseLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLooseLinearFunction/constructors.jl#L98-L112' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseLinearFunctionFwdCT' href='#JOLI.joLooseLinearFunctionFwdCT'>#</a>
**`JOLI.joLooseLinearFunctionFwdCT`** &mdash; *Function*.



joLooseLinearFunction outer constructor

```
joLooseLinearFunctionFwdCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLooseLinearFunctionFwdCT")
```

Look up argument names in help to joLooseLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLooseLinearFunction/constructors.jl#L150-L164' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseLinearFunctionFwdT' href='#JOLI.joLooseLinearFunctionFwdT'>#</a>
**`JOLI.joLooseLinearFunctionFwdT`** &mdash; *Function*.



joLooseLinearFunction outer constructor

```
joLooseLinearFunctionFwdT(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,
    name::String="joLooseLinearFunctionFwdT")
```

Look up argument names in help to joLooseLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLooseLinearFunction/constructors.jl#L122-L136' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseLinearFunctionInplaceAll' href='#JOLI.joLooseLinearFunctionInplaceAll'>#</a>
**`JOLI.joLooseLinearFunctionInplaceAll`** &mdash; *Function*.



joLooseLinearFunctionInplace outer constructor

```
joLooseLinearFunctionInplaceAll(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,
    iop::Function,iop_T::Function,iop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceAll")
```

Look up argument names in help to joLooseLinearFunctionInplace type.

**Notes**

  * the developer is responsible for ensuring that used functions provide correct DDT & RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLooseLinearFunctionInplace/constructors.jl#L8-L22' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseLinearFunctionInplaceCT' href='#JOLI.joLooseLinearFunctionInplaceCT'>#</a>
**`JOLI.joLooseLinearFunctionInplaceCT`** &mdash; *Function*.



joLooseLinearFunctionInplace outer constructor

```
joLooseLinearFunctionInplaceCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function, iop::Function,iop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceCT")
```

Look up argument names in help to joLooseLinearFunctionInplace type.

**Notes**

  * the developer is responsible for ensuring that used functions provide correct DDT & RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLooseLinearFunctionInplace/constructors.jl#L58-L71' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseLinearFunctionInplaceFwd' href='#JOLI.joLooseLinearFunctionInplaceFwd'>#</a>
**`JOLI.joLooseLinearFunctionInplaceFwd`** &mdash; *Function*.



joLooseLinearFunctionInplace outer constructor

```
joLooseLinearFunctionInplaceFwd(m::Integer,n::Integer,
    fop::Function,fop_T::Function,fop_CT::Function,fop_C::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceAll")
```

Look up argument names in help to joLooseLinearFunctionInplace type.

**Notes**

  * the developer is responsible for ensuring that used functions provide correct DDT & RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLooseLinearFunctionInplace/constructors.jl#L84-L97' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseLinearFunctionInplaceFwdCT' href='#JOLI.joLooseLinearFunctionInplaceFwdCT'>#</a>
**`JOLI.joLooseLinearFunctionInplaceFwdCT`** &mdash; *Function*.



joLooseLinearFunctionInplace outer constructor

```
joLooseLinearFunctionInplaceFwdCT(m::Integer,n::Integer,
    fop::Function,fop_CT::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceFwdCT")
```

Look up argument names in help to joLooseLinearFunctionInplace type.

**Notes**

  * the developer is responsible for ensuring that used functions provide correct DDT & RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLooseLinearFunctionInplace/constructors.jl#L130-L143' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseLinearFunctionInplaceFwdT' href='#JOLI.joLooseLinearFunctionInplaceFwdT'>#</a>
**`JOLI.joLooseLinearFunctionInplaceFwdT`** &mdash; *Function*.



joLooseLinearFunctionInplace outer constructor

```
joLooseLinearFunctionInplaceFwdT(m::Integer,n::Integer,
    fop::Function,fop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceFwdT")
```

Look up argument names in help to joLooseLinearFunctionInplace type.

**Notes**

  * the developer is responsible for ensuring that used functions provide correct DDT & RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLooseLinearFunctionInplace/constructors.jl#L106-L119' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseLinearFunctionInplaceT' href='#JOLI.joLooseLinearFunctionInplaceT'>#</a>
**`JOLI.joLooseLinearFunctionInplaceT`** &mdash; *Function*.



joLooseLinearFunctionInplace outer constructor

```
joLooseLinearFunctionInplaceT(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    name::String="joLooseLinearFunctionInplaceT")
```

Look up argument names in help to joLooseLinearFunctionInplace type.

**Notes**

  * the developer is responsible for ensuring that used functions provide correct DDT & RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLooseLinearFunctionInplace/constructors.jl#L32-L45' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseLinearFunctionT' href='#JOLI.joLooseLinearFunctionT'>#</a>
**`JOLI.joLooseLinearFunctionT`** &mdash; *Function*.



joLooseLinearFunction outer constructor

```
joLooseLinearFunctionT(m::Integer,n::Integer,
    fop::Function,fop_T::Function, iop::Function,iop_T::Function,
    DDT::DataType,RDT::DataType=DDT;
    fMVok::Bool=false,iMVok::Bool=false,
    name::String="joLooseLinearFunctionT")
```

Look up argument names in help to joLooseLinearFunction type.

**Notes**

  * the developer is responsible for ensuring that used functions take/return correct DDT/RDT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLooseLinearFunction/constructors.jl#L34-L48' class='documenter-source'>source</a><br>

<a id='JOLI.joMask-Tuple{BitArray{1}}' href='#JOLI.joMask-Tuple{BitArray{1}}'>#</a>
**`JOLI.joMask`** &mdash; *Method*.



Mask operator

```
joMask(mask[;DDT=joFloat,RDT=DDT,makecopy=true])
```

**Arguments**

  * mask::BitArray{1} - BitArray mask of true indecies

**Examples**

  * mask=falses(3)
  * mask[[1,3]]=true
  * A=joMask(mask)
  * A=joMask(mask;DDT=Float32)
  * A=joMask(mask;DDT=Float32,RDT=Float64)


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionConstructors/joMask.jl#L35-L50' class='documenter-source'>source</a><br>

<a id='JOLI.joMask-Union{Tuple{Integer,Array{VDT,1}}, Tuple{VDT}} where VDT<:Integer' href='#JOLI.joMask-Union{Tuple{Integer,Array{VDT,1}}, Tuple{VDT}} where VDT<:Integer'>#</a>
**`JOLI.joMask`** &mdash; *Method*.



Mask operator

```
joMask(n,idx[;DDT=joFloat,RDT=DDT])
```

**Arguments**

  * n::Integer - size of square operator
  * idx::Vector{Integer} - vector of true indecies

**Examples**

  * A=joMask(3,[1,3])
  * A=joMask(3,[1,3];DDT=Float32)
  * A=joMask(3,[1,3];DDT=Float32,RDT=Float64)


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionConstructors/joMask.jl#L4-L18' class='documenter-source'>source</a><br>

<a id='JOLI.joNFFT' href='#JOLI.joNFFT'>#</a>
**`JOLI.joNFFT`** &mdash; *Function*.



1D NFFT transform over fast dimension (wrapper to https://github.com/tknopp/NFFT.jl/tree/master)

```
joNFFT(N,nodes::Vector{joFloat} [,m=4,sigma=2.0,window=:kaiser_bessel,K=2000;centered=false,DDT=joComplex,RDT=DDT])
```

**Examples**

  * joNFFT(N,nodes) - 1D NFFT

**Notes**

  * NFFT always uses Complex{Float64} vectors internally
  * see https://github.com/tknopp/NFFT.jl/tree/master for docs for optional parameters to NFFTplan


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionConstructors/joNFFT.jl#L36-L48' class='documenter-source'>source</a><br>

<a id='JOLI.joRestriction-Union{Tuple{Integer,Array{VDT,1}}, Tuple{VDT}} where VDT<:Integer' href='#JOLI.joRestriction-Union{Tuple{Integer,Array{VDT,1}}, Tuple{VDT}} where VDT<:Integer'>#</a>
**`JOLI.joRestriction`** &mdash; *Method*.



Restriction operator

```
joRestriction(n,idx[;DDT=joFloat,RDT=DDT,makecopy=true])
```

**Arguments**

  * n::Integer - number of columns
  * idx::AbstractVector{Int} - vector of indecies

**Exmaple**

  * A=joRestriction(3,[1,3])
  * A=joRestriction(3,[1,3];DDT=Float32)
  * A=joRestriction(3,[1,3];DDT=Float32,RDT=Float64)


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearFunctionConstructors/joRestriction.jl#L4-L18' class='documenter-source'>source</a><br>

<a id='JOLI.joStack-Union{Tuple{Integer,JOLI.joAbstractLinearOperator}, Tuple{WDT}} where WDT<:Number' href='#JOLI.joStack-Union{Tuple{Integer,JOLI.joAbstractLinearOperator}, Tuple{WDT}} where WDT<:Number'>#</a>
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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearOperatorConstructors/joCoreBlockConstructors/joStack.jl#L85-L103' class='documenter-source'>source</a><br>

<a id='JOLI.joStack-Union{Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N}, Tuple{WDT}} where WDT<:Number' href='#JOLI.joStack-Union{Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N}, Tuple{WDT}} where WDT<:Number'>#</a>
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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearOperatorConstructors/joCoreBlockConstructors/joStack.jl#L14-L39' class='documenter-source'>source</a><br>

<a id='JOLI.jo_check_type_match-Tuple{DataType,DataType,String}' href='#JOLI.jo_check_type_match-Tuple{DataType,DataType,String}'>#</a>
**`JOLI.jo_check_type_match`** &mdash; *Method*.



Check type match

```
jo_check_type_match(DT1::DataType,DT2::DataType,where::String)
```

The bahaviour of the function while types do not match depends on values of jo_type_mismatch_warn and jo_type_mismatch_error flags. Use jo_type_mismatch_error_set to toggle those flags from warning mode to error mode.

**EXAMPLE**

  * jo_check_type_match(Float32,Float64,"my session")


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L283-L296' class='documenter-source'>source</a><br>

<a id='JOLI.jo_complex_eltype-Tuple{DataType}' href='#JOLI.jo_complex_eltype-Tuple{DataType}'>#</a>
**`JOLI.jo_complex_eltype`** &mdash; *Method*.



Type of element of complex data type

```
jo_complex_eltype(DT::DataType)
```

**Example**

  * jo_complex_eltype(Complex{Float32})


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L234-L242' class='documenter-source'>source</a><br>

<a id='JOLI.jo_complex_eltype-Union{Tuple{Complex{T}}, Tuple{T}} where T' href='#JOLI.jo_complex_eltype-Union{Tuple{Complex{T}}, Tuple{T}} where T'>#</a>
**`JOLI.jo_complex_eltype`** &mdash; *Method*.



Type of element of complex scalar

```
jo_complex_eltype(a::Complex)
```

**Example**

  * jo_complex_eltype(1.+im*1.)
  * jo_complex_eltype(zero(Complex{Float64}))


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L223-L232' class='documenter-source'>source</a><br>

<a id='JOLI.jo_convert-Union{Tuple{DataType,AbstractArray{VT,N} where N,Bool}, Tuple{DataType,AbstractArray{VT,N} where N}, Tuple{VT}} where VT<:Integer' href='#JOLI.jo_convert-Union{Tuple{DataType,AbstractArray{VT,N} where N,Bool}, Tuple{DataType,AbstractArray{VT,N} where N}, Tuple{VT}} where VT<:Integer'>#</a>
**`JOLI.jo_convert`** &mdash; *Method*.



Convert vector to new type

```
jo_convert(DT::DataType,v::AbstractArray,warning::Bool=true)
```

**Limitations**

  * converting integer array to shorter representation will throw an error
  * converting float/complex array to integer will throw an error
  * converting from complex to float drops immaginary part and issues warning; use jo_convert_warn_set(false) to turn off the warning

**Example**

  * jo_convert(Complex{Float32},rand(3))


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L323-L337' class='documenter-source'>source</a><br>

<a id='JOLI.jo_convert-Union{Tuple{DataType,NT,Bool}, Tuple{DataType,NT}, Tuple{NT}} where NT<:Integer' href='#JOLI.jo_convert-Union{Tuple{DataType,NT,Bool}, Tuple{DataType,NT}, Tuple{NT}} where NT<:Integer'>#</a>
**`JOLI.jo_convert`** &mdash; *Method*.



Convert number to new type

```
jo_convert(DT::DataType,n::Number,warning::Bool=true)
```

**Limitations**

  * converting integer number to shorter representation will throw an error
  * converting float/complex number to integer will throw an error
  * converting from complex to float drops immaginary part and issues warning; use jo_convert_warn_set(false) to turn off the warning

**Example**

  * jo_convert(Complex{Float32},rand())


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L375-L389' class='documenter-source'>source</a><br>

<a id='JOLI.jo_convert_warn_set-Tuple{Bool}' href='#JOLI.jo_convert_warn_set-Tuple{Bool}'>#</a>
**`JOLI.jo_convert_warn_set`** &mdash; *Method*.



Set warning mode for jo_convert

```
jo_convert_warn_set(flag::Bool)
```

**Example**

  * jo_convert_warn_set(false) turns of the warnings


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L309-L317' class='documenter-source'>source</a><br>

<a id='JOLI.jo_iterative_solver4square_set-Tuple{Function}' href='#JOLI.jo_iterative_solver4square_set-Tuple{Function}'>#</a>
**`JOLI.jo_iterative_solver4square_set`** &mdash; *Method*.



Set default iterative solver for (jo,vec) and square jo

```
jo_iterative_solver4square_set(f::Function)
```

Where f must take two arguments (jo,vec) and return vec.

**Example (using IterativeSolvers)**

  * jo_iterative_solver4square_set((A,v)->gmres(A,v))


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L152-L162' class='documenter-source'>source</a><br>

<a id='JOLI.jo_iterative_solver4tall_set-Tuple{Function}' href='#JOLI.jo_iterative_solver4tall_set-Tuple{Function}'>#</a>
**`JOLI.jo_iterative_solver4tall_set`** &mdash; *Method*.



Set default iterative solver for (jo,vec) and tall jo

```
jo_iterative_solver4tall_set(f::Function)
```

Where f must take two arguments (jo,vec) and return vec.

**Example**

  * jo_iterative_solver4tall_set((A,v)->tall_solve(A,v))


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L172-L182' class='documenter-source'>source</a><br>

<a id='JOLI.jo_iterative_solver4wide_set-Tuple{Function}' href='#JOLI.jo_iterative_solver4wide_set-Tuple{Function}'>#</a>
**`JOLI.jo_iterative_solver4wide_set`** &mdash; *Method*.



Set default iterative solver for (jo,vec) and wide jo

```
jo_iterative_solver4wide_set(f::Function)
```

Where f must take two arguments (jo,vec) and return vec.

**Example**

  * jo_iterative_solver4wide_set((A,v)->wide_solve(A,v))


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L192-L202' class='documenter-source'>source</a><br>

<a id='JOLI.jo_jo32bit_set-Tuple{}' href='#JOLI.jo_jo32bit_set-Tuple{}'>#</a>
**`JOLI.jo_jo32bit_set`** &mdash; *Method*.



set default type joInt, joFloat, joComplex to 32 bit

```
function jo_jo32bit_set()
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L93-L98' class='documenter-source'>source</a><br>

<a id='JOLI.jo_jo64bit_set-Tuple{}' href='#JOLI.jo_jo64bit_set-Tuple{}'>#</a>
**`JOLI.jo_jo64bit_set`** &mdash; *Method*.



set default type joInt, joFloat, joComplex to 64 bit

```
function jo_jo64bit_set()
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L106-L111' class='documenter-source'>source</a><br>

<a id='JOLI.jo_joComplex_set' href='#JOLI.jo_joComplex_set'>#</a>
**`JOLI.jo_joComplex_set`** &mdash; *Function*.



set default complex type joComplex

```
function jo_joComplex_set(DT::DataType=joComplex)
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L83-L88' class='documenter-source'>source</a><br>

<a id='JOLI.jo_joFloat_set' href='#JOLI.jo_joFloat_set'>#</a>
**`JOLI.jo_joFloat_set`** &mdash; *Function*.



set default float type joFloat

```
function jo_joFloat_set(DT::DataType=joFloat)
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L73-L78' class='documenter-source'>source</a><br>

<a id='JOLI.jo_joInt_set' href='#JOLI.jo_joInt_set'>#</a>
**`JOLI.jo_joInt_set`** &mdash; *Function*.



set default integer type joInt

```
function jo_joInt_set(DT::DataType=joInt)
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L63-L68' class='documenter-source'>source</a><br>

<a id='JOLI.jo_joTypes_get-Tuple{}' href='#JOLI.jo_joTypes_get-Tuple{}'>#</a>
**`JOLI.jo_joTypes_get`** &mdash; *Method*.



get default types joInt, joFloat, joComplex

```
function jo_joTypes_get()
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L120-L125' class='documenter-source'>source</a><br>

<a id='JOLI.jo_precision_type-Union{Tuple{ITx}, Tuple{Tx}, Tuple{Tx}} where Tx<:Union{Complex{ITx}, ITx} where ITx<:Number' href='#JOLI.jo_precision_type-Union{Tuple{ITx}, Tuple{Tx}, Tuple{Tx}} where Tx<:Union{Complex{ITx}, ITx} where ITx<:Number'>#</a>
**`JOLI.jo_precision_type`** &mdash; *Method*.



Type of the real number or element type of complex number.

**Example**

  * jo_precision_type(1.)
  * jo_precision_type(1+im*3.)


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L211-L217' class='documenter-source'>source</a><br>

<a id='JOLI.jo_type_mismatch_error_set-Tuple{Bool}' href='#JOLI.jo_type_mismatch_error_set-Tuple{Bool}'>#</a>
**`JOLI.jo_type_mismatch_error_set`** &mdash; *Method*.



Toggle between warning and error for type mismatch

```
jo_type_mismatch_error_set(flag::Bool)
```

**Examples**

  * jo_type_mismatch_error_set(false) turns on warnings instead of errors
  * jo_type_mismatch_error_set(true) reverts to errors


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L254-L263' class='documenter-source'>source</a><br>


<a id='Macros-1'></a>

## Macros

<a id='JOLI.@joNF-Tuple{Expr}' href='#JOLI.@joNF-Tuple{Expr}'>#</a>
**`JOLI.@joNF`** &mdash; *Macro*.



Nullable{Function} macro for given function

```
@joNF ... | @joNF(...)
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L139-L143' class='documenter-source'>source</a><br>

<a id='JOLI.@joNF-Tuple{}' href='#JOLI.@joNF-Tuple{}'>#</a>
**`JOLI.@joNF`** &mdash; *Macro*.



Nullable{Function} macro for null function

```
@joNF
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joUtils.jl#L131-L135' class='documenter-source'>source</a><br>


<a id='Types-1'></a>

## Types

<a id='JOLI.joCoreBlock-Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N}' href='#JOLI.joCoreBlock-Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N}'>#</a>
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
BD=joCoreBlock(A,B,C;moffsets=moff,noffsets=noff,ME=5,NE=5) # sparse blocks with zero extansion of (ME,NE) size
BD=joCoreBlock(A,B,C) # basic diagonal-corners adjacent blocks
w=rand(Complex{Float64},3)
BD=joCoreBlock(A,B,C;weights=w) # weighted basic diagonal-corners adjacent blocks
```

**Notes**

  * all given operators must have same domain/range types
  * the domain/range types of joCoreBlock are equal to domain/range types of the given operators


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearOperatorConstructors/joCoreBlock.jl#L8-L33' class='documenter-source'>source</a><br>

<a id='JOLI.joKron-Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N}' href='#JOLI.joKron-Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N}'>#</a>
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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLinearOperatorConstructors/joKron.jl#L8-L26' class='documenter-source'>source</a><br>

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
  * fMVok : whether fops are rady to handle mvec
  * iop::Nullable{Function} : inverse for fop
  * iop_T::Nullable{Function} : inverse for fop_T
  * iop_CT::Nullable{Function} : inverse for fop_CT
  * iop_C::Nullable{Function} : inverse for fop_C
  * iMVok::Bool : whether iops are rady to handle mvec


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joTypes/joLinearFunction.jl#L8-L30' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearFunctionInplace' href='#JOLI.joLinearFunctionInplace'>#</a>
**`JOLI.joLinearFunctionInplace`** &mdash; *Type*.



joLinearFunctionInplace type

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
  * iop::Nullable{Function} : inverse for fop
  * iop_T::Nullable{Function} : inverse for fop_T
  * iop_CT::Nullable{Function} : inverse for fop_CT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joTypes/joLinearFunctionInplace.jl#L8-L26' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearOperator' href='#JOLI.joLinearOperator'>#</a>
**`JOLI.joLinearOperator`** &mdash; *Type*.



```
joLinearOperator is glueing type & constructor

!!! Do not use it to create the operators
!!! Use joMatrix and joLinearFunction constructors
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joTypes/joLinearOperator.jl#L8-L14' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseLinearFunction' href='#JOLI.joLooseLinearFunction'>#</a>
**`JOLI.joLooseLinearFunction`** &mdash; *Type*.



joLooseLinearFunction type

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
  * fMVok : whether fops are rady to handle mvec
  * iop::Nullable{Function} : inverse for fop
  * iop_T::Nullable{Function} : inverse for fop_T
  * iop_CT::Nullable{Function} : inverse for fop_CT
  * iop_C::Nullable{Function} : inverse for fop_C
  * iMVok::Bool : whether iops are rady to handle mvec


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joTypes/joLooseLinearFunction.jl#L8-L30' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseLinearFunctionInplace' href='#JOLI.joLooseLinearFunctionInplace'>#</a>
**`JOLI.joLooseLinearFunctionInplace`** &mdash; *Type*.



joLooseLinearFunctionInplace type

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
  * iop::Nullable{Function} : inverse for fop
  * iop_T::Nullable{Function} : inverse for fop_T
  * iop_CT::Nullable{Function} : inverse for fop_CT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joTypes/joLooseLinearFunctionInplace.jl#L8-L26' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseMatrix' href='#JOLI.joLooseMatrix'>#</a>
**`JOLI.joLooseMatrix`** &mdash; *Type*.



joLooseMatrix type

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joTypes/joLooseMatrix.jl#L8-L28' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseMatrix-Union{Tuple{AbstractArray{EDT,2}}, Tuple{EDT}} where EDT' href='#JOLI.joLooseMatrix-Union{Tuple{AbstractArray{EDT,2}}, Tuple{EDT}} where EDT'>#</a>
**`JOLI.joLooseMatrix`** &mdash; *Method*.



joLooseMatrix outer constructor

```
joLooseMatrix(array::AbstractMatrix;
         DDT::DataType=eltype(array),
         RDT::DataType=promote_type(eltype(array),DDT),
         name::String="joLooseMatrix")
```

Look up argument names in help to joLooseMatrix type.

**Example**

  * joLooseMatrix(rand(4,3)) # implicit domain and range
  * joLooseMatrix(rand(4,3);DDT=Float32) # implicit range
  * joLooseMatrix(rand(4,3);DDT=Float32,RDT=Float64)
  * joLooseMatrix(rand(4,3);name="my matrix") # adding name

**Notes**

  * if DDT:<Real for complex matrix then imaginary part will be neglected for transpose/conjugated-transpose operator
  * if RDT:<Real for complex matrix then imaginary part will be neglected for forward/conjugate operator


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLooseMatrix/constructors.jl#L4-L24' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseMatrixInplace' href='#JOLI.joLooseMatrixInplace'>#</a>
**`JOLI.joLooseMatrixInplace`** &mdash; *Type*.



joLooseMatrixInplace type

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
  * iop::Nullable{Function} : inverse for fop
  * iop_T::Nullable{Function} : inverse for fop_T
  * iop_CT::Nullable{Function} : inverse for fop_CT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joTypes/joLooseMatrixInplace.jl#L8-L26' class='documenter-source'>source</a><br>

<a id='JOLI.joLooseMatrixInplace-Union{Tuple{AbstractArray{EDT,2}}, Tuple{EDT}} where EDT' href='#JOLI.joLooseMatrixInplace-Union{Tuple{AbstractArray{EDT,2}}, Tuple{EDT}} where EDT'>#</a>
**`JOLI.joLooseMatrixInplace`** &mdash; *Method*.



joLooseMatrixInplace outer constructor

```
joLooseMatrixInplace(array::AbstractMatrix;
         DDT::DataType=eltype(array),
         RDT::DataType=promote_type(eltype(array),DDT),
         name::String="joLooseMatrixInplace")
```

Look up argument names in help to joLooseMatrixInplace type.

**Example**

  * joLooseMatrixInplace(rand(4,3)) # implicit domain and range
  * joLooseMatrixInplace(rand(4,3);DDT=Float32) # implicit range
  * joLooseMatrixInplace(rand(4,3);DDT=Float32,RDT=Float64)
  * joLooseMatrixInplace(rand(4,3);name="my matrix") # adding name

**Notes**

  * if DDT:<Real for complex matrix then imaginary part will be neglected for transpose/conjugated-transpose operator
  * if RDT:<Real for complex matrix then imaginary part will be neglected for forward/conjugate operator


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joLooseMatrixInplace/constructors.jl#L4-L24' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joTypes/joMatrix.jl#L8-L28' class='documenter-source'>source</a><br>

<a id='JOLI.joMatrix-Union{Tuple{AbstractArray{EDT,2}}, Tuple{EDT}} where EDT' href='#JOLI.joMatrix-Union{Tuple{AbstractArray{EDT,2}}, Tuple{EDT}} where EDT'>#</a>
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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joMatrix/constructors.jl#L4-L24' class='documenter-source'>source</a><br>

<a id='JOLI.joMatrixInplace' href='#JOLI.joMatrixInplace'>#</a>
**`JOLI.joMatrixInplace`** &mdash; *Type*.



joMatrixInplace type

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
  * iop::Nullable{Function} : inverse for fop
  * iop_T::Nullable{Function} : inverse for fop_T
  * iop_CT::Nullable{Function} : inverse for fop_CT


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joTypes/joMatrixInplace.jl#L8-L26' class='documenter-source'>source</a><br>

<a id='JOLI.joMatrixInplace-Union{Tuple{AbstractArray{EDT,2}}, Tuple{EDT}} where EDT' href='#JOLI.joMatrixInplace-Union{Tuple{AbstractArray{EDT,2}}, Tuple{EDT}} where EDT'>#</a>
**`JOLI.joMatrixInplace`** &mdash; *Method*.



joMatrixInplace outer constructor

```
joMatrixInplace(array::AbstractMatrix;
         DDT::DataType=eltype(array),
         RDT::DataType=promote_type(eltype(array),DDT),
         name::String="joMatrixInplace")
```

Look up argument names in help to joMatrixInplace type.

**Example**

  * joMatrixInplace(rand(4,3)) # implicit domain and range
  * joMatrixInplace(rand(4,3);DDT=Float32) # implicit range
  * joMatrixInplace(rand(4,3);DDT=Float32,RDT=Float64)
  * joMatrixInplace(rand(4,3);name="my matrix") # adding name

**Notes**

  * if DDT:<Real for complex matrix then imaginary part will be neglected for transpose/conjugated-transpose operator
  * if RDT:<Real for complex matrix then imaginary part will be neglected for forward/conjugate operator


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joMatrixInplace/constructors.jl#L4-L24' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joTypes/joNumber.jl#L8-L21' class='documenter-source'>source</a><br>

<a id='JOLI.joNumber-Union{Tuple{DDT}, Tuple{NT,JOLI.joAbstractLinearOperator{DDT,RDT}}, Tuple{NT}, Tuple{RDT}} where RDT where DDT where NT<:Number' href='#JOLI.joNumber-Union{Tuple{DDT}, Tuple{NT,JOLI.joAbstractLinearOperator{DDT,RDT}}, Tuple{NT}, Tuple{RDT}} where RDT where DDT where NT<:Number'>#</a>
**`JOLI.joNumber`** &mdash; *Method*.



joNumber outer constructor

```
joNumber(num,A::joAbstractLinearOperator{DDT,RDT})
```

Create joNumber with types matching the given operator.


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joMiscTypesFunctions.jl#L16-L23' class='documenter-source'>source</a><br>

<a id='JOLI.joNumber-Union{Tuple{NT}, Tuple{NT}} where NT<:Number' href='#JOLI.joNumber-Union{Tuple{NT}, Tuple{NT}} where NT<:Number'>#</a>
**`JOLI.joNumber`** &mdash; *Method*.



joNumber outer constructor

```
joNumber(num)
```

Create joNumber with types matching given number


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/blob/f13f2fe63c1533033a99cde10e28f9c02b601f57/src/joMiscTypesFunctions.jl#L7-L14' class='documenter-source'>source</a><br>


<a id='Index-1'></a>

## Index

- [`JOLI.joCoreBlock`](REFERENCE.md#JOLI.joCoreBlock-Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N})
- [`JOLI.joKron`](REFERENCE.md#JOLI.joKron-Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N})
- [`JOLI.joLinearFunction`](REFERENCE.md#JOLI.joLinearFunction)
- [`JOLI.joLinearFunctionInplace`](REFERENCE.md#JOLI.joLinearFunctionInplace)
- [`JOLI.joLinearOperator`](REFERENCE.md#JOLI.joLinearOperator)
- [`JOLI.joLooseLinearFunction`](REFERENCE.md#JOLI.joLooseLinearFunction)
- [`JOLI.joLooseLinearFunctionInplace`](REFERENCE.md#JOLI.joLooseLinearFunctionInplace)
- [`JOLI.joLooseMatrix`](REFERENCE.md#JOLI.joLooseMatrix)
- [`JOLI.joLooseMatrix`](REFERENCE.md#JOLI.joLooseMatrix-Union{Tuple{AbstractArray{EDT,2}}, Tuple{EDT}} where EDT)
- [`JOLI.joLooseMatrixInplace`](REFERENCE.md#JOLI.joLooseMatrixInplace)
- [`JOLI.joLooseMatrixInplace`](REFERENCE.md#JOLI.joLooseMatrixInplace-Union{Tuple{AbstractArray{EDT,2}}, Tuple{EDT}} where EDT)
- [`JOLI.joMatrix`](REFERENCE.md#JOLI.joMatrix)
- [`JOLI.joMatrix`](REFERENCE.md#JOLI.joMatrix-Union{Tuple{AbstractArray{EDT,2}}, Tuple{EDT}} where EDT)
- [`JOLI.joMatrixInplace`](REFERENCE.md#JOLI.joMatrixInplace-Union{Tuple{AbstractArray{EDT,2}}, Tuple{EDT}} where EDT)
- [`JOLI.joMatrixInplace`](REFERENCE.md#JOLI.joMatrixInplace)
- [`JOLI.joNumber`](REFERENCE.md#JOLI.joNumber)
- [`JOLI.joNumber`](REFERENCE.md#JOLI.joNumber-Union{Tuple{NT}, Tuple{NT}} where NT<:Number)
- [`JOLI.joNumber`](REFERENCE.md#JOLI.joNumber-Union{Tuple{DDT}, Tuple{NT,JOLI.joAbstractLinearOperator{DDT,RDT}}, Tuple{NT}, Tuple{RDT}} where RDT where DDT where NT<:Number)
- [`JOLI.dalloc`](REFERENCE.md#JOLI.dalloc-Tuple{Tuple{Vararg{Int64,N}} where N,Vararg{Any,N} where N})
- [`JOLI.dalloc`](REFERENCE.md#JOLI.dalloc-Tuple{JOLI.joDAdistributor})
- [`JOLI.joAddSolverAll`](REFERENCE.md#JOLI.joAddSolverAll-Union{Tuple{DDT}, Tuple{JOLI.joAbstractLinearOperator{DDT,RDT},Function,Function,Function,Function}, Tuple{RDT}} where RDT where DDT)
- [`JOLI.joAddSolverAny`](REFERENCE.md#JOLI.joAddSolverAny-Union{Tuple{DDT}, Tuple{JOLI.joAbstractLinearOperator{DDT,RDT},Function}, Tuple{RDT}} where RDT where DDT)
- [`JOLI.joBlock`](REFERENCE.md#JOLI.joBlock-Union{Tuple{Array{RVDT,1},Vararg{JOLI.joAbstractLinearOperator,N} where N}, Tuple{RVDT}, Tuple{WDT}} where WDT<:Number where RVDT<:Integer)
- [`JOLI.joBlockDiag`](REFERENCE.md#JOLI.joBlockDiag-Union{Tuple{Integer,JOLI.joAbstractLinearOperator}, Tuple{WDT}} where WDT<:Number)
- [`JOLI.joBlockDiag`](REFERENCE.md#JOLI.joBlockDiag-Union{Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N}, Tuple{WDT}} where WDT<:Number)
- [`JOLI.joCurvelet2D`](REFERENCE.md#JOLI.joCurvelet2D-Tuple{Integer,Integer})
- [`JOLI.joCurvelet2DnoFFT`](REFERENCE.md#JOLI.joCurvelet2DnoFFT-Tuple{Integer,Integer})
- [`JOLI.joDCT`](REFERENCE.md#JOLI.joDCT-Tuple{Vararg{Integer,N} where N})
- [`JOLI.joDFT`](REFERENCE.md#JOLI.joDFT-Tuple{Vararg{Integer,N} where N})
- [`JOLI.joDict`](REFERENCE.md#JOLI.joDict-Union{Tuple{Integer,JOLI.joAbstractLinearOperator}, Tuple{WDT}} where WDT<:Number)
- [`JOLI.joDict`](REFERENCE.md#JOLI.joDict-Union{Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N}, Tuple{WDT}} where WDT<:Number)
- [`JOLI.joExtend`](REFERENCE.md#JOLI.joExtend-Tuple{Integer,Symbol})
- [`JOLI.joExtension`](REFERENCE.md#JOLI.joExtension-Union{Tuple{T,JOLI.EXT_TYPE}, Tuple{T}} where T<:Integer)
- [`JOLI.joLinearFunctionAll`](REFERENCE.md#JOLI.joLinearFunctionAll)
- [`JOLI.joLinearFunctionCT`](REFERENCE.md#JOLI.joLinearFunctionCT)
- [`JOLI.joLinearFunctionFwd`](REFERENCE.md#JOLI.joLinearFunctionFwd)
- [`JOLI.joLinearFunctionFwdCT`](REFERENCE.md#JOLI.joLinearFunctionFwdCT)
- [`JOLI.joLinearFunctionFwdT`](REFERENCE.md#JOLI.joLinearFunctionFwdT)
- [`JOLI.joLinearFunctionInplaceAll`](REFERENCE.md#JOLI.joLinearFunctionInplaceAll)
- [`JOLI.joLinearFunctionInplaceCT`](REFERENCE.md#JOLI.joLinearFunctionInplaceCT)
- [`JOLI.joLinearFunctionInplaceFwd`](REFERENCE.md#JOLI.joLinearFunctionInplaceFwd)
- [`JOLI.joLinearFunctionInplaceFwdCT`](REFERENCE.md#JOLI.joLinearFunctionInplaceFwdCT)
- [`JOLI.joLinearFunctionInplaceFwdT`](REFERENCE.md#JOLI.joLinearFunctionInplaceFwdT)
- [`JOLI.joLinearFunctionInplaceT`](REFERENCE.md#JOLI.joLinearFunctionInplaceT)
- [`JOLI.joLinearFunctionT`](REFERENCE.md#JOLI.joLinearFunctionT)
- [`JOLI.joLooseLinearFunctionAll`](REFERENCE.md#JOLI.joLooseLinearFunctionAll)
- [`JOLI.joLooseLinearFunctionCT`](REFERENCE.md#JOLI.joLooseLinearFunctionCT)
- [`JOLI.joLooseLinearFunctionFwd`](REFERENCE.md#JOLI.joLooseLinearFunctionFwd)
- [`JOLI.joLooseLinearFunctionFwdCT`](REFERENCE.md#JOLI.joLooseLinearFunctionFwdCT)
- [`JOLI.joLooseLinearFunctionFwdT`](REFERENCE.md#JOLI.joLooseLinearFunctionFwdT)
- [`JOLI.joLooseLinearFunctionInplaceAll`](REFERENCE.md#JOLI.joLooseLinearFunctionInplaceAll)
- [`JOLI.joLooseLinearFunctionInplaceCT`](REFERENCE.md#JOLI.joLooseLinearFunctionInplaceCT)
- [`JOLI.joLooseLinearFunctionInplaceFwd`](REFERENCE.md#JOLI.joLooseLinearFunctionInplaceFwd)
- [`JOLI.joLooseLinearFunctionInplaceFwdCT`](REFERENCE.md#JOLI.joLooseLinearFunctionInplaceFwdCT)
- [`JOLI.joLooseLinearFunctionInplaceFwdT`](REFERENCE.md#JOLI.joLooseLinearFunctionInplaceFwdT)
- [`JOLI.joLooseLinearFunctionInplaceT`](REFERENCE.md#JOLI.joLooseLinearFunctionInplaceT)
- [`JOLI.joLooseLinearFunctionT`](REFERENCE.md#JOLI.joLooseLinearFunctionT)
- [`JOLI.joMask`](REFERENCE.md#JOLI.joMask-Union{Tuple{Integer,Array{VDT,1}}, Tuple{VDT}} where VDT<:Integer)
- [`JOLI.joMask`](REFERENCE.md#JOLI.joMask-Tuple{BitArray{1}})
- [`JOLI.joNFFT`](REFERENCE.md#JOLI.joNFFT)
- [`JOLI.joRestriction`](REFERENCE.md#JOLI.joRestriction-Union{Tuple{Integer,Array{VDT,1}}, Tuple{VDT}} where VDT<:Integer)
- [`JOLI.joStack`](REFERENCE.md#JOLI.joStack-Union{Tuple{Integer,JOLI.joAbstractLinearOperator}, Tuple{WDT}} where WDT<:Number)
- [`JOLI.joStack`](REFERENCE.md#JOLI.joStack-Union{Tuple{Vararg{JOLI.joAbstractLinearOperator,N} where N}, Tuple{WDT}} where WDT<:Number)
- [`JOLI.jo_check_type_match`](REFERENCE.md#JOLI.jo_check_type_match-Tuple{DataType,DataType,String})
- [`JOLI.jo_complex_eltype`](REFERENCE.md#JOLI.jo_complex_eltype-Union{Tuple{Complex{T}}, Tuple{T}} where T)
- [`JOLI.jo_complex_eltype`](REFERENCE.md#JOLI.jo_complex_eltype-Tuple{DataType})
- [`JOLI.jo_convert`](REFERENCE.md#JOLI.jo_convert-Union{Tuple{DataType,AbstractArray{VT,N} where N,Bool}, Tuple{DataType,AbstractArray{VT,N} where N}, Tuple{VT}} where VT<:Integer)
- [`JOLI.jo_convert`](REFERENCE.md#JOLI.jo_convert-Union{Tuple{DataType,NT,Bool}, Tuple{DataType,NT}, Tuple{NT}} where NT<:Integer)
- [`JOLI.jo_convert_warn_set`](REFERENCE.md#JOLI.jo_convert_warn_set-Tuple{Bool})
- [`JOLI.jo_iterative_solver4square_set`](REFERENCE.md#JOLI.jo_iterative_solver4square_set-Tuple{Function})
- [`JOLI.jo_iterative_solver4tall_set`](REFERENCE.md#JOLI.jo_iterative_solver4tall_set-Tuple{Function})
- [`JOLI.jo_iterative_solver4wide_set`](REFERENCE.md#JOLI.jo_iterative_solver4wide_set-Tuple{Function})
- [`JOLI.jo_jo32bit_set`](REFERENCE.md#JOLI.jo_jo32bit_set-Tuple{})
- [`JOLI.jo_jo64bit_set`](REFERENCE.md#JOLI.jo_jo64bit_set-Tuple{})
- [`JOLI.jo_joComplex_set`](REFERENCE.md#JOLI.jo_joComplex_set)
- [`JOLI.jo_joFloat_set`](REFERENCE.md#JOLI.jo_joFloat_set)
- [`JOLI.jo_joInt_set`](REFERENCE.md#JOLI.jo_joInt_set)
- [`JOLI.jo_joTypes_get`](REFERENCE.md#JOLI.jo_joTypes_get-Tuple{})
- [`JOLI.jo_precision_type`](REFERENCE.md#JOLI.jo_precision_type-Union{Tuple{ITx}, Tuple{Tx}, Tuple{Tx}} where Tx<:Union{Complex{ITx}, ITx} where ITx<:Number)
- [`JOLI.jo_type_mismatch_error_set`](REFERENCE.md#JOLI.jo_type_mismatch_error_set-Tuple{Bool})
- [`JOLI.@joNF`](REFERENCE.md#JOLI.@joNF-Tuple{})
- [`JOLI.@joNF`](REFERENCE.md#JOLI.@joNF-Tuple{Expr})

