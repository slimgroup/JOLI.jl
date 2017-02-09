############################################################
# joAbstractOperator #######################################
############################################################

export joAbstractOperator, joAbstractLinearOperator, joAbstractOperatorException

############################################################
## type definition

abstract joAbstractOperator{EDT<:Number,DDT<:Number,RDT<:Number}
abstract joAbstractLinearOperator{EDT<:Number,DDT<:Number,RDT<:Number} <: joAbstractOperator{EDT,DDT,RDT}

type joAbstractOperatorException <: Exception
    msg :: String
end
type joAbstractLinearOperatorException <: Exception
    msg :: String
end


############################################################
## outer constructors

############################################################
## overloaded Base functions

# eltype(jo)
eltype{EDT,DDT,RDT}(A::joAbstractOperator{EDT,DDT,RDT}) = EDT

# deltype(jo)
deltype{EDT,DDT,RDT}(A::joAbstractOperator{EDT,DDT,RDT}) = DDT

# reltype(jo)
reltype{EDT,DDT,RDT}(A::joAbstractOperator{EDT,DDT,RDT}) = RDT

# show(jo)
show(A::joAbstractOperator) = throw(joAbstractOperatorException("show(jo) not implemented"))

# showall(jo)
showall(A::joAbstractOperator) = throw(joAbstractOperatorException("showall(jo) not implemented"))

# display(jo)
display(A::joAbstractOperator) = throw(joAbstractOperatorException("display(jo) not implemented"))

# size(jo)
size(A::joAbstractOperator) = throw(joAbstractOperatorException("size(jo) not implemented"))

# size(jo,1/2)
size(A::joAbstractOperator,ind::Integer) = throw(joAbstractOperatorException("size(jo,1/2) not implemented"))

# length(jo)
length(A::joAbstractOperator) = throw(joAbstractOperatorException("length(jo) not implemented"))

# full(jo)
full(A::joAbstractOperator) = throw(joAbstractOperatorException("full(jo) not implemented"))

# norm(jo)
norm(A::joAbstractOperator,p::Real=2) = throw(joAbstractOperatorException("norm(jo) not implemented"))

# vecnorm(jo)
vecnorm(A::joAbstractOperator,p::Real=2) = throw(joAbstractOperatorException("vecnorm(jo) not implemented"))

# real(jo)
real(A::joAbstractOperator) = throw(joAbstractOperatorException("real(jo) not implemented"))

# imag(jo)
imag(A::joAbstractOperator) = throw(joAbstractOperatorException("imag(jo) not implemented"))

# conj(jo)
conj(A::joAbstractOperator) = throw(joAbstractOperatorException("conj(jo) not implemented"))

# transpose(jo)
transpose(A::joAbstractOperator) = throw(joAbstractOperatorException("jo.' not implemented"))

# ctranspose(jo)
ctranspose(A::joAbstractOperator) = throw(joAbstractOperatorException("jo' not implemented"))

# isreal(jo)
isreal(A :: joAbstractOperator) = throw(joAbstractOperatorException("isreal(jo) not implemented"))

# issymmetric(jo)
issymmetric(A :: joAbstractOperator) = throw(joAbstractOperatorException("issymmetric(jo) not implemented"))

# ishermitian(jo)
ishermitian(A :: joAbstractOperator) = throw(joAbstractOperatorException("ishermitian(jo) not implemented"))

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
*(A::joAbstractOperator,B::joAbstractOperator) = throw(joAbstractOperatorException("*(jo,jo) not implemented"))

# *(jo,mvec)
*(A::joAbstractOperator,mv::AbstractMatrix) = throw(joAbstractOperatorException("*(jo,mvec) not implemented"))

# *(mvec,jo)
*(mv::AbstractMatrix,A::joAbstractOperator) = throw(joAbstractOperatorException("*(mvec,jo) not implemented"))

# *(jo,vec)
*(A::joAbstractOperator,v::AbstractVector) = throw(joAbstractOperatorException("*(jo,vec) not implemented"))

# *(vec,jo)
*(v::AbstractVector,A::joAbstractOperator) = throw(joAbstractOperatorException("*(vec,jo) not implemented"))

# *(num,jo)
*(a::Number,A::joAbstractOperator) = throw(joAbstractOperatorException("*(num,jo) not implemented"))

# *(jo,num)
*(A::joAbstractOperator,a::Number) = throw(joAbstractOperatorException("*(jo,num) not implemented"))

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)
\(A::joAbstractOperator,B::joAbstractOperator) = throw(joAbstractOperatorException("\(jo,jo) not implemented"))

# \(jo,mvec)
\(A::joAbstractOperator,mv::AbstractMatrix) = throw(joAbstractOperatorException("\(jo,mvec) not implemented"))

