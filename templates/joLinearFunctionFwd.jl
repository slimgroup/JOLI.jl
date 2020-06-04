using JOLI # remove when not needed any more to avoid reloading JOLI

# Replace all instances of joOPER string with name of your operator.
# Once you define helper function in module below
# you wil refer to them later as joOPER_etc.function_name
# where joOPER_etc is the name of module with helper functions.

## helper module
module joOPER_etc
    using JOLI: jo_convert, LocalVector
    # if your functions here can handle multi-vectors (matricies)
    # use LocalMatrix above and below instead of LocalVector

    # put your helper functions here and do not export them
    # refer to them outside of the module as joOPER_etc.function_name
    # in each function use jo_convert to convert your final output to
    # range of the operator; jo_convert(RDT,your_output_array)
    # .... e.g.
    function frwrd(rdt::DataType,x::LocalVector,m::Integer,otherargs...)
        y=Vector{rdt}(undef,m) # if needed
        # do what is needed here
        jo_convert(rdt,y,false)
    end
    function trnsp(rdt::DataType,x::LocalVector,m::Integer,otherargs...)
        y=Vector{rdt}(undef,m) # if needed
        # do what is needed here
        jo_convert(rdt,y,false)
    end
    function adjnt(rdt::DataType,x::LocalVector,m::Integer,otherargs...)
        y=Vector{rdt}(undef,m) # if needed
        # do what is needed here
        jo_convert(rdt,y,false)
    end
    function cnjgt(rdt::DataType,x::LocalVector,m::Integer,otherargs...)
        y=Vector{rdt}(undef,m) # if needed
        # do what is needed here
        jo_convert(rdt,y,false)
    end
end
using .joOPER_etc

export joOPER
# replace anything following % in doc with appropriate information
"""
    julia> op = joOPER(% typeless arguments)

% Description

# Signature

    % full function signature

# Arguments

- % argument list -> `arg`: meaning
- optional
    - % argument list -> `arg`: meaning
- keywords
    - % argument list -> `arg`: meaning (default ???)
    - `DDT`: domain data type
    - `RDT`: range data type
    - `name`: custom name

# Notes

- % extra information

# Examples

% description

    % example

examples with DDT/RDT

    % joOPER(...; DDT=...)
    % joOPER(...; DDT=...,RDT=...)

"""
function joOPER(n::Integer,your_otherargs...;
                DDT::DataType=joFloat,RDT::DataType=DDT,name::String="joOPER",your_otherkwargs...)
    # add/modify signature above as needed, but keep DDT,RDT,name
    # do what is needed here
    # like e.g. calculate m if depending on n
    m=n
    fWVok=false # or true if your functions can handle multi-vectors
    return joLinearFunctionFwd(m,n,
        v1->joOPER_etc.frwrd(RDT,v1,m),
        v2->joOPER_etc.trnsp(DDT,v2,m),
        v3->joOPER_etc.adjnt(DDT,v3,m),
        v4->joOPER_etc.cnjgt(RDT,v4,m),
        DDT,RDT;
        name=name,
        fMVok=fWVok
        )
end

