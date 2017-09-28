mn=rand(3:7)
@testset "Inplace operators" begin

@testset "Fake" begin
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

    y=A.'*x
    my=A.'*mx
    @into! Y=A.'*x
    @test Y≈y
    @into! MY=A.'*mx
    @test MY≈my

    y=A'*x
    my=A'*mx
    @into! Y=A'*x
    @test Y≈y
    @into! MY=A'*mx
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

    y=A.'\x
    my=A.'\mx
    @into! Y=A.'\x
    @test Y≈y
    @into! MY=A.'\mx
    @test MY≈my

    y=A'\x
    my=A'\mx
    @into! Y=A'\x
    @test Y≈y
    @into! MY=A'\mx
    @test MY≈my
end

@testset "joMatrix" begin
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

    y=A.'*x
    my=A.'*mx
    @into! Y=AI.'*x
    @test Y≈y
    @into! MY=AI.'*mx
    @test MY≈my

    y=A'*x
    my=A'*mx
    @into! Y=AI'*x
    @test Y≈y
    @into! MY=AI'*mx
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

    y=A.'\x
    my=A.'\mx
    @into! Y=AI.'\x
    @test Y≈y
    @into! MY=AI.'\mx
    @test MY≈my

    y=A'\x
    my=A'\mx
    @into! Y=AI'\x
    @test Y≈y
    @into! MY=AI'\mx
    @test MY≈my
end

@testset "joLooseMatrix" begin
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

    y=A.'*x
    my=A.'*mx
    @into! Y=AI.'*x
    @test Y≈y
    @into! MY=AI.'*mx
    @test MY≈my

    y=A'*x
    my=A'*mx
    @into! Y=AI'*x
    @test Y≈y
    @into! MY=AI'*mx
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

    y=A.'\x
    my=A.'\mx
    @into! Y=AI.'\x
    @test Y≈y
    @into! MY=AI.'\mx
    @test MY≈my

    y=A'\x
    my=A'\mx
    @into! Y=AI'\x
    @test Y≈y
    @into! MY=AI'\mx
    @test MY≈my
end

@testset "joLinearFunction" begin
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

    y=A.'*x
    my=A.'*mx
    @into! Y=AI.'*x
    @test Y≈y
    @into! MY=AI.'*mx
    @test MY≈my

    y=A'*x
    my=A'*mx
    @into! Y=AI'*x
    @test Y≈y
    @into! MY=AI'*mx
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

    y=A.'\x
    my=A.'\mx
    @into! Y=AI.'\x
    @test Y≈y
    @into! MY=AI.'\mx
    @test MY≈my

    y=A'\x
    my=A'\mx
    @into! Y=AI'\x
    @test Y≈y
    @into! MY=AI'\mx
    @test MY≈my
end

@testset "joLooseLinearFunction" begin
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

    y=A.'*x
    my=A.'*mx
    @into! Y=AI.'*x
    @test Y≈y
    @into! MY=AI.'*mx
    @test MY≈my

    y=A'*x
    my=A'*mx
    @into! Y=AI'*x
    @test Y≈y
    @into! MY=AI'*mx
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

    y=A.'\x
    my=A.'\mx
    @into! Y=AI.'\x
    @test Y≈y
    @into! MY=AI.'\mx
    @test MY≈my

    y=A'\x
    my=A'\mx
    @into! Y=AI'\x
    @test Y≈y
    @into! MY=AI'\mx
    @test MY≈my
end

end
