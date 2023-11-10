#!/usr/bin/env lua

local date = 1439653520
local day2year = 365.242                -- 一年中的天数
local sec2hour = 60 * 60                -- 一小时的秒数
local sec2day = sec2hour * 24           -- 一天中的秒数
local sec2year = sec2day * day2year     -- 一年中的秒数

-- 年份
print(date // sec2year + 1970)        --> 2015.0

-- 小时（按 UTC）
print(date % sec2day // sec2hour)     --> 15

-- 分钟
print(date % sec2hour // 60)          --> 45

-- 秒
print(date % 60)                      --> 20
