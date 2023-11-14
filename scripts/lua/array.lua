#!/usr/bin/env lua

local a = {}        -- 新建数组
for i = 1, 1000 do
    a[i] = 0
end

print(#a, a[#a], a[#a + 5])


-- 创建索引为从 -5 到 5 的数组
a = {}
for i = -5, 5 do
    a[i] = 0
end
