
<a id='JOLI-reference-1'></a>

# JOLI reference

- [JOLI reference](REFERENCE.md#JOLI-reference-1)
    - [Functions](REFERENCE.md#Functions-1)
    - [Macros](REFERENCE.md#Macros-1)
    - [Types](REFERENCE.md#Types-1)
    - [Index](REFERENCE.md#Index-1)


<a id='Functions-1'></a>

## Functions

<a id='JOLI.joAddSolverAll-Tuple{JOLI.joAbstractLinearOperator{DDT,RDT},Function,Function,Function,Function}' href='#JOLI.joAddSolverAll-Tuple{JOLI.joAbstractLinearOperator{DDT,RDT},Function,Function,Function,Function}'>#</a>
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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearOperator/constructors.jl#L29-L55' class='documenter-source'>source</a><br>

<a id='JOLI.joAddSolverAny-Tuple{JOLI.joAbstractLinearOperator{DDT,RDT},Function}' href='#JOLI.joAddSolverAny-Tuple{JOLI.joAbstractLinearOperator{DDT,RDT},Function}'>#</a>
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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearOperator/constructors.jl#L6-L17' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearOperatorConstructors/joCoreBlockConstructors/joBlock.jl#L14-L43' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearOperatorConstructors/joCoreBlockConstructors/joBlockDiag.jl#L83-L99' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearOperatorConstructors/joCoreBlockConstructors/joBlockDiag.jl#L14-L36' class='documenter-source'>source</a><br>

<a id='JOLI.joCurvelet2D-Tuple{Integer,Integer}' href='#JOLI.joCurvelet2D-Tuple{Integer,Integer}'>#</a>
**`JOLI.joCurvelet2D`** &mdash; *Method*.



2D Curvelet transform (wrapping) over fast dimensions

```
joCurvelet2D(n1,n2
            [;DDT=Float64,RDT=DDT,
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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearFunctionConstructors/joCurvelet2D.jl#L43-L71' class='documenter-source'>source</a><br>

<a id='JOLI.joCurvelet2DnoFFT-Tuple{Integer,Integer}' href='#JOLI.joCurvelet2DnoFFT-Tuple{Integer,Integer}'>#</a>
**`JOLI.joCurvelet2DnoFFT`** &mdash; *Method*.



2D Curvelet transform (wrapping) over fast dimensions without FFT

```
joCurvelet2DnoFFT(n1,n2
            [;DDT=Complex{Float64},RDT=DDT,
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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearFunctionConstructors/joCurvelet2DnoFFT.jl#L44-L72' class='documenter-source'>source</a><br>

<a id='JOLI.joDCT-Tuple{Vararg{Integer,N}}' href='#JOLI.joDCT-Tuple{Vararg{Integer,N}}'>#</a>
**`JOLI.joDCT`** &mdash; *Method*.



Multi-dimensional DCT transform over fast dimension(s)

```
joDCT(m[,n[, ...]] [;DDT=Float64,RDT=DDT])
```

**Examples**

  * joDCT(m) - 1D DCT
  * joDCT(m,n) - 2D DCT
  * joDCT(m; DDT=Float32) - 1D DCT for 32-bit vectors
  * joDCT(m; DDT=Float32,RDT=Float64) - 1D DCT for 32-bit input and 64-bit output


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearFunctionConstructors/joDCT.jl#L32-L43' class='documenter-source'>source</a><br>

<a id='JOLI.joDFT-Tuple{Vararg{Integer,N}}' href='#JOLI.joDFT-Tuple{Vararg{Integer,N}}'>#</a>
**`JOLI.joDFT`** &mdash; *Method*.



Multi-dimensional FFT transform over fast dimension(s)

```
joDFT(m[,n[, ...]]
        [;centered=false,DDT=Float64,RDT=(DDT:<Real?Complex{DDT}:DDT)])
```

**Examples**

  * joDFT(m) - 1D FFT
  * joDFT(m; centered=true) - 1D FFT with centered coefficients
  * joDFT(m,n) - 2D FFT
  * joDFT(m; DDT=Float32) - 1D FFT for 32-bit input
  * joDFT(m; DDT=Float32,RDT=Complex{Float64}) - 1D FFT for 32-bit input and 64-bit output

**Notes**

  * if DDT:<Real then imaginary part will be neglected for transpose/ctranspose


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearFunctionConstructors/joDFT.jl#L62-L79' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearOperatorConstructors/joCoreBlockConstructors/joDict.jl#L85-L103' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearOperatorConstructors/joCoreBlockConstructors/joDict.jl#L14-L39' class='documenter-source'>source</a><br>

<a id='JOLI.joExtension-Tuple{T<:Integer,JOLI.EXT_TYPE}' href='#JOLI.joExtension-Tuple{T<:Integer,JOLI.EXT_TYPE}'>#</a>
**`JOLI.joExtension`** &mdash; *Method*.



1D extension operator 

joExtension(n,pad_type; pad_lower=0,pad_upper=0,DDT=Float64,RDT=DDT)

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearFunctionConstructors/joExtension.jl#L40-L64' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearFunction/constructors.jl#L4-L19' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearFunction/constructors.jl#L62-L76' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearFunction/constructors.jl#L94-L108' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearFunction/constructors.jl#L146-L160' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearFunction/constructors.jl#L118-L132' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearFunction/constructors.jl#L30-L44' class='documenter-source'>source</a><br>

<a id='JOLI.joNFFT' href='#JOLI.joNFFT'>#</a>
**`JOLI.joNFFT`** &mdash; *Function*.



1D NFFT transform over fast dimension (wrapper to https://github.com/tknopp/NFFT.jl/tree/master)

```
joNFFT(N,nodes::Vector{Float64} [,m=4,sigma=2.0,window=:kaiser_bessel,K=2000;centered=false,DDT=Complex{Float64},RDT=DDT])
```

**Examples**

  * joNFFT(N,nodes) - 1D NFFT

**Notes**

  * NFFT always uses Complex{Float64} vectors internally
  * see https://github.com/tknopp/NFFT.jl/tree/master for docs for optional parameters to NFFTplan


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearFunctionConstructors/joNFFT.jl#L34-L46' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearOperatorConstructors/joCoreBlockConstructors/joStack.jl#L85-L103' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearOperatorConstructors/joCoreBlockConstructors/joStack.jl#L14-L39' class='documenter-source'>source</a><br>

<a id='JOLI.jo_check_type_match-Tuple{DataType,DataType,String}' href='#JOLI.jo_check_type_match-Tuple{DataType,DataType,String}'>#</a>
**`JOLI.jo_check_type_match`** &mdash; *Method*.



Check type match

```
jo_check_type_match(DT1::DataType,DT2::DataType,where::String)
```

The bahaviour of the function while types do not match depends on values of jo_type_mismatch_warn and jo_type_mismatch_error flags. Use jo_type_mismatch_error_set to toggle those flags from warning mode to error mode.

**EXAMPLE**

  * jo_check_type_match(Float32,Float64,"my session")


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/Utils.jl#L157-L170' class='documenter-source'>source</a><br>

<a id='JOLI.jo_complex_eltype-Tuple{Complex{T}}' href='#JOLI.jo_complex_eltype-Tuple{Complex{T}}'>#</a>
**`JOLI.jo_complex_eltype`** &mdash; *Method*.



Type of element of complex scalar

```
jo_complex_eltype(a::Complex)
```

**Example**

  * jo_complex_eltype(1.+im*1.)
  * jo_complex_eltype(zero(Complex{Float64}))


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/Utils.jl#L97-L106' class='documenter-source'>source</a><br>

<a id='JOLI.jo_complex_eltype-Tuple{DataType}' href='#JOLI.jo_complex_eltype-Tuple{DataType}'>#</a>
**`JOLI.jo_complex_eltype`** &mdash; *Method*.



Type of element of complex data type

```
jo_complex_eltype(DT::DataType)
```

**Example**

  * jo_complex_eltype(Complex{Float32})


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/Utils.jl#L108-L116' class='documenter-source'>source</a><br>

<a id='JOLI.jo_convert' href='#JOLI.jo_convert'>#</a>
**`JOLI.jo_convert`** &mdash; *Function*.



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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/Utils.jl#L251-L265' class='documenter-source'>source</a><br>

<a id='JOLI.jo_convert' href='#JOLI.jo_convert'>#</a>
**`JOLI.jo_convert`** &mdash; *Function*.



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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/Utils.jl#L199-L213' class='documenter-source'>source</a><br>

<a id='JOLI.jo_convert_warn_set-Tuple{Bool}' href='#JOLI.jo_convert_warn_set-Tuple{Bool}'>#</a>
**`JOLI.jo_convert_warn_set`** &mdash; *Method*.



Set warning mode for jo_convert

```
jo_convert_warn_set(flag::Bool)
```

**Example**

  * jo_convert_warn_set(false) turns of the warnings


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/Utils.jl#L184-L192' class='documenter-source'>source</a><br>

<a id='JOLI.jo_set_iterative_solver4square-Tuple{Function}' href='#JOLI.jo_set_iterative_solver4square-Tuple{Function}'>#</a>
**`JOLI.jo_set_iterative_solver4square`** &mdash; *Method*.



Set default iterative solver for (jo,vec) and square jo

```
jo_set_iterative_solver4square(f::Function)
```

Where f must take two arguments (jo,vec) and return vec.

**Example (using IterativeSolvers)**

  * jo_set_iterative_solver4square((A,v)->gmres(A,v)[1])


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/Utils.jl#L36-L46' class='documenter-source'>source</a><br>

<a id='JOLI.jo_set_iterative_solver4tall-Tuple{Function}' href='#JOLI.jo_set_iterative_solver4tall-Tuple{Function}'>#</a>
**`JOLI.jo_set_iterative_solver4tall`** &mdash; *Method*.



Set default iterative solver for (jo,vec) and tall jo

```
jo_set_iterative_solver4tall(f::Function)
```

Where f must take two arguments (jo,vec) and return vec.

**Example**

  * jo_set_iterative_solver4tall((A,v)->tall_solve(A,v))


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/Utils.jl#L56-L66' class='documenter-source'>source</a><br>

<a id='JOLI.jo_set_iterative_solver4wide-Tuple{Function}' href='#JOLI.jo_set_iterative_solver4wide-Tuple{Function}'>#</a>
**`JOLI.jo_set_iterative_solver4wide`** &mdash; *Method*.



Set default iterative solver for (jo,vec) and wide jo

```
jo_set_iterative_solver4wide(f::Function)
```

Where f must take two arguments (jo,vec) and return vec.

**Example**

  * jo_set_iterative_solver4wide((A,v)->wide_solve(A,v))


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/Utils.jl#L76-L86' class='documenter-source'>source</a><br>

<a id='JOLI.jo_type_mismatch_error_set-Tuple{Bool}' href='#JOLI.jo_type_mismatch_error_set-Tuple{Bool}'>#</a>
**`JOLI.jo_type_mismatch_error_set`** &mdash; *Method*.



Toggle between warning and error for type mismatch

```
jo_type_mismatch_error_set(flag::Bool)
```

**Examples**

  * jo_type_mismatch_error_set(true) turns on error
  * jo_type_mismatch_error_set(false) reverts to warnings


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/Utils.jl#L129-L138' class='documenter-source'>source</a><br>


<a id='Macros-1'></a>

## Macros

<a id='JOLI.@joNF-Tuple{Expr}' href='#JOLI.@joNF-Tuple{Expr}'>#</a>
**`JOLI.@joNF`** &mdash; *Macro*.



Nullable{Function} macro for given function

```
@joNF ... | @joNF(...)
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/Utils.jl#L23-L27' class='documenter-source'>source</a><br>

<a id='JOLI.@joNF-Tuple{}' href='#JOLI.@joNF-Tuple{}'>#</a>
**`JOLI.@joNF`** &mdash; *Macro*.



Nullable{Function} macro for null function

```
@joNF
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/Utils.jl#L14-L18' class='documenter-source'>source</a><br>


<a id='Types-1'></a>

## Types

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
BD=joCoreBlock(A,B,C;moffsets=moff,noffsets=noff,ME=5,NE=5) # sparse blocks with zero extansion of (ME,NE) size
BD=joCoreBlock(A,B,C) # basic diagonal-corners adjacent blocks
w=rand(Complex{Float64},3)
BD=joCoreBlock(A,B,C;weights=w) # weighted basic diagonal-corners adjacent blocks
```

**Notes**

  * all given operators must have same domain/range types
  * the domain/range types of joCoreBlock are equal to domain/range types of the given operators


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearOperatorConstructors/joCoreBlock.jl#L40-L65' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearOperatorConstructors/joKron.jl#L38-L56' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearFunction.jl#L13-L35' class='documenter-source'>source</a><br>

<a id='JOLI.joLinearOperator' href='#JOLI.joLinearOperator'>#</a>
**`JOLI.joLinearOperator`** &mdash; *Type*.



```
joLinearOperator is glueing type & constructor

!!! Do not use it to create the operators
!!! Use joMatrix and joLinearFunction constructors
```


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearOperator.jl#L14-L20' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joMatrix.jl#L10-L30' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joMatrix/constructors.jl#L4-L24' class='documenter-source'>source</a><br>

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


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/MiscTypes.jl#L8-L21' class='documenter-source'>source</a><br>

<a id='JOLI.joNumber-Tuple{NT<:Number,JOLI.joAbstractLinearOperator{DDT,RDT}}' href='#JOLI.joNumber-Tuple{NT<:Number,JOLI.joAbstractLinearOperator{DDT,RDT}}'>#</a>
**`JOLI.joNumber`** &mdash; *Method*.



joNumber outer constructor

```
joNumber(num,A::joAbstractLinearOperator{DDT,RDT})
```

Create joNumber with types matching the given operator.


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/joLinearOperator/constructors.jl#L71-L78' class='documenter-source'>source</a><br>

<a id='JOLI.joNumber-Tuple{NT<:Number}' href='#JOLI.joNumber-Tuple{NT<:Number}'>#</a>
**`JOLI.joNumber`** &mdash; *Method*.



joNumber outer constructor

```
joNumber(num)
```

Create joNumber with types matching given number


<a target='_blank' href='https://github.com/slimgroup/JOLI.jl/tree/7ea7b5cb4cc24e621fd9e52e9e1940e907a6d066/src/MiscTypes.jl#L26-L33' class='documenter-source'>source</a><br>


<a id='Index-1'></a>

## Index

- [`JOLI.joCoreBlock`](REFERENCE.md#JOLI.joCoreBlock-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}})
- [`JOLI.joKron`](REFERENCE.md#JOLI.joKron-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}})
- [`JOLI.joLinearFunction`](REFERENCE.md#JOLI.joLinearFunction)
- [`JOLI.joLinearOperator`](REFERENCE.md#JOLI.joLinearOperator)
- [`JOLI.joMatrix`](REFERENCE.md#JOLI.joMatrix)
- [`JOLI.joMatrix`](REFERENCE.md#JOLI.joMatrix-Tuple{AbstractArray{EDT,2}})
- [`JOLI.joNumber`](REFERENCE.md#JOLI.joNumber-Tuple{NT<:Number,JOLI.joAbstractLinearOperator{DDT,RDT}})
- [`JOLI.joNumber`](REFERENCE.md#JOLI.joNumber)
- [`JOLI.joNumber`](REFERENCE.md#JOLI.joNumber-Tuple{NT<:Number})
- [`JOLI.joAddSolverAll`](REFERENCE.md#JOLI.joAddSolverAll-Tuple{JOLI.joAbstractLinearOperator{DDT,RDT},Function,Function,Function,Function})
- [`JOLI.joAddSolverAny`](REFERENCE.md#JOLI.joAddSolverAny-Tuple{JOLI.joAbstractLinearOperator{DDT,RDT},Function})
- [`JOLI.joBlock`](REFERENCE.md#JOLI.joBlock-Tuple{Array{RVDT<:Integer,1},Vararg{JOLI.joAbstractLinearOperator,N}})
- [`JOLI.joBlockDiag`](REFERENCE.md#JOLI.joBlockDiag-Tuple{Integer,JOLI.joAbstractLinearOperator})
- [`JOLI.joBlockDiag`](REFERENCE.md#JOLI.joBlockDiag-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}})
- [`JOLI.joCurvelet2D`](REFERENCE.md#JOLI.joCurvelet2D-Tuple{Integer,Integer})
- [`JOLI.joCurvelet2DnoFFT`](REFERENCE.md#JOLI.joCurvelet2DnoFFT-Tuple{Integer,Integer})
- [`JOLI.joDCT`](REFERENCE.md#JOLI.joDCT-Tuple{Vararg{Integer,N}})
- [`JOLI.joDFT`](REFERENCE.md#JOLI.joDFT-Tuple{Vararg{Integer,N}})
- [`JOLI.joDict`](REFERENCE.md#JOLI.joDict-Tuple{Integer,JOLI.joAbstractLinearOperator})
- [`JOLI.joDict`](REFERENCE.md#JOLI.joDict-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}})
- [`JOLI.joExtension`](REFERENCE.md#JOLI.joExtension-Tuple{T<:Integer,JOLI.EXT_TYPE})
- [`JOLI.joLinearFunctionAll`](REFERENCE.md#JOLI.joLinearFunctionAll)
- [`JOLI.joLinearFunctionCT`](REFERENCE.md#JOLI.joLinearFunctionCT)
- [`JOLI.joLinearFunctionFwd`](REFERENCE.md#JOLI.joLinearFunctionFwd)
- [`JOLI.joLinearFunctionFwdCT`](REFERENCE.md#JOLI.joLinearFunctionFwdCT)
- [`JOLI.joLinearFunctionFwdT`](REFERENCE.md#JOLI.joLinearFunctionFwdT)
- [`JOLI.joLinearFunctionT`](REFERENCE.md#JOLI.joLinearFunctionT)
- [`JOLI.joNFFT`](REFERENCE.md#JOLI.joNFFT)
- [`JOLI.joStack`](REFERENCE.md#JOLI.joStack-Tuple{Vararg{JOLI.joAbstractLinearOperator,N}})
- [`JOLI.joStack`](REFERENCE.md#JOLI.joStack-Tuple{Integer,JOLI.joAbstractLinearOperator})
- [`JOLI.jo_check_type_match`](REFERENCE.md#JOLI.jo_check_type_match-Tuple{DataType,DataType,String})
- [`JOLI.jo_complex_eltype`](REFERENCE.md#JOLI.jo_complex_eltype-Tuple{Complex{T}})
- [`JOLI.jo_complex_eltype`](REFERENCE.md#JOLI.jo_complex_eltype-Tuple{DataType})
- [`JOLI.jo_convert`](REFERENCE.md#JOLI.jo_convert)
- [`JOLI.jo_convert`](REFERENCE.md#JOLI.jo_convert)
- [`JOLI.jo_convert_warn_set`](REFERENCE.md#JOLI.jo_convert_warn_set-Tuple{Bool})
- [`JOLI.jo_set_iterative_solver4square`](REFERENCE.md#JOLI.jo_set_iterative_solver4square-Tuple{Function})
- [`JOLI.jo_set_iterative_solver4tall`](REFERENCE.md#JOLI.jo_set_iterative_solver4tall-Tuple{Function})
- [`JOLI.jo_set_iterative_solver4wide`](REFERENCE.md#JOLI.jo_set_iterative_solver4wide-Tuple{Function})
- [`JOLI.jo_type_mismatch_error_set`](REFERENCE.md#JOLI.jo_type_mismatch_error_set-Tuple{Bool})
- [`JOLI.@joNF`](REFERENCE.md#JOLI.@joNF-Tuple{Expr})
- [`JOLI.@joNF`](REFERENCE.md#JOLI.@joNF-Tuple{})

