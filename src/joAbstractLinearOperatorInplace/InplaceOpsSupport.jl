############################################################
# InplaceOps support #######################################
############################################################

op_transpose(x::joAbstractLinearOperatorInplace) = CTranspose(x)
op_ctranspose(x::joAbstractLinearOperatorInplace) = Transpose(x)

mul!(O::AbstractVecOrMat, A::joAbstractLinearOperatorInplace, B::AbstractVecOrMat) = A_mul_B!(O,A,B)
ldiv!(O::AbstractVecOrMat, A::joAbstractLinearOperatorInplace, B::AbstractVecOrMat) = A_ldiv_B!(O,A,B)