# \(mvec,jo)
\(mv::AbstractMatrix,A::joAbstractOperator) = throw(joAbstractOperatorException("\(mvec,jo) not implemented"))

# \(jo,vec)
\(A::joAbstractOperator,v::AbstractVector) = throw(joAbstractOperatorException("\(jo,vec) not implemented"))

# \(vec,jo)
\(v::AbstractVector,A::joAbstractOperator) = throw(joAbstractOperatorException("\(vec,jo) not implemented"))

# \(num,jo)
\(a::Number,A::joAbstractOperator) = throw(joAbstractOperatorException("\(num,jo) not implemented"))

# \(jo,num)
\(A::joAbstractOperator,a::Number) = throw(joAbstractOperatorException("\(jo,num) not implemented"))

############################################################
## overloaded Base +(...jo...)

# +(jo)
+(A::joAbstractOperator)  = throw(joAbstractOperatorException("+(jo) not implemented"))

# +(jo,jo)
+(A::joAbstractOperator,B::joAbstractOperator) = throw(joAbstractOperatorException("+(jo,jo) not implemented"))

# +(jo,mvec)
+(A::joAbstractOperator,mv::AbstractMatrix) = throw(joAbstractOperatorException("+(jo,mvec) not implemented"))

# +(mvec,jo)
+(mv::AbstractMatrix,A::joAbstractOperator) = throw(joAbstractOperatorException("+(mvec,jo) not implemented"))

# +(jo,vec)
+(A::joAbstractOperator,v::AbstractVector) = throw(joAbstractOperatorException("+(jo,vec) not implemented"))

# +(vec,jo)
+(v::AbstractVector,A::joAbstractOperator) = throw(joAbstractOperatorException("+(vec,jo) not implemented"))

# +(jo,num)
+(A::joAbstractOperator,b::Number) = throw(joAbstractOperatorException("+(jo,num) not implemented"))

# +(num,jo)
+(b::Number,A::joAbstractOperator)  = throw(joAbstractOperatorException("+(num,jo) not implemented"))

############################################################
## overloaded Base -(...jo...)

# -(jo)
-(A::joAbstractOperator) = throw(joAbstractOperatorException("-(jo) not implemented"))

# -(jo,jo)
-(A::joAbstractOperator,B::joAbstractOperator)  = throw(joAbstractOperatorException("-(jo,jo) not implemented"))

# -(jo,mvec)
-(A::joAbstractOperator,mv::AbstractMatrix) = throw(joAbstractOperatorException("-(jo,mvec) not implemented"))

# -(mvec,jo)
-(mv::AbstractMatrix,A::joAbstractOperator) = throw(joAbstractOperatorException("-(mvec,jo) not implemented"))

# -(jo,vec)
-(A::joAbstractOperator,v::AbstractVector) = throw(joAbstractOperatorException("-(jo,vec) not implemented"))

# -(vec,jo)
-(v::AbstractVector,A::joAbstractOperator) = throw(joAbstractOperatorException("-(vec,jo) not implemented"))

# -(jo,num)
-(A::joAbstractOperator,b::Number)  = throw(joAbstractOperatorException("-(jo,num) not implemented"))

# -(num,jo)
-(b::Number,A::joAbstractOperator)  = throw(joAbstractOperatorException("-(num,jo).' not implemented"))

############################################################
## overloaded Base .*(...jo...)

# .*(jo,jo)
.*(A::joAbstractOperator,B::joAbstractOperator) = throw(joAbstractOperatorException(".*(jo,jo) not implemented"))

# .*(jo,mvec)
.*(A::joAbstractOperator,mv::AbstractMatrix) = throw(joAbstractOperatorException(".*(jo,mvec) not implemented"))

# .*(mvec,jo)
.*(mv::AbstractMatrix,A::joAbstractOperator) = throw(joAbstractOperatorException(".*(mvec,jo) not implemented"))

# .*(jo,vec)
.*(A::joAbstractOperator,v::AbstractVector) = throw(joAbstractOperatorException(".*(jo,vec) not implemented"))

# .*(vec,jo)
.*(v::AbstractVector,A::joAbstractOperator) = throw(joAbstractOperatorException(".*(vec,jo) not implemented"))

# .*(num,jo)
.*(a::Number,A::joAbstractOperator) = throw(joAbstractOperatorException(".*(num,jo) not implemented"))

# .*(jo,num)
.*(A::joAbstractOperator,a::Number) = throw(joAbstractOperatorException(".*(jo,num) not implemented"))

############################################################
## overloaded Base .\(...jo...)

