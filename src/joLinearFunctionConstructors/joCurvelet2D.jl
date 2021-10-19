# 2D Curevelt operators: joCurvelet2D

## helper module
module joCurvelet2D_etc
    using JOLI: jo_convert, joLinearFunctionException
    function apply_fdct2Dwrap_real(v::Vector{vdt},n1::Integer,n2::Integer,m::Int128,rdt::DataType,nbs::Integer,nbac::Integer,actl::Integer,rctl::Integer,zfin::Integer) where vdt<:Union{AbstractFloat,Complex}
        C=Vector{Cdouble}(undef,m)
        eltype(v)<:Real || throw(joLinearFunctionException("joCurvelt2D: input vector must be real for real transform"))
        X=jo_convert(Cdouble,v,false)
        ccall((:jl_fdct_wrapping_real,:libdfdct_wrapping),Nothing,
            (Cint,Cint,Cint,Cint,Cint,Cint,Cint,Csize_t,Ptr{Array{Cdouble}},Ptr{Array{Cdouble}}),
            n1,n2,nbs,nbac,actl,rctl,zfin,m,X,C)
        C=jo_convert(rdt,C,false)
        return C
    end
    function apply_ifdct2Dwrap_real(v::Vector{vdt},n1::Integer,n2::Integer,m::Int128,rdt::DataType,nbs::Integer,nbac::Integer,actl::Integer,rctl::Integer,zfin::Integer) where vdt<:Union{AbstractFloat,Complex}
        X=Vector{Cdouble}(undef,n1*n2)
        eltype(v)<:Real || throw(joLinearFunctionException("joCurvelt2D: input vector must be real for real transform"))
        C=jo_convert(Cdouble,v,false)
        ccall((:jl_ifdct_wrapping_real,:libdfdct_wrapping),Nothing,
            (Cint,Cint,Cint,Cint,Cint,Cint,Cint,Csize_t,Ptr{Array{Cdouble}},Ptr{Array{Cdouble}}),
            n1,n2,nbs,nbac,actl,rctl,zfin,m,C,X)
        X=jo_convert(rdt,X,false)
        return X
    end
    function apply_fdct2Dwrap_cplx(v::Vector{vdt},n1::Integer,n2::Integer,m::Int128,rdt::DataType,nbs::Integer,nbac::Integer,actl::Integer,rctl::Integer,zfin::Integer) where vdt<:Union{AbstractFloat,Complex}
        C=Vector{Complex{Cdouble}}(undef,m)
        X=jo_convert(Complex{Cdouble},v,false)
        ccall((:jl_fdct_wrapping_cpx,:libdfdct_wrapping),Nothing,
            (Cint,Cint,Cint,Cint,Cint,Cint,Cint,Csize_t,Ptr{Array{Complex{Cdouble}}},Ptr{Array{Complex{Cdouble}}}),
            n1,n2,nbs,nbac,actl,rctl,zfin,m,X,C)
        C=jo_convert(rdt,C,false)
        return C
    end
    function apply_ifdct2Dwrap_cplx(v::Vector{vdt},n1::Integer,n2::Integer,m::Int128,rdt::DataType,nbs::Integer,nbac::Integer,actl::Integer,rctl::Integer,zfin::Integer) where vdt<:Union{AbstractFloat,Complex}
        X=Vector{Complex{Cdouble}}(undef,n1*n2)
        C=jo_convert(Complex{Cdouble},v,false)
        ccall((:jl_ifdct_wrapping_cpx,:libdfdct_wrapping),Nothing,
            (Cint,Cint,Cint,Cint,Cint,Cint,Cint,Csize_t,Ptr{Array{Complex{Cdouble}}},Ptr{Array{Complex{Cdouble}}}),
            n1,n2,nbs,nbac,actl,rctl,zfin,m,C,X)
        X=jo_convert(rdt,X,false)
        return X
    end
end
using .joCurvelet2D_etc

