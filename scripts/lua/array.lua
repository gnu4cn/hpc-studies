#!/usr/bin/env lua

local a = {}        -- 新建数组
for i = 1, 1000 do
    a[i] = 0
end

print(a[1000], a[1000 + 5])
