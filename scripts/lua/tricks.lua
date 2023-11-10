#!/usr/bin/env lua

test = [[char s[] = "a /* here"; /* a tricky string */]]
print((string.gsub(test, "/%*.-%*/", "<COMMENT>")))
    --> char s[] = "a <COMMENT>

i, j = string.find(";$%  **#$hello13", "%a*")
print(i, j)

pattern = string.rep("[^\n]", 70) .. "+"


function nocase (s)
    s = string.gsub(s, "%a", function (c)
        return "[" .. string.lower(c) .. string.upper(c) .. "]"
    end)
    return s
end

print(nocase("Hi there!"))
