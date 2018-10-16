# Renaming for some core constructors #

1. joLinearFunction

    - `joLinearFunctionT` -> `joLinearFunction_T`
    - `joLinearFunctionCT` -> `joLinearFunction_A`
    - `joLinearFunctionFwdT` -> `joLinearFunctionFwd_T`
    - `joLinearFunctionFwdCT` -> `joLinearFunctionFwd_A`

1. joLinearFunctionInplace

    - `joLinearFunctionInplaceT` -> `joLinearFunctionInplace_T`
    - `joLinearFunctionInplaceCT` -> `joLinearFunctionInplace_A`
    - `joLinearFunctionInplaceFwdT` -> `joLinearFunctionInplaceFwd_T`
    - `joLinearFunctionInplaceFwdCT` -> `joLinearFunctionInplaceFwd_A`

1. joLooseLinearFunction

    - `joLooseLinearFunctionT` -> `joLooseLinearFunction_T`
    - `joLooseLinearFunctionCT` -> `joLooseLinearFunction_A`
    - `joLooseLinearFunctionFwdT` -> `joLooseLinearFunctionFwd_T`
    - `joLooseLinearFunctionFwdCT` -> `joLooseLinearFunctionFwd_A`

1. joLooseLinearFunctionInplace

    - `joLooseLinearFunctionInplaceT` -> `joLooseLinearFunctionInplace_T`
    - `joLooseLinearFunctionInplaceCT` -> `joLooseLinearFunctionInplace_A`
    - `joLooseLinearFunctionInplaceFwdT` -> `joLooseLinearFunctionInplaceFwd_T`
    - `joLooseLinearFunctionInplaceFwdCT` -> `joLooseLinearFunctionInplaceFwd_A`

# Syntax changes

1. joSincInterp

    - from `joSincInterp(xin,xout;r=0,DomainT=...,RangeT=...)`
    - to `joSincInterp(xin,xout;r=0,DDT=...,RDT=...)`

# Internal fuctions in operators' `Struct` Types #

1. `fop_CT` replaced with `fop_A`

1. `iop_CT` replaced with `iop_A`

# Linear Algebra package #

1. Base.LinAlg function imported now from LinearAlgebra

1. In-place `*_mul_*!`  functions are gone and replaced with `mul!`

1. In-place `*_ldiv_*!` functions are gone and replaced with `ldiv!`

# Changes following from Julia's syntax changes #

1. `showall` is gone, and `display` now provides the same functionality

1. `op.'` short-hand notation for transpose(op) is gone

1. ctranspose(op) replaced by adjoint(op) in Julia

1. `jo_full`/`jo_eye`/`jo_speye` replacement for deprecated Julia's `full`/`eye`/`speye`

1. `tic`/`toc`/`toq` are gone; use `@time` or `time`

1. `warn`/`info`/`error` converted to macros `@warn`/`@info`/`@error`

# Removed JOLI deprecations #

1. removed deprecated `joExtension`; use `joExtend`
