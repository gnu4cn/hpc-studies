#!/usr/bin/env lua
function prefix (w1, w2)
    return w1 .. " " .. w2
end

local statetab = {}

function insert (prefix, value)
    local list = statetab[prefix]
    if list == nil then
        statetab[prefix] = {value}
    else
        list[#list + 1] = value
    end
end

function allwords ()
    local line = io.read()      -- 当前行
    local pos = 1               -- 行中的当前位置
    return function ()          -- 迭代器函数
        while line do           -- 在有行时重复
            local w, e = string.match(line, "(%w+[,;.:]?)()", pos)
            if w then                       -- 找了个单词？
                pos = e                     -- 更新下一位置
                return w                    -- 返回该单词
            else
                line = io.read()        -- 未找到单词；尝试下一行
                pos = 1
            end
        end
        return nil
    end
end

io.input("article")

local MAXGEN = 200
local NOWORD = "\n"

-- 构建出表
local w1, w2 = NOWORD, NOWORD
for nextword in allwords() do
    insert(prefix(w1, w2), nextword)
    w1 = w2; w2 = nextword
end
insert(prefix(w1, w2), NOWORD)

-- 生成文本
w1 = NOWORD; w2 = NOWORD        -- 重新初始化
for i = 1, MAXGEN do
    local list = statetab[prefix(w1, w2)]
    -- 从清单选择一个随机项目
    local r = math.random(#list)
    local nextword = list[r]
    if nextword == NOWORD then return end
    io.write(nextword, " ")
    w1 = w2; w2 = nextword
end
