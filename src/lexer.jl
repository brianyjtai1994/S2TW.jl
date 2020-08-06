mutable struct Lexer{S, U} <: AbstractS2TW
    str::S # string being scanned
    idx::U # start position of this item (lexeme)
    pos::U # current position in the scanned string (start from 0)
end

# @code_warntype
Lexer(str::S) where S<:AbstractString = Lexer(str, 1, 0)

Base.show(io::IO, lx::Lexer) = print(io, string("Lexer(", lx.idx, ", ", lx.pos, ")"))

const EOFChar = Char(0xA1)         # End Of File Char
const EOFStr  = string(Char(0xA1)) # End Of File String

# to see what is the current char, @code_warntype
function this_char(lx::Lexer) # -> current_char
    if lx.pos < 1
        error("Can't ask for current Char before 1st Char has been fetched")

    elseif lx.pos > lastindex(lx.str)
        return EOFStr
    end

    return lx.str[lx.pos]
end

# to see what is the next char, @code_warntype
function peek_char(lx::Lexer)
    pos = nextind(lx.str, lx.pos)

    if pos > lastindex(lx.str)
        return EOFChar
    end

    return lx.str[pos]
end

# to see what the next phrase is (with length of `rdx + 1`), @code_warntype
function peek_char(lx::Lexer, rdx::Int)
    pos = lx.pos

    while rdx > 0
        pos = nextind(lx.str, pos)

        if pos > lastindex(lx.str)
            return EOFStr
        end

        rdx -= 1
    end

    return lx.str[lx.idx:pos]
end

# update Lexer to next char, @code_warntype
function next_char!(lx::Lexer)
    lx.pos = lx.idx
    lx.idx = nextind(lx.str, lx.pos)

    return lx.str[lx.pos]
end

function next_char!(lx::Lexer, rdx::Int)
    while rdx > 0
        next_char!(lx); rdx -= 1
    end
end

# update Lexer to previous char
function prev_char!(lx::Lexer) # -> backup_char
    lx.pos = prevind(lx.str, lx.pos)

    return lx.str[lx.pos]
end

# skip the space-like char, @code_warntype
function skip_char!(lx::Lexer)
    ret = ""

    while isspace(peek_char(lx))
        ret *= next_char!(lx)
    end

    return ret
end
