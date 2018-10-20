mn=rand(3:7)
tsname="InplaceOps"
@testset "$tsname" begin

verbose && println("$tsname - Regular ($mn,$mn)")
@testset "Regular" begin
    DDT=ComplexF64
    RDT=ComplexF64
    A=joMatrix(rand(DDT,mn,mn),DDT=DDT,RDT=RDT)

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=A*x
    my=A*mx
    @! Y=A*x
    @test Y≈y
    @! MY=A*mx
    @test MY≈my

    y=conj(A)*x
    my=conj(A)*mx
    @! Y=conj(A)*x
    @test Y≈y
    @! MY=conj(A)*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=transpose(A)*x
    my=transpose(A)*mx
    @! Y=transpose(A)*x
    @test Y≈y
    @! MY=transpose(A)*mx
    @test MY≈my

    y=adjoint(A)*x
    my=adjoint(A)*mx
    @! Y=adjoint(A)*x
    @test Y≈y
    @! MY=adjoint(A)*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=A\x
    my=A\mx
    @! Y=A\x
    @test Y≈y
    @! MY=A\mx
    @test MY≈my

    y=conj(A)\x
    my=conj(A)\mx
    @! Y=conj(A)\x
    @test Y≈y
    @! MY=conj(A)\mx
    @test MY≈my

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=transpose(A)\x
    my=transpose(A)\mx
    @! Y=transpose(A)\x
    @test Y≈y
    @! MY=transpose(A)\mx
    @test MY≈my

    y=adjoint(A)\x
    my=adjoint(A)\mx
    @! Y=adjoint(A)\x
    @test Y≈y
    @! MY=adjoint(A)\mx
    @test MY≈my
end

verbose && println("$tsname - joMatrixInplace ($mn,$mn)")
@testset "joMatrixInplace" begin
    DDT=ComplexF64
    RDT=ComplexF64
    a=rand(DDT,mn,mn)
    A=joMatrix(a,DDT=DDT,RDT=RDT)
    AI=joMatrixInplace(a,DDT=DDT,RDT=RDT)

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=A*x
    my=A*mx
    @! Y=AI*x
    @test Y≈y
    @! MY=AI*mx
    @test MY≈my

    y=conj(A)*x
    my=conj(A)*mx
    @! Y=conj(AI)*x
    @test Y≈y
    @! MY=conj(AI)*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=transpose(A)*x
    my=transpose(A)*mx
    @! Y=transpose(AI)*x
    @test Y≈y
    @! MY=transpose(AI)*mx
    @test MY≈my

    y=adjoint(A)*x
    my=adjoint(A)*mx
    @! Y=adjoint(AI)*x
    @test Y≈y
    @! MY=adjoint(AI)*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=A\x
    my=A\mx
    @! Y=AI\x
    @test Y≈y
    @! MY=AI\mx
    @test MY≈my

    y=conj(A)\x
    my=conj(A)\mx
    @! Y=conj(AI)\x
    @test Y≈y
    @! MY=conj(AI)\mx
    @test MY≈my

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=transpose(A)\x
    my=transpose(A)\mx
    @! Y=transpose(AI)\x
    @test Y≈y
    @! MY=transpose(AI)\mx
    @test MY≈my

    y=adjoint(A)\x
    my=adjoint(A)\mx
    @! Y=adjoint(AI)\x
    @test Y≈y
    @! MY=adjoint(AI)\mx
    @test MY≈my
end

verbose && println("$tsname - joLooseMatrixInplace ($mn,$mn)")
@testset "joLooseMatrixInplace" begin
    DDT=ComplexF64
    RDT=ComplexF64
    a=rand(DDT,mn,mn)
    A=joMatrix(a,DDT=DDT,RDT=RDT)
    AI=joLooseMatrixInplace(a,DDT=DDT,RDT=RDT)

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=A*x
    my=A*mx
    @! Y=AI*x
    @test Y≈y
    @! MY=AI*mx
    @test MY≈my

    y=conj(A)*x
    my=conj(A)*mx
    @! Y=conj(AI)*x
    @test Y≈y
    @! MY=conj(AI)*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=transpose(A)*x
    my=transpose(A)*mx
    @! Y=transpose(AI)*x
    @test Y≈y
    @! MY=transpose(AI)*mx
    @test MY≈my

    y=adjoint(A)*x
    my=adjoint(A)*mx
    @! Y=adjoint(AI)*x
    @test Y≈y
    @! MY=adjoint(AI)*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=A\x
    my=A\mx
    @! Y=AI\x
    @test Y≈y
    @! MY=AI\mx
    @test MY≈my

    y=conj(A)\x
    my=conj(A)\mx
    @! Y=conj(AI)\x
    @test Y≈y
    @! MY=conj(AI)\mx
    @test MY≈my

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=transpose(A)\x
    my=transpose(A)\mx
    @! Y=transpose(AI)\x
    @test Y≈y
    @! MY=transpose(AI)\mx
    @test MY≈my

    y=adjoint(A)\x
    my=adjoint(A)\mx
    @! Y=adjoint(AI)\x
    @test Y≈y
    @! MY=adjoint(AI)\mx
    @test MY≈my
