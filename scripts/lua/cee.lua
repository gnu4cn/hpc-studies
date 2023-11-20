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

i = 32
local i = 0
f = load("i = i + 1; print(i)")
g = function () i = i + 1; print(i) end
f()
g()


f = load("local a = 10; print(a + 20)")
f()

print "enter function to be plotted (with variable 'x'):"
local line = io.read()
local f = assert(load("local x = ...; return " .. line .. " + x"))
for i = 1, 20 do
    print(string.rep("*", f(i)))
end

print(load("i i"))


