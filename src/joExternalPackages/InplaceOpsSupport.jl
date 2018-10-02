############################################################
# InplaceOps support #######################################
############################################################

op_transpose(x::joAbstractLinearOperator) = CTranspose(x)
op_adjoint(x::joAbstractLinearOperator) = Transpose(x)

mul!(O::AbstractVecOrMat, A::joAbstractLinearOperator, B::AbstractVecOrMat) = A_mul_B!(O,A,B)
ldiv!(O::AbstractVecOrMat, A::joAbstractLinearOperator, B::AbstractVecOrMat) = A_ldiv_B!(O,A,B)
