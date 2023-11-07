#!/usr/bin/env lua

local fact = function (n)
    if n == 0 then return 1
    else return n*fact(n-1)     -- 问题代码
    end
end

