Lib = {}

Lib.exit = os.exit
Lib.x = os.execute

Lib.norm = function (x, y)
    return math.sqrt(x^2 + y^2)
end

Lib.twice = function (x)
    return 2.0 * x
end

local tolerance = 0.17
Lib.isturnback = function (angle)
    angle = angle % (2*math.pi)
    return (math.abs(angle - math.pi) < tolerance)
end


Lib.round = function (x)
    local f = math.floor(x)

    if x == f
        or (x % 2.0 == 0.5)
        then return f
    else return math.floor(x + 0.5)
    end
end

Lib.cond2int = function (x)
    return math.tointeger(x) or x
end

-- 将序列 'a' 的元素相加
Lib.addd = function (a)
    local sum = 0

    for i = 1, #a do
        sum = sum + a[i]
    end

    return sum
end


Lib.incCount = function (n)
    n = n or 1
    globalCounter = globalCounter + n
end


Lib.maxium = function (a)
    local mi = 1            -- 最大值的索引
    local m = a[mi]         -- 最大值

    for i = 1, #a do
        if a[i] > m then
            mi = i; m = a[i]
        end
    end

    return m, mi
end


Lib.sum = function (...)
    local sum = 0

    for i = 1, select("#", ...) do
        sum = sum + select(i, ...)
    end

    return sum
end


Lib.f_write = function (fmt, ...)
    return io.write(string.format(fmt, ...))
end


Lib.nonils = function (...)
    local arg = table.pack(...)

    for i = 1, arg.n do
        if arg[i] == nil then return false end
    end

    return true
end


Lib._unpack = function (t, i, n)
    i = i or 1
    n = n or #t
    if i <= n then
        return t[i], _unpack(t, i + 1, n)
    end
end


Lib.f_size = function (file)
    local current = file:seek()     -- 保存当前位置
    local size = file:seek("end")   -- 获取文件大小

    file:seek("set", current)       -- 恢复位置

    return size
end


Lib.createDir = function (dirname)
    os.execute("mkdir " .. dirname)
end


-- 使用 Newton-Raphson 方法，计算 'x' 的平方根
Lib.nr_sqrt = function (x)
    local sqrt = x / 2

    repeat
        sqrt = (sqrt + x/sqrt) / 2
        local error = math.abs(sqrt^2 - x)
    until error < x/10000       -- 循环体中的本地 'error' 变量，在这里仍然可见

    return sqrt
end


function Lib.derivative (f, delta)
    delta = delta or 1e-4
    return function (x)
        return (f(x + delta) - f(x))/delta
    end
end

function Lib.degreesin (x)
    local k = math.pi / 180
    return math.sin(x * k)
end

function Lib.trim(s)
    s = string.gsub(s, "^%s*(.-)%s*$", "%1")
    return s
end


