#!/usr/bin/env lua

local fmt = {integer = "%d", float = "%a"}

function seralize (o)
    if type(o) == "number" then
        io.write(string.format(fmt[math.type(o)], o))
    end

    if type(o) == "string" then
        io.write("[[", o, "]]")
    end
end
