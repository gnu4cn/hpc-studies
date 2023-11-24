#!/usr/bin/env lua

local Set = require "mod_sets"

s1 = Set.new{10, 20, 30, 50}
s2 = Set.new{30, 1}
print(getmetatable(s1))         --> table: 000002ade230b160
print(getmetatable(s2))         --> table: 000002ade230b160

s3 = s1 + s2
print("s1: ", Set.tostring(s1), "s2: ", Set.tostring(s2))
print("s1 + s2 = ", Set.tostring(s3))       --> {1, 30, 10, 20, 50}
print("s1 x s2 = ", Set.tostring(s2 * s1))  --> {30}

s = Set.new{1, 2, 3}
s = s + 8
