# 2D Curevelt operators: joCurvelet2DnoFFT

function apply_fdct2DnoFFTwrap_real(v::AbstractVector,n1::Integer,n2::Integer,m::Integer,rdt::DataType,nbs::Integer,nbac::Integer,actl::Integer,rctl::Integer,zfin::Integer)
    C=zeros(Cdouble,m)
    X=jo_convert(Complex{Cdouble},v,false)
    ccall((:jl_fdct_wrapping_real_nofft,:libdfdct_wrapping),Void,
        (Cint,Cint,Cint,Cint,Cint,Cint,Cint,Csize_t,Ptr{Array{Complex{Cdouble}}},Ptr{Array{Cdouble}}),
        n1,n2,nbs,nbac,actl,rctl,zfin,m,X,C)
    C= jo_convert(rdt,C,false)
    return C
end
function apply_ifdct2DnoFFTwrap_real(v::AbstractVector,n1::Integer,n2::Integer,m::Integer,rdt::DataType,nbs::Integer,nbac::Integer,actl::Integer,rctl::Integer,zfin::Integer)
    X=zeros(Complex{Cdouble},n1*n2)
    eltype(v)<:Real || throw(joLinearFunctionException("joCurvelt2DnoFFT: input vector must be real for real transform"))
    C=jo_convert(Cdouble,v,false)
    ccall((:jl_ifdct_wrapping_real_nofft,:libdfdct_wrapping),Void,
        (Cint,Cint,Cint,Cint,Cint,Cint,Cint,Csize_t,Ptr{Array{Cdouble}},Ptr{Array{Complex{Cdouble}}}),
        n1,n2,nbs,nbac,actl,rctl,zfin,m,C,X)
    X=jo_convert(rdt,X,false)
    return X
end
function apply_fdct2DnoFFTwrap_cplx(v::AbstractVector,n1::Integer,n2::Integer,m::Integer,rdt::DataType,nbs::Integer,nbac::Integer,actl::Integer,rctl::Integer,zfin::Integer)
    C=zeros(Complex{Cdouble},m)
    X=jo_convert(Complex{Cdouble},v,false)
    ccall((:jl_fdct_wrapping_cpx_nofft,:libdfdct_wrapping),Void,
        (Cint,Cint,Cint,Cint,Cint,Cint,Cint,Csize_t,Ptr{Array{Complex{Cdouble}}},Ptr{Array{Complex{Cdouble}}}),
        n1,n2,nbs,nbac,actl,rctl,zfin,m,X,C)
    elv= eltype(v)<:Complex ? jo_complex_eltype(eltype(v)) : eltype(v)
    C=jo_convert(rdt,C,false)
    return C
end
function apply_ifdct2DnoFFTwrap_cplx(v::AbstractVector,n1::Integer,n2::Integer,m::Integer,rdt::DataType,nbs::Integer,nbac::Integer,actl::Integer,rctl::Integer,zfin::Integer)
    X=zeros(Complex{Cdouble},n1*n2)
    C=jo_convert(Complex{Cdouble},v,false)
    ccall((:jl_ifdct_wrapping_cpx_nofft,:libdfdct_wrapping),Void,
        (Cint,Cint,Cint,Cint,Cint,Cint,Cint,Csize_t,Ptr{Array{Complex{Cdouble}}},Ptr{Array{Complex{Cdouble}}}),
        n1,n2,nbs,nbac,actl,rctl,zfin,m,C,X)
    elv= eltype(v)<:Complex ? jo_complex_eltype(eltype(v)) : eltype(v)
    X=jo_convert(rdt,X,false)
    return X
end

