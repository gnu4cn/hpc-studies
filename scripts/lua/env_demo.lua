local M = {}
_ENV = M
function add (c1, c2)
    return new(c1.r + c2.r, c1.i + c2.i)
end
