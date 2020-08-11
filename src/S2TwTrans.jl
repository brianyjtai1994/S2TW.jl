module S2TwTrans

using DelimitedFiles

export S2TwConfig, s2tw

abstract type AbstractS2TW end

include("lexer.jl")

struct S2TwConfig{S} <: AbstractS2TW dep::Vector{Dict{S, S}} end

function S2TwConfig()
    字典_dict = Dict{String, String}()

    字典_list = ["ㄅ.txt", "ㄆ.txt", "ㄇ.txt", "ㄈ.txt",
                "ㄉ.txt", "ㄊ.txt", "ㄋ.txt", "ㄌ.txt",
                "ㄍ.txt", "ㄎ.txt", "ㄏ.txt", "ㄐ.txt",
                "ㄑ.txt", "ㄒ.txt", "ㄓ.txt", "ㄔ.txt",
                "ㄕ.txt", "ㄖ.txt", "ㄗ.txt", "ㄘ.txt",
                "ㄙ.txt", "ㄧ.txt", "ㄨ.txt", "ㄩ.txt",
                "ㄚ-ㄦ.txt", "異體.txt"]

    @inbounds @simd for i in eachindex(字典_list)
        字典_list[i] = "src/deps/字典/" * 字典_list[i]
    end

    @inbounds for filename in 字典_list
        temp_arr = readdlm(filename, ',', String, comments=true, comment_char='#')

        @simd for i in axes(temp_arr, 1)
            字典_dict[temp_arr[i, 1]] = temp_arr[i, 2]
        end
    end

    二字_dict = Dict{String, String}()
    temp_arr = readdlm("src/deps/用語/二字.txt", ',', String, comments=true, comment_char='#')
    @inbounds @simd for i in axes(temp_arr, 1)
        二字_dict[temp_arr[i, 1]] = temp_arr[i, 2]
    end

    三字_dict = Dict{String, String}()
    temp_arr = readdlm("src/deps/用語/三字.txt", ',', String, comments=true, comment_char='#')
    @inbounds @simd for i in axes(temp_arr, 1)
        三字_dict[temp_arr[i, 1]] = temp_arr[i, 2]
    end

    四字_dict = Dict{String, String}()
    temp_arr = readdlm("src/deps/用語/四字.txt", ',', String, comments=true, comment_char='#')
    @inbounds @simd for i in axes(temp_arr, 1)
        四字_dict[temp_arr[i, 1]] = temp_arr[i, 2]
    end

    return S2TwConfig(Dict{String, String}[字典_dict, 二字_dict, 三字_dict, 四字_dict])
end

s2tw(str::S)                    where S<:AbstractString = s2tw(str, S2TwConfig())
s2tw(str::S, s2twc::S2TwConfig) where S<:AbstractString = s2tw(Lexer(str), s2twc)

function s2tw(lx::Lexer, s2twc::S2TwConfig)
    ret = ""

    while peek_char(lx) != EOFChar
        ret *= accept_char!(lx, s2twc)
        ret *= skip_char!(lx)
    end

    return ret
end

# check if next char is one of among the valid ones
function accept_char!(lx::Lexer, s2twc::S2TwConfig)
    rdx       = 4
    trial     = peek_char(lx, rdx)
    not_found = !haskey(s2twc.dep[rdx], trial)

    rdx -= 1

    while not_found && rdx > 0
        trial     = peek_char(lx, rdx)
        not_found = !haskey(s2twc.dep[rdx], trial)

        rdx -= 1
    end

    next_char!(lx, rdx+1)

    return s2tw_convert(trial, s2twc, rdx+1)
end

function s2tw_convert(str::S, s2twc::S2TwConfig, rdx::Int) where S<:AbstractString
    if haskey(s2twc.dep[rdx], str)
        return s2twc.dep[rdx][str]
    else
        return str
    end
end

end
