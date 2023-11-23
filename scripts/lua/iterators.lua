#!/usr/bin/env lua

a = {"one", "two", "three"}
for i, v in ipairs(a) do
    print(i, v)
end

local function iter (t, i)
    i = i + 1
    local v = t[i]
    if v then
        return i, v
    end
end

function ipairs (t)
    return iter, t, 0
end

function pairs (t)
    return next, t, nil
end
