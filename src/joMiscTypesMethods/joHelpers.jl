module joHelpers_etc

    using JOLI

    const elmOnType{D,R} = Union{joAbstractLinearOperator{D,R},joAbstractFosterLinearOperator{D,R}} where {D,R}
    function elements_helper(A::elmOnType{DDT,RDT}) where {DDT,RDT}
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

    function elements_column_helper(A::elmOnType{DDT,RDT},r::UnitRange{URT}) where {DDT,RDT,URT<:Integer}
        (M,N)=size(A)
        n=length(r)
        eA=zeros(RDT,M,n)
        for i in r
            eA[:,i-r.start+1] = elements_column_helper(A,i)
        end
        return eA
    end

    function elements_column_helper(A::elmOnType{DDT,RDT},n::Integer) where {DDT,RDT}
        (M,N)=size(A)
        @assert (n>=1&&n<=N) "column index $n out of range <1,$N> for $(A.name)"
        x=zeros(DDT,N)
        x[n] = one(DDT)
        cA = A*x
        return cA
    end

end
using .joHelpers_etc
