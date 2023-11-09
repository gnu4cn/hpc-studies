#!/usr/bin/env lua

print(string.match("hello", "()ll()"))

function expandTabs (s, tab)
    tab = tab or 8      -- 制表符的 ”大小“ （默认为 8）
    local corr = 0      -- 校准

    s = string.gsub(s, "()\t", function (p)
        local sp = tab - (p - 1 + corr)%tab
        corr = corr - 1 + sp
        return string.rep(" ", sp)
    end)
    return s
end

print(expandTabs("name\tage\tnationality\tgender", 8))
