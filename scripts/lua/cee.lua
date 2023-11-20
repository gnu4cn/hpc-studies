#!/usr/bin/env lua

function foo (str)
    if type(str) ~= "string" then
        error("string expected", 2)
    end

    print(str)
end

foo("test")
foo({x=1})
