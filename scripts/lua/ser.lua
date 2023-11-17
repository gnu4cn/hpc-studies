#!/usr/bin/env lua

local fmt = {integer = "%d", float = "%a"}

function seralize (o)
    local t = type(o)

    if t == "number"
        or t == "string"
        or t == "boolean"
        or t == "nil"
        then
            io.write(string.format("%q", o))
    else other cases
    end
end


function quote (s)
    -- 找出等号序列的最大长度
    local n = -1
    for w in string.gmatch(s, "]=*%f[%]]") do
        n = math.max(n, #w - 1)     -- 减去 1 是要排除那个 ']'
    end

    -- 产生出有着 'n' 加一个等号的字符串
    local eq = string.rep("=", n + 1)

    -- 构建出括起来的字符串
    return string.format(" [%s]\n%s]%s]", eq, s, eq)
end
