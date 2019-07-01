module joHelpers_etc

    using JOLI

    const elmOnType{D,R} = Union{joAbstractLinearOperator{D,R},joAbstractFosterLinearOperator{D,R}} where {D,R}
    function elements_helper(A::joAbstractLinearOperator{DDT,RDT}) where {DDT,RDT}
        (M,N)=size(A)
        x=zeros(DDT,N)
        eA=zeros(RDT,M,N)
        for n=1:N
            x[n] = one(DDT)
            eA[:,n] = A*x
            x[n] = zero(DDT)
        end
        return eA
    end

end
using .joHelpers_etc
