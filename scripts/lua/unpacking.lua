#!/usr/bin/env lua

s = "hello\0Lua\0world\0"

local i = 1
while i <= #s do
    local res
    res, i = string.unpack("z", s, i)
    print(res)
end

s = string.pack("s1", "hello")
for i = 1, #s do print((string.unpack("B", s, i))) end
