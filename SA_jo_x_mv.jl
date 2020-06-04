    function jo_x_mv!(A::joAbstractLinearOperator,din::joPAsetup,dout::joPAsetup,
            in::SharedArray{ADDT,2},out::SharedArray{ARDT,2}) where {ADDT,ARDT}

        @sync @distributed for i in din.procs
            out[dout.idxs[indexpids(out)]...]=jo_convert(ARDT,A*in[din.idxs[indexpids(in)]...])
        end
        return nothing
    end

    function jo_x_mv!(F::Function,din::Tuple{Vararg{UnitRange{INT}}},dout::Tuple{Vararg{UnitRange{INT}}},
            in::SharedArray{ADDT,2},out::SharedArray{ARDT,2}) where {ADDT,ARDT,INT<:Integer}
            out[dout...]=jo_convert(ARDT,F(in[din...]))
        return nothing
    end
    function jo_x_mv!(F::Function,din::joPAsetup,dout::joPAsetup,
            in::SharedArray{ADDT,2},out::SharedArray{ARDT,2}) where {ADDT,ARDT}

        @assert out.pids==in.pids "SharedArrays pids in($(in.pids)) and out($(out.pids)) do not match"
        P=length(out.pids)
        @sync begin
            for w=1:P
                p=out.pids[w]
                @async remotecall_wait(jo_x_mv!,p,F,din.idxs[w],dout.idxs[w],in,out)
            end
        end
        return nothing
    end
    function jo_x_mv_old!(F::Function,din::joPAsetup,dout::joPAsetup, #  slower
            in::SharedArray{ADDT,2},out::SharedArray{ARDT,2}) where {ADDT,ARDT}

        @assert out.pids==in.pids "SharedArrays pids in($(in.pids)) and out($(out.pids)) do not match"
        P=length(out.pids)
        @sync @distributed for p=1:P
            jo_x_mv!(F,din.idxs[p],dout.idxs[p],in,out)
        end
        return nothing
    end
