# JOLI - Julia Operators LIbrary

Julia framework for constructing matrix-free linear operators
with explicite domain/range type control
and applying them in basic algebraic matrix-vector operations.

[![Build Status](https://travis-ci.org/slimgroup/JOLI.jl.svg?branch=master)](https://travis-ci.org/slimgroup/JOLI.jl)

## INSTALLATION

### Using SLIM Registry (preferred method) ###

First switch to package manager prompt (using ']') and add SLIM registry:

```
	registry add https://github.com/slimgroup/SLIMregistryJL.git
```

Then still from package manager prompt add JOLI:

```
	add JOLI
```

### Adding without SLIM registry ###

After switching to package manager prompt (using ']') type:

```
	add https://github.com/slimgroup/JOLI.jl.git
```

## Documentation (more to come)

For now it is just [REFERENCE guide](REFERENCE.md).

## Examples (more to come)

Check [templates](templates) for an examples of how to build your own operators or types,
or look up DCT implementation in [src/joLinearFunctionConstructors/joDCT.jl](src/joLinearFunctionConstructors/joDCT.jl).
