#!/usr/bin/env lua

local file, msg
repeat
    print "enter a file name:"
    local name = io.read()
    if not name then return end     -- 无输入
    file, msg = io.open(name, "r")
    if not file then print(msg) end
until file

for line in file:lines() do
    print(line)
end
