#!/usr/bin/env lua


local status, err = pcall(function () error("my error") end)
print(err)
