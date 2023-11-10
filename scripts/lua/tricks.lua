#!/usr/bin/env lua

test = [[char s[] = "a /* here"; /* a tricky string */]]
print((string.gsub(test, "/%*.-%*/", "<COMMENT>")))
    --> char s[] = "a <COMMENT>

i, j = string.find(";$%  **#$hello13", "%a*")
print(i, j)
