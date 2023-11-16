#!/usr/bin/env lua

local f = assert(io.open(arg[1], "r"))

local t = {}
for line in f:lines() do
    t[#t + 1] = line .. "\n"
end
local s = table.concat(t)

print(s)

f:close()
