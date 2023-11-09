#!/usr/bin/env lua

s = "Deadline is 30/11/2023, firm"
date = "%d%d/%d%d/%d%d%d%d"
print(string.match(s, date))    --> 30/11/2023



