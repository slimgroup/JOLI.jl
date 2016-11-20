############################################################
# joAbstractOperator #######################################
############################################################

############################################################
## type definition

export joAbstractOperator, joAbstractOperatorException

abstract joAbstractOperator{T}

type joAbstractOperatorException <: Exception
    msg :: String
end

############################################################
## overloaded Base functions

# eltype(jo)
eltype{T}(A::joAbstractOperator{T}) = T

# show(jo)
show(A::joAbstractOperator) = throw(joAbstractOperatorException("show(jo) not implemented"))

# showall(jo)
showall(A::joAbstractOperator) = throw(joAbstractOperatorException("showall(jo) not implemented"))

# display(jo)
display(A::joAbstractOperator) = throw(joAbstractOperatorException("display(jo) not implemented"))

# size(jo)
size(A::joAbstractOperator) = throw(joAbstractOperatorException("size(jo) not implemented"))

# size(jo,1/2)
size(A::joAbstractOperator,ind::Int64) = throw(joAbstractOperatorException("size(jo,1/2) not implemented"))

# length(jo)
length(A::joAbstractOperator) = throw(joAbstractOperatorException("length(jo) not implemented"))

# full(jo)
full(A::joAbstractOperator) = throw(joAbstractOperatorException("full(jo) not implemented"))

# norm(jo)
norm(A::joAbstractOperator,p::Real=2) = throw(joAbstractOperatorException("norm(jo) not implemented"))

# vecnorm(jo)
vecnorm(A::joAbstractOperator,p::Real=2) = throw(joAbstractOperatorException("vecnorm(jo) not implemented"))

# transpose(jo)
transpose(A::joAbstractOperator) = throw(joAbstractOperatorException("jo.' not implemented"))

# ctranspose(jo)
ctranspose(A::joAbstractOperator) = throw(joAbstractOperatorException("jo' not implemented"))

# conj(jo)
conj(A::joAbstractOperator) = throw(joAbstractOperatorException("conj(jo) not implemented"))

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

double(A::joAbstractOperator)  = throw(joAbstractOperatorException("double(jo) not implemented"))