# .\(jo,jo)
.\(A::joAbstractOperator,B::joAbstractOperator) = throw(joAbstractOperatorException(".\(jo,jo) not implemented"))

# .\(jo,mvec)
.\(A::joAbstractOperator,mv::AbstractMatrix) = throw(joAbstractOperatorException(".\(jo,mvec) not implemented"))

# .\(mvec,jo)
.\(mv::AbstractMatrix,A::joAbstractOperator) = throw(joAbstractOperatorException(".\(mvec,jo) not implemented"))

# .\(jo,vec)
.\(A::joAbstractOperator,v::AbstractVector) = throw(joAbstractOperatorException(".\(jo,vec) not implemented"))

# .\(vec,jo)
.\(v::AbstractVector,A::joAbstractOperator) = throw(joAbstractOperatorException(".\(vec,jo) not implemented"))

# .\(num,jo)
.\(a::Number,A::joAbstractOperator) = throw(joAbstractOperatorException(".\(num,jo) not implemented"))

# .\(jo,num)
.\(A::joAbstractOperator,a::Number) = throw(joAbstractOperatorException(".\(jo,num) not implemented"))

############################################################
## overloaded Base .+(...jo...)

# .+(jo,jo)
.+(A::joAbstractOperator,B::joAbstractOperator) = throw(joAbstractOperatorException(".+(jo,jo) not implemented"))

# .+(jo,mvec)
.+(A::joAbstractOperator,mv::AbstractMatrix) = throw(joAbstractOperatorException(".+(jo,mvec) not implemented"))

# .+(mvec,jo)
.+(mv::AbstractMatrix,A::joAbstractOperator) = throw(joAbstractOperatorException(".+(mvec,jo) not implemented"))

# .+(jo,vec)
.+(A::joAbstractOperator,v::AbstractVector) = throw(joAbstractOperatorException(".+(jo,vec) not implemented"))

# .+(vec,jo)
.+(v::AbstractVector,A::joAbstractOperator) = throw(joAbstractOperatorException(".+(vec,jo) not implemented"))

# .+(jo,num)
.+(A::joAbstractOperator,b::Number) = throw(joAbstractOperatorException(".+(jo,num) not implemented"))

# .+(num,jo)
.+(b::Number,A::joAbstractOperator)  = throw(joAbstractOperatorException(".+(num,jo) not implemented"))

############################################################
## overloaded Base .-(...jo...)

# .-(jo,jo)
.-(A::joAbstractOperator,B::joAbstractOperator)  = throw(joAbstractOperatorException(".-(jo,jo) not implemented"))

# .-(jo,mvec)
.-(A::joAbstractOperator,mv::AbstractMatrix) = throw(joAbstractOperatorException(".-(jo,mvec) not implemented"))

# .-(mvec,jo)
.-(mv::AbstractMatrix,A::joAbstractOperator) = throw(joAbstractOperatorException(".-(mvec,jo) not implemented"))

# .-(jo,vec)
.-(A::joAbstractOperator,v::AbstractVector) = throw(joAbstractOperatorException(".-(jo,vec) not implemented"))

# .-(vec,jo)
.-(v::AbstractVector,A::joAbstractOperator) = throw(joAbstractOperatorException(".-(vec,jo) not implemented"))

# .-(jo,num)
.-(A::joAbstractOperator,b::Number)  = throw(joAbstractOperatorException(".-(jo,num) not implemented"))

# .-(num,jo)
.-(b::Number,A::joAbstractOperator)  = throw(joAbstractOperatorException(".-(num,jo).' not implemented"))

############################################################
## overloaded Base hcat(...jo...)
hcat(ops :: joAbstractOperator...)  = throw(joAbstractOperatorException("hcat(jo...).' not implemented"))

############################################################
## overloaded Base vcat(...jo...)
vcat(ops :: joAbstractOperator...)  = throw(joAbstractOperatorException("vcat(jo...).' not implemented"))

############################################################
## extra methods

# double(jo)
double(A::joAbstractOperator)  = throw(joAbstractOperatorException("double(jo) not implemented"))

# iscomplex(jo)
iscomplex(A :: joAbstractOperator) = throw(joAbstractOperatorException("iscomplex(jo) not implemented"))

# isinvertible(jo)
isinvertible(A::joAbstractOperator) = throw(joAbstractOperatorException("isinvertible(jo) not implemented"))

# islinear(jo)
islinear(A::joAbstractOperator,v::Bool=false) = throw(joAbstractOperatorException("islinear(jo) not implemented"))

# isadjoint(jo)
isadjoint(A::joAbstractOperator,ctmult::Number=1,v::Bool=false) = throw(joAbstractOperatorException("isadjoint(jo) not implemented"))
