############################################################
## joAbstractLinearOperator - overloaded Base functions

# eltype(jo)

# deltype(jo)

# reltype(jo)

# show(jo)

# showall(jo)

# display(jo)

# size(jo)

# size(jo,1/2)

# length(jo)

# full(jo)

# norm(jo)

# vecnorm(jo)

# real(jo)

# imag(jo)

# conj(jo)

# transpose(jo)

# ctranspose(jo)

# isreal(jo)

# issymmetric(jo)

# ishermitian(jo)

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)

# *(jo,mvec)

# *(mvec,jo)

# *(jo,vec)

# *(vec,jo)

# *(num,jo)

# *(jo,num)

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)

# \(jo,mvec)

# \(mvec,jo)

# \(jo,vec)

# \(vec,jo)

# \(num,jo)

# \(jo,num)

############################################################
## overloaded Base +(...jo...)

# +(jo)

# +(jo,jo)

# +(jo,mvec)

# +(mvec,jo)

# +(jo,vec)

# +(vec,jo)

# +(jo,num)

# +(num,jo)

############################################################
## overloaded Base -(...jo...)

# -(jo)

# -(jo,jo)

# -(jo,mvec)

# -(mvec,jo)

# -(jo,vec)

# -(vec,jo)

# -(jo,num)

# -(num,jo)

############################################################
## overloaded Base .*(...jo...)
## function Base.broadcast(::typeof(*), ...)

# .*(jo,jo)
##.*(A::joAbstractLinearOperator,B::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".*(jo,jo) not implemented"))

# .*(jo,mvec)
##.*(A::joAbstractLinearOperator,mv::AbstractMatrix) = throw(joAbstractLinearOperatorException(".*(jo,mvec) not implemented"))

# .*(mvec,jo)
##.*(mv::AbstractMatrix,A::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".*(mvec,jo) not implemented"))

# .*(jo,vec)
##.*(A::joAbstractLinearOperator,v::AbstractVector) = throw(joAbstractLinearOperatorException(".*(jo,vec) not implemented"))

# .*(vec,jo)
##.*(v::AbstractVector,A::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".*(vec,jo) not implemented"))

# .*(num,jo)
##.*(a,A::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".*(any,jo) not implemented"))

# .*(jo,num)
##.*(A::joAbstractLinearOperator,a) = throw(joAbstractLinearOperatorException(".*(jo,any) not implemented"))

############################################################
## overloaded Base .\(...jo...)
## function Base.broadcast(::typeof(\), ...)

# .\(jo,jo)
##.\(A::joAbstractLinearOperator,B::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".\(jo,jo) not implemented"))

# .\(jo,mvec)
##.\(A::joAbstractLinearOperator,mv::AbstractMatrix) = throw(joAbstractLinearOperatorException(".\(jo,mvec) not implemented"))

# .\(mvec,jo)
##.\(mv::AbstractMatrix,A::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".\(mvec,jo) not implemented"))

# .\(jo,vec)
##.\(A::joAbstractLinearOperator,v::AbstractVector) = throw(joAbstractLinearOperatorException(".\(jo,vec) not implemented"))

# .\(vec,jo)
##.\(v::AbstractVector,A::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".\(vec,jo) not implemented"))

# .\(num,jo)
##.\(a,A::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".\(any,jo) not implemented"))

# .\(jo,num)
##.\(A::joAbstractLinearOperator,a) = throw(joAbstractLinearOperatorException(".\(jo,any) not implemented"))

############################################################
## overloaded Base .+(...jo...)
## function Base.broadcast(::typeof(+), ...)

# .+(jo,jo)
##.+(A::joAbstractLinearOperator,B::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".+(jo,jo) not implemented"))

# .+(jo,mvec)
##.+(A::joAbstractLinearOperator,mv::AbstractMatrix) = throw(joAbstractLinearOperatorException(".+(jo,mvec) not implemented"))

# .+(mvec,jo)
##.+(mv::AbstractMatrix,A::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".+(mvec,jo) not implemented"))

# .+(jo,vec)
##.+(A::joAbstractLinearOperator,v::AbstractVector) = throw(joAbstractLinearOperatorException(".+(jo,vec) not implemented"))

# .+(vec,jo)
##.+(v::AbstractVector,A::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".+(vec,jo) not implemented"))

# .+(jo,num)
##.+(A::joAbstractLinearOperator,b) = throw(joAbstractLinearOperatorException(".+(jo,any) not implemented"))

# .+(num,jo)
##.+(b,A::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".+(any,jo) not implemented"))

############################################################
## overloaded Base .-(...jo...)
## function Base.broadcast(::typeof(-), ...)

# .-(jo,jo)
##.-(A::joAbstractLinearOperator,B::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".-(jo,jo) not implemented"))

# .-(jo,mvec)
##.-(A::joAbstractLinearOperator,mv::AbstractMatrix) = throw(joAbstractLinearOperatorException(".-(jo,mvec) not implemented"))

# .-(mvec,jo)
##.-(mv::AbstractMatrix,A::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".-(mvec,jo) not implemented"))

# .-(jo,vec)
##.-(A::joAbstractLinearOperator,v::AbstractVector) = throw(joAbstractLinearOperatorException(".-(jo,vec) not implemented"))

# .-(vec,jo)
##.-(v::AbstractVector,A::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".-(vec,jo) not implemented"))

# .-(jo,num)
##.-(A::joAbstractLinearOperator,b) = throw(joAbstractLinearOperatorException(".-(jo,any) not implemented"))

# .-(num,jo)
##.-(b,A::joAbstractLinearOperator) = throw(joAbstractLinearOperatorException(".-(any,jo).' not implemented"))

############################################################
## overloaded Base block methods

# hcat(...jo...)

# vcat(...jo...)

# hvcat(...jo...)

############################################################
## overloaded Base.LinAlg functions

# A_mul_B!(...,jo,...)

# At_mul_B!(...,jo,...)

# Ac_mul_B!(...,jo,...)

# A_ldiv_B!(...,jo,...)

# At_ldiv_B!(...,jo,...)

# Ac_ldiv_B!(...,jo,...)

