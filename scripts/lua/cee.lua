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


print "enter your expression:"
local line = io.read()
local func = assert(load("return " .. line))
print("the value of your express ion is " .. func())

print "enter function to be plotted (with variable 'x'):"
local line = io.read()
local f = assert(load("return " .. line))
for i = 1, 20 do
    x = i   -- 全局的 'x' (要对该代码块可见)
    print(string.rep("*", f()))
end
