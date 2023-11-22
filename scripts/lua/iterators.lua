#!/usr/bin/env lua

function values (t)
    local i = 0
    return function () i = i + 1; return t[i] end
end

t = {10, 20, 30}
iter = values(t)

while true do
    local el = iter()
    if el == nil then break end
    print(el)
end

t = {10, 20, 30}
for el in values(t) do
    print(el)
end

function allwords ()
    local line = io.read()           -- 当前行
    local pos = 1                   -- 行中的当前位置

    return function ()              -- 迭代器函数
        while line do               -- 在存在行期间重复
            local w, e = string.match(line, "(%w+)()", pos)
            if w then               -- 发现了一个单词？
                pos = e             -- 下一位置是在这个单词之后
                return w            -- 返回这个单词
            else
                line = io.read()     -- 未找到单词；尝试下一行
                pos = 1             -- 从首个位置重新开始
            end
        end
        return nil                  -- 不再有行：遍历结束
    end
end

io.input("article")
for w in allwords() do
    print(w)
end
io.close()

for k, v in pairs(t) do print(k, v) end