export joCurvelet2D
"""
    julia> op = joCurvelet2D(n1,n2;[DDT=joFloat,][RDT=DDT,]
                    [nbscales=...,][nbangles_coarse=...,][all_crvlts=...,]
                    [real_crvlts=...,][zero_finest=...,][name=...])

2D Curvelet transform (wrapping) over fast dimensions

# Signature

    function joCurvelet2D(n1::Integer,n2::Integer;DDT::DataType=joFloat,RDT::DataType=DDT,
            nbscales::Integer=0,
            nbangles_coarse::Integer=16,
            all_crvlts::Bool=false,
            real_crvlts::Bool=true,
            zero_finest::Bool=false,
            name::String="joCurvelt2D")

# Arguments

- `n1`,`n2`: image sizes
- keywords
    - `nbscales`: # of scales (requires #>=default; defaults to max(1,ceil(log2(min(n1,n2))-3)))
    - `nbangles_coarse`: # of angles at coarse scale (requires #%4==0, #>=8; defaults to 16)
    - `all_crvlts`: curvelets at finnest scales (defaults to false)
    - `real_crvlts`: real transform (defaults to true) and requires real input
    - `zero_finest`: zero out finnest scales (defaults to false)
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Notes

- if DDT:<Real for complex transform then imaginary part will be neglected for transpose/adjoint
- isadjoint test at larger sizes (above 128) might require reseting tollerance to bigger number.

# Examples

real transform (64-bit)

    joCurvelet2D(32,32)

complex transform (64-bit)

    joCurvelet2D(32,32;real_crvlts=false)

real transform with curevelts at the finnest scales (64-bit)

    joCurvelet2D(32,32;all_crvlts=true)

real transform with zeros at the finnest scales (64-bit)

    joCurvelet2D(32,32;zero_finest=true)

complex transform with real 64-bit input for forward

    joCurvelet2D(32,32;DDT=Float64,real_crvlts=false)

complex transform with just precision specification for curvelets

    joCurvelet2D(32,32;DDT=Float32,RDT=Float64,real_crvlts=false)

complex transform with full type specification for curvelets (same as above)

    joCurvelet2D(32,32;DDT=Float32,RDT=ComplexF64,real_crvlts=false)

"""
function joCurvelet2D(n1::Integer,n2::Integer;DDT::DataType=joFloat,RDT::DataType=DDT,
            nbscales::Integer=0,
            nbangles_coarse::Integer=16,
            all_crvlts::Bool=false,
            real_crvlts::Bool=true,
            zero_finest::Bool=false,
            name::String="joCurvelt2D")

    nbs=convert(Cint,max(1,ceil(log2(min(n1,n2))-3)))
    nbs=convert(Cint,max(nbs,nbscales))
    nbs > 1 || throw(joLinearFunctionException("joCurvelt2D: not enough elements in one of dimensions"))
    if nbscales!=0 && nbs>nbscales
        @warn "Adjusted number of scales to required $nbs"
    end
    nbac=convert(Cint,max(8,nbangles_coarse))
    nbac%4==0 || throw(joLinearFunctionException("joCurvelt2D: nbangles_coarse must be multiple of 4"))
    if nbangles_coarse < 8
        @warn "Adjusted number of coarse angles to required $nbac"
    end
    actl=convert(Cint,all_crvlts)
    rctl=convert(Cint,real_crvlts)
    zfin=convert(Cint,zero_finest)
    if real_crvlts
        dtp=DDT
        rtp=RDT
        apply_fdct2Dwrap=joCurvelet2D_etc.apply_fdct2Dwrap_real
        apply_ifdct2Dwrap=joCurvelet2D_etc.apply_ifdct2Dwrap_real
        myname=name*"_wrapReal"
    else
        dtp=DDT
        rtp= RDT<:Complex ? RDT : Complex{RDT}
        apply_fdct2Dwrap=joCurvelet2D_etc.apply_fdct2Dwrap_cplx
        apply_ifdct2Dwrap=joCurvelet2D_etc.apply_ifdct2Dwrap_cplx
        myname=name*"_wrapCplx"
    end
    cfmap_size=ccall((:jl_fdct_sizes_map_size,:libdfdct_wrapping),Cint,
        (Cint,Cint,Cint),nbs,nbac,all_crvlts)
    cfmap=Vector{Cint}(undef,cfmap_size)
    m=Ref{Csize_t}(0)
    ccall((:jl_fdct_sizes,:libdfdct_wrapping),Nothing,
        (Cint,Cint,Cint,Cint,Cint,Ptr{Array{Cint}},Ref{Csize_t}),
        nbs,nbac,actl,n1,n2,cfmap,m)
    m=convert(Int128,m[])

    return joLinearFunction_A(m,n1*n2,
        v1->apply_fdct2Dwrap(v1,n1,n2,m,rtp,nbs,nbac,actl,rctl,zfin),
        v2->apply_ifdct2Dwrap(v2,n1,n2,m,dtp,nbs,nbac,actl,rctl,zfin),
        v3->apply_ifdct2Dwrap(v3,n1,n2,m,dtp,nbs,nbac,actl,rctl,zfin),
        v4->apply_fdct2Dwrap(v4,n1,n2,m,rtp,nbs,nbac,actl,rctl,zfin),
        dtp,rtp;
        name=myname
        )
end

