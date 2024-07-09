a = 1
local newgt = {}            -- 创建新环境
setmetatable(newgt, {__index = _G})
_ENV = newgt                -- 设置他
print(a)                    --> 1

-- 继续前一代码块
a = 10
print(a, _G.a)              --> 10      1
_G.a = 20
print(_G.a)                 --> 20
