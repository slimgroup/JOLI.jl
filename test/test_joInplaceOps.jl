mn=rand(3:7)
tsname="InplaceOps"
@testset "$tsname" begin

verbose && println("$tsname - Regular ($mn,$mn)")
@testset "Regular" begin
    DDT=Float32
    RDT=Float64
    A=joMatrix(rand(mn,mn),DDT=DDT,RDT=RDT)

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=A*x
    my=A*mx
    @into! Y=A*x
    @test Y≈y
    @into! MY=A*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=transpose(A)*x
    my=transpose(A)*mx
    @into! Y=transpose(A)*x
    @test Y≈y
    @into! MY=transpose(A)*mx
    @test MY≈my

    y=adjoint(A)*x
    my=adjoint(A)*mx
    @into! Y=adjoint(A)*x
    @test Y≈y
    @into! MY=adjoint(A)*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=A\x
    my=A\mx
    @into! Y=A\x
    @test Y≈y
    @into! MY=A\mx
    @test MY≈my

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=transpose(A)\x
    my=transpose(A)\mx
    @into! Y=transpose(A)\x
    @test Y≈y
    @into! MY=transpose(A)\mx
    @test MY≈my

    y=adjoint(A)\x
    my=adjoint(A)\mx
    @into! Y=adjoint(A)\x
    @test Y≈y
    @into! MY=adjoint(A)\mx
    @test MY≈my
end

verbose && println("$tsname - joMatrixInplace ($mn,$mn)")
@testset "joMatrixInplace" begin
    DDT=Float64
    RDT=Float64
    a=rand(mn,mn)
    A=joMatrix(a,DDT=DDT,RDT=RDT)
    AI=joMatrixInplace(a,DDT=DDT,RDT=RDT)

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=A*x
    my=A*mx
    @into! Y=AI*x
    @test Y≈y
    @into! MY=AI*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=transpose(A)*x
    my=transpose(A)*mx
    @into! Y=transpose(AI)*x
    @test Y≈y
    @into! MY=transpose(AI)*mx
    @test MY≈my

    y=adjoint(A)*x
    my=adjoint(A)*mx
    @into! Y=adjoint(AI)*x
    @test Y≈y
    @into! MY=adjoint(AI)*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=A\x
    my=A\mx
    @into! Y=AI\x
    @test Y≈y
    @into! MY=AI\mx
    @test MY≈my

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=transpose(A)\x
    my=transpose(A)\mx
    @into! Y=transpose(AI)\x
    @test Y≈y
    @into! MY=transpose(AI)\mx
    @test MY≈my

    y=adjoint(A)\x
    my=adjoint(A)\mx
    @into! Y=adjoint(AI)\x
    @test Y≈y
    @into! MY=adjoint(AI)\mx
    @test MY≈my
end

verbose && println("$tsname - joLooseMatrixInplace ($mn,$mn)")
@testset "joLooseMatrixInplace" begin
    DDT=Float64
    RDT=Float64
    a=rand(mn,mn)
    A=joMatrix(a,DDT=DDT,RDT=RDT)
    AI=joLooseMatrixInplace(a,DDT=DDT,RDT=RDT)

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=A*x
    my=A*mx
    @into! Y=AI*x
    @test Y≈y
    @into! MY=AI*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=transpose(A)*x
    my=transpose(A)*mx
    @into! Y=transpose(AI)*x
    @test Y≈y
    @into! MY=transpose(AI)*mx
    @test MY≈my

    y=adjoint(A)*x
    my=adjoint(A)*mx
    @into! Y=adjoint(AI)*x
    @test Y≈y
    @into! MY=adjoint(AI)*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=A\x
    my=A\mx
    @into! Y=AI\x
    @test Y≈y
    @into! MY=AI\mx
    @test MY≈my

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=transpose(A)\x
    my=transpose(A)\mx
    @into! Y=transpose(AI)\x
    @test Y≈y
    @into! MY=transpose(AI)\mx
    @test MY≈my

    y=adjoint(A)\x
    my=adjoint(A)\mx
    @into! Y=adjoint(AI)\x
    @test Y≈y
    @into! MY=adjoint(AI)\mx
    @test MY≈my
