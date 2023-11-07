exit = os.exit
x = os.execute

function norm (x, y)
    return math.sqrt(x^2 + y^2)
end

function twice (x)
    return 2.0 * x
end

local tolerance = 0.17
function isturnback (angle)
    angle = angle % (2*math.pi)
    return (math.abs(angle - math.pi) < tolerance)
end


function round (x)
    local f = math.floor(x)

    if x == f
        or (x % 2.0 == 0.5)
        then return f
    else return math.floor(x + 0.5)
    end
end

function cond2int (x)
    return math.tointeger(x) or x
end

-- 将序列 'a' 的元素相加
function add (a)
    local sum = 0

    for i = 1, #a do
        sum = sum + a[i]
    end

    return sum
end


function incCount (n)
    n = n or 1
    globalCounter = globalCounter + n
end


function maxium (a)
    local mi = 1            -- 最大值的索引
    local m = a[mi]         -- 最大值

    for i = 1, #a do
        if a[i] > m then
            mi = i; m = a[i]
        end
    end

    return m, mi
end


function add (...)
    local sum = 0

    for i = 1, select("#", ...) do
        sum = sum + select(i, ...)
    end

    return sum
end


function f_write (fmt, ...)
    return io.write(string.format(fmt, ...))
end


function nonils (...)
    local arg = table.pack(...)

    for i = 1, arg.n do
        if arg[i] == nil then return false end
    end

    return true
end


function _unpack (t, i, n)
    i = i or 1
    n = n or #t
    if i <= n then
        return t[i], _unpack(t, i + 1, n)
    end
end


function fsize (file)
    local current = file:seek()     -- 保存当前位置
    local size = file:seek("end")   -- 获取文件大小

    file:seek("set", current)       -- 恢复位置

    return size
end


function createDir (dirname)
    os.execute("mkdir " .. dirname)
end


-- 使用 Newton-Raphson 方法，计算 'x' 的平方根
function NR_sqrt (x)
    local sqrt = x / 2

    repeat
        sqrt = (sqrt + x/sqrt) / 2
        local error = math.abs(sqrt^2 - x)
    until error < x/10000       -- 循环体中的本地 'error' 变量，在这里仍然可见

    return sqrt
end
