using SparseArrays
using LinearAlgebra
using Random
using JOLI # remove when done

function array_check(op::joAbstractLinearOperator)
    println("... $(op.name) ...")
    F=jo_full(elements(op))
    A=jo_full(elements(op'))
    #display(F);
    println("norm F: $(norm(F))")
    #display(A);
    println("norm A: $(norm(A))")
    s=size(F,2);
    cn=map(i->norm(F[:,i]),1:s)
    println("cnorm  F: ",cn')
    AF=jo_full(elements(op'*op))
    #display(AF);
    s=size(AF,2);
    cn=map(i->norm(AF[:,i]),1:s)
    d=map(i->AF[i,i],1:s)
    println("cnorm AF: ",cn')
    println("diag  AF: ",d')
    println("linear/adjoint: $(islinear(op)[1])/$(isadjoint(op)[1])")
    println("... done ...")
    println("............")
end

import JOLI.elements
elements(arg::Nothing)=nothing
import JOLI.jo_full
jo_full(arg::Nothing)=nothing
import LinearAlgebra.norm
norm(arg::Nothing)=nothing
import LinearAlgebra.adjoint
adjoint(arg::Nothing)=nothing

M=8; N=9;

A=joGaussian(M,N,RNG=Random.seed!())
array_check(A)
A=joGaussian(M,N,RNG=Random.seed!(),normalized=true)
array_check(A)

A=joGaussian(M,N,RNG=Random.seed!(),implicit=true)
array_check(A)
A=joGaussian(M,N,RNG=Random.seed!(),implicit=true,normalized=true)
array_check(A)

A=joGaussian(M,N,RNG=Random.seed!(),orthonormal=true)
array_check(A)