end

verbose && println("$tsname - joLinearFunctionInplace ($mn,$mn)")
@testset "joLinearFunctionInplace" begin
    DDT=ComplexF64
    RDT=ComplexF64
    a=rand(DDT,mn,mn)
    A=joMatrix(a,DDT=DDT,RDT=RDT)
    fa=factorize(a)
    AI=joLinearFunctionInplaceAll(mn,mn,
        (y1,x1)->mul!(y1,a,x1),
        (y2,x2)->mul!(y2,transpose(a),x2),
        (y3,x3)->mul!(y3,adjoint(a),x3),
        (y4,x4)->mul!(y4,conj(a),x4),
        (y5,x5)->ldiv!(y5,fa,x5),
        (y6,x6)->ldiv!(y6,transpose(fa),x6),
        (y7,x7)->ldiv!(y7,adjoint(fa),x7),
        (y8,x8)->ldiv!(y8,factorize(conj(a)),x8),
        DDT,RDT)

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=A*x
    my=A*mx
    @! Y=AI*x
    @test Y≈y
    @! MY=AI*mx
    @test MY≈my

    y=conj(A)*x
    my=conj(A)*mx
    @! Y=conj(AI)*x
    @test Y≈y
    @! MY=conj(AI)*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=transpose(A)*x
    my=transpose(A)*mx
    @! Y=transpose(AI)*x
    @test Y≈y
    @! MY=transpose(AI)*mx
    @test MY≈my

    y=adjoint(A)*x
    my=adjoint(A)*mx
    @! Y=adjoint(AI)*x
    @test Y≈y
    @! MY=adjoint(AI)*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=A\x
    my=A\mx
    @! Y=AI\x
    @test Y≈y
    @! MY=AI\mx
    @test MY≈my

    y=conj(A)\x
    my=conj(A)\mx
    @! Y=conj(AI)\x
    @test Y≈y
    @! MY=conj(AI)\mx
    @test MY≈my

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=transpose(A)\x
    my=transpose(A)\mx
    @! Y=transpose(AI)\x
    @test Y≈y
    @! MY=transpose(AI)\mx
    @test MY≈my

    y=adjoint(A)\x
    my=adjoint(A)\mx
    @! Y=adjoint(AI)\x
    @test Y≈y
    @! MY=adjoint(AI)\mx
    @test MY≈my
end

verbose && println("$tsname - joLooseLinearFunctionInplace ($mn,$mn)")
@testset "joLooseLinearFunctionInplace" begin
    DDT=ComplexF64
    RDT=ComplexF64
    a=rand(DDT,mn,mn)
    A=joMatrix(a,DDT=DDT,RDT=RDT)
    fa=factorize(a)
    AI=joLooseLinearFunctionInplaceAll(mn,mn,
        (y1,x1)->mul!(y1,a,x1),
        (y2,x2)->mul!(y2,transpose(a),x2),
        (y3,x3)->mul!(y3,adjoint(a),x3),
        (y4,x4)->mul!(y4,conj(a),x4),
        (y5,x5)->ldiv!(y5,fa,x5),
        (y6,x6)->ldiv!(y6,transpose(fa),x6),
        (y7,x7)->ldiv!(y7,adjoint(fa),x7),
        (y8,x8)->ldiv!(y8,factorize(conj(a)),x8),
        DDT,RDT)

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=A*x
    my=A*mx
    @! Y=AI*x
    @test Y≈y
    @! MY=AI*mx
    @test MY≈my

    y=conj(A)*x
    my=conj(A)*mx
    @! Y=conj(AI)*x
    @test Y≈y
    @! MY=conj(AI)*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=transpose(A)*x
    my=transpose(A)*mx
    @! Y=transpose(AI)*x
    @test Y≈y
    @! MY=transpose(AI)*mx
    @test MY≈my

    y=adjoint(A)*x
    my=adjoint(A)*mx
    @! Y=adjoint(AI)*x
    @test Y≈y
    @! MY=adjoint(AI)*mx
    @test MY≈my

    y=conj(A)\x
    my=conj(A)\mx
    @! Y=conj(AI)\x
    @test Y≈y
    @! MY=conj(AI)\mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=A\x
    my=A\mx
    @! Y=AI\x
    @test Y≈y
    @! MY=AI\mx
    @test MY≈my

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=transpose(A)\x
    my=transpose(A)\mx
    @! Y=transpose(AI)\x
    @test Y≈y
    @! MY=transpose(AI)\mx
    @test MY≈my

    y=adjoint(A)\x
    my=adjoint(A)\mx
    @! Y=adjoint(AI)\x
    @test Y≈y
    @! MY=adjoint(AI)\mx
    @test MY≈my
end

end
