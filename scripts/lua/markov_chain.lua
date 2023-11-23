#!/usr/bin/env lua

function prefix (w1, w2)
    return w1 .. " " .. w2
end

function insert (prefix, value)
    local list = statetab[prefix]
    if list == nil then
        statetab[prefix] = {value}
    else
        list[#list + 1] = value
    end
end
