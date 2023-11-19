#!/usr/bin/env lua

function dofile (filename)
    local f = assert(loadfile(filename))
    return f()
end

f = load("i = i + 1")

i = 0
f(); print(i)   --> 1
f(); print(i)   --> 2

s = "i = i + 1"
load(s)(); print(i)     --> 3

f = function () i = i + 1 end