end

verbose && println("$tsname - joLinearFunctionInplace ($mn,$mn)")
@testset "joLinearFunctionInplace" begin
    DDT=Float64
    RDT=Float64
    a=rand(mn,mn)
    A=joMatrix(a,DDT=DDT,RDT=RDT)
    fa=factorize(a)
    AI=joLinearFunctionInplaceAll(mn,mn,
        (y1,x1)->A_mul_B!(y1,a,x1),
        (y2,x2)->At_mul_B!(y2,a,x2),
        (y3,x3)->Ac_mul_B!(y3,a,x3),
        (y5,x5)->A_ldiv_B!(y5,fa,x5),
        (y6,x6)->At_ldiv_B!(y6,fa,x6),
        (y7,x7)->Ac_ldiv_B!(y7,fa,x7),
        DDT,RDT)

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=A*x
    my=A*mx
    @into! Y=AI*x
    @test Y≈y
    @into! MY=AI*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=transpose(A)*x
    my=transpose(A)*mx
    @into! Y=transpose(AI)*x
    @test Y≈y
    @into! MY=transpose(AI)*mx
    @test MY≈my

    y=adjoint(A)*x
    my=adjoint(A)*mx
    @into! Y=adjoint(AI)*x
    @test Y≈y
    @into! MY=adjoint(AI)*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=A\x
    my=A\mx
    @into! Y=AI\x
    @test Y≈y
    @into! MY=AI\mx
    @test MY≈my

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=transpose(A)\x
    my=transpose(A)\mx
    @into! Y=transpose(AI)\x
    @test Y≈y
    @into! MY=transpose(AI)\mx
    @test MY≈my

    y=adjoint(A)\x
    my=adjoint(A)\mx
    @into! Y=adjoint(AI)\x
    @test Y≈y
    @into! MY=adjoint(AI)\mx
    @test MY≈my
end

verbose && println("$tsname - joLooseLinearFunctionInplace ($mn,$mn)")
@testset "joLooseLinearFunctionInplace" begin
    DDT=Float64
    RDT=Float64
    a=rand(mn,mn)
    A=joMatrix(a,DDT=DDT,RDT=RDT)
    fa=factorize(a)
    AI=joLooseLinearFunctionInplaceAll(mn,mn,
        (y1,x1)->A_mul_B!(y1,a,x1),
        (y2,x2)->At_mul_B!(y2,a,x2),
        (y3,x3)->Ac_mul_B!(y3,a,x3),
        (y5,x5)->A_ldiv_B!(y5,fa,x5),
        (y6,x6)->At_ldiv_B!(y6,fa,x6),
        (y7,x7)->Ac_ldiv_B!(y7,fa,x7),
        DDT,RDT)

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=A*x
    my=A*mx
    @into! Y=AI*x
    @test Y≈y
    @into! MY=AI*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=transpose(A)*x
    my=transpose(A)*mx
    @into! Y=transpose(AI)*x
    @test Y≈y
    @into! MY=transpose(AI)*mx
    @test MY≈my

    y=adjoint(A)*x
    my=adjoint(A)*mx
    @into! Y=adjoint(AI)*x
    @test Y≈y
    @into! MY=adjoint(AI)*mx
    @test MY≈my

    x=rand(RDT,mn)
    mx=rand(RDT,mn,mn)
    Y=zeros(DDT,mn)
    MY=zeros(DDT,mn,mn)

    y=A\x
    my=A\mx
    @into! Y=AI\x
    @test Y≈y
    @into! MY=AI\mx
    @test MY≈my

    x=rand(DDT,mn)
    mx=rand(DDT,mn,mn)
    Y=zeros(RDT,mn)
    MY=zeros(RDT,mn,mn)

    y=transpose(A)\x
    my=transpose(A)\mx
    @into! Y=transpose(AI)\x
    @test Y≈y
    @into! MY=transpose(AI)\mx
    @test MY≈my

    y=adjoint(A)\x
    my=adjoint(A)\mx
    @into! Y=adjoint(AI)\x
    @test Y≈y
    @into! MY=adjoint(AI)\mx
    @test MY≈my
end

end