export joCurvelet2DnoFFT
"""
2D Curvelet transform (wrapping) over fast dimensions without FFT

    joCurvelet2DnoFFT(n1,n2
                [;DDT=Complex{Float64},RDT=DDT,
                 nbscales=#,nbangles_coarse=16,all_crvlts=false,real_crvlts=true,zero_finest=false])

# Arguments
- n1,n2 - image sizes
- nbscales - # of scales (requires #>=default; defaults to max(1,ceil(log2(min(n1,n2))-3)))
- nbangles_coarse - # of angles at coarse scale (requires #%4==0, #>=8; defaults to 16)
- all_crvlts - curvelets at finnest scales (defaults to false)
- real_crvlts - real transform (defaults to true) and requires real input
- zero_finest - zero out finnest scales (defaults to false)

# Examples
- joCurvelet2DnoFFT(32,32) - real transform (64-bit)
- joCurvelet2DnoFFT(32,32;real_crvlts=false) - complex transform (64-bit)
- joCurvelet2DnoFFT(32,32;all_crvlts=true) - real transform with curevelts at the finnest scales (64-bit)
- joCurvelet2DnoFFT(32,32;zero_finest=true) - real transform with zeros at the finnest scales (64-bit)
- joCurvelet2DnoFFT(32,32;DDT=Float64,real_crvlts=false) - complex transform with complex 64-bit input for forward
- joCurvelet2DnoFFT(32,32;DDT=Float32,RDT=Float64,real_crvlts=false) - complex transform with just precision specification for curvelets
- joCurvelet2DnoFFT(32,32;DDT=Float32,RDT=Complex{Float64},real_crvlts=false) - complex transform with full type specification for curvelets (same as above)

# Notes
- real joCurvelet2DnoFFT passed adjoint test while either combined with joDFT, or with isadjont flag userange=true
- isadjoint test at larger sizes (above 128) might require reseting tollerance to bigger number.

"""
function joCurvelet2DnoFFT(n1::Integer,n2::Integer;DDT::DataType=Float64,RDT::DataType=DDT,
            nbscales::Integer=0,
            nbangles_coarse::Integer=16,
            all_crvlts::Bool=false,
            real_crvlts::Bool=true,
            zero_finest::Bool=false)

    nbs=convert(Cint,max(1,ceil(log2(min(n1,n2))-3)))
    nbs=convert(Cint,max(nbs,nbscales))
    nbs > 1 || throw(joLinearFunctionException("joCurvelt2DnoFFT: not enough elements in one of dimensions"))
    if nbscales!=0 && nbs>nbscales
        warn("Adjusted number of scales to required $nbs")
    end
    nbac=convert(Cint,max(8,nbangles_coarse))
    nbac%4==0 || throw(joLinearFunctionException("joCurvelt2DnoFFT: nbangles_coarse must be multiple of 4"))
    if nbangles_coarse < 8
        warn("Adjusted number of coarse angles to required $nbac")
    end
    actl=convert(Cint,all_crvlts)
    rctl=convert(Cint,real_crvlts)
    zfin=convert(Cint,zero_finest)
    dtp= DDT<:Complex ? DDT : Complex{DDT}
    if real_crvlts
        rtp=RDT
        apply_fdct2DnoFFTwrap=apply_fdct2DnoFFTwrap_real
        apply_ifdct2DnoFFTwrap=apply_ifdct2DnoFFTwrap_real
        myname="joCurvelt2DnoFFTwrapReal"
    else
        rtp= RDT<:Complex ? RDT : Complex{RDT}
        apply_fdct2DnoFFTwrap=apply_fdct2DnoFFTwrap_cplx
        apply_ifdct2DnoFFTwrap=apply_ifdct2DnoFFTwrap_cplx
        myname="joCurvelt2DnoFFTwrapCplx"
    end
    cfmap_size=ccall((:jl_fdct_sizes_map_size,:libdfdct_wrapping),Cint,
        (Cint,Cint,Cint),nbs,nbac,all_crvlts)
    cfmap=zeros(Cint,cfmap_size)
    m=Ref{Csize_t}(0)
    ccall((:jl_fdct_sizes,:libdfdct_wrapping),Void,
        (Cint,Cint,Cint,Cint,Cint,Ptr{Array{Cint}},Ref{Csize_t}),
        nbs,nbac,actl,n1,n2,cfmap,m)
    m=convert(Int128,m[])

    return joLinearFunctionCT(m,n1*n2,
        v1->apply_fdct2DnoFFTwrap(v1,n1,n2,m,rtp,nbs,nbac,actl,rctl,zfin),
        v2->apply_ifdct2DnoFFTwrap(v2,n1,n2,m,dtp,nbs,nbac,actl,rctl,zfin),
        v3->apply_ifdct2DnoFFTwrap(v3,n1,n2,m,dtp,nbs,nbac,actl,rctl,zfin),
        v4->apply_fdct2DnoFFTwrap(v4,n1,n2,m,rtp,nbs,nbac,actl,rctl,zfin),
        dtp,rtp;
        name=myname
        )
end

