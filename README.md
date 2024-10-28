# JOLI - Julia Operators LIbrary

[![Build Status](https://travis-ci.org/slimgroup/JOLI.jl.svg?branch=master)](https://travis-ci.org/slimgroup/JOLI.jl)
[![Citation DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3883023.svg)](https://doi.org/10.5281/zenodo.3883023)
[[REFERENCE guide](https://slimgroup.github.io/JOLI.jl)]
[[Tutorials](tutorials/)]

**Julia framework for constructing matrix-free linear operators
with explicit domain/range type control
and applying them in basic algebraic matrix-vector operations.**

Julia Operator LIbrary (JOLI) is a package for creating
algebraic operators (currently linear only) and use them
in a way that tries to mimic the mathematical formulas of
basics algebra.

The package was created in SLIM group at the University of
British Columbia for their work in seismic imaging and modelling.

JOLI has a collection of methods that allow creating and
use of element-free operators, operators created from explicit
Matrices, and composing all of those into complex formulas that
are not explicitly executed until they act on the Vector or Matrix.
'*', '+', '-', and etc... operations are supported in any mathematically
valid combination of operators and vectors as long as vector is on the
right side of the operator. Composite operators can be
defined before they are used to act on vectors.

JOLI operators support operations like adjoint, transpose,
and conjugate for element-free operators provided that enough
functionality is provided when constructing JOLI operator.

JOLI operators support and enforce consistency of domain and range
data types for operators with both vectors acted upon and created
by operators. JOLI also has the functionality that allows easily to
switch precision of computations using global type definitions.

Contrary to other linear-operators Julia packages, JOLI operators act on
matrices as if those were column-wise collections of vectors. I.e.
JOLI operator does not treat explicit matrix on left side of '*' as
another operator, and will act on it immediately. Such behaviour
is convenient for implementation of Kronecker product.

## INSTALLATION

JOLI is registered and can be added like any standard julia package with the command:

```
] add JOLI
```

### 3-Rd Party Libraries ###

- **CurveLab**: In order to use `joCurvelet2D` or `joCurvelet2DnoFFT` operators, you need to obtain *CurveLab-2.1.2-SLIM*, a SLIM extension to *CurveLab-2.1.2*. The tarball of this extension is available from [curvelet.org](http://www.curvelet.org) under [Software](http://www.curvelet.org/software.html) tab. The installation instructions are included in the tarball of *CurveLab-2.1.2-SLIM*. Note, that CurveLab is free only for academic use and requires registration.

- **PyWavelets**: In order to use `joSWT` that implements 1D stationary/shift invariant wavelet transform, the [PyWavelets](https://github.com/PyWavelets/pywt) package needs to be installed within the python environment used by [PythonCall.jl](https://github.com/JuliaPy/PythonCall.jl). By default, it will use [CondaPkg.jl](https://github.com/JuliaPy/CondaPkg.jl) and you should follow its directiv to install a package within it. If you have configured `PythonCall` with your own python environment you can install `PyWavelets` via `pip install --upgrade PyWavelets`.

## Documentation (more to come)

- [REFERENCE guide](https://slimgroup.github.io/JOLI.jl).
- [Tutorials](tutorials/)

## Examples (more to come)

Check [examples](examples) for the examples of how to build your own operators or types,
or look up DCT implementation in [src/joLinearFunctionConstructors/joDCT.jl](src/joLinearFunctionConstructors/joDCT.jl).

Try [templates/joLinearFunctionFwd.jl](templates/joLinearFunctionFwd.jl) as a starting point for building your own operators.
