#!/usr/bin/env lua

local N = 3
local M = 3

local mt = {}           -- 创建矩阵
for i = 1, N do
    local row = {}      -- 创建一个新行
    mt[i] = row
    for j = 1, M do
        row[j] = 0
    end
end
