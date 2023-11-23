#!/usr/bin/env lua

lines = {
    ["luaH_set"] = 10,
    ["luaH_get"] = 24,
    ["luaH_present"] = 48,
}

a = {}
for n in pairs(lines) do a[#a + 1] = n end
table.sort(a)

for _, n in ipairs(a) do print(n) end
