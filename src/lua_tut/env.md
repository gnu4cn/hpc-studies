# 环境问题

**The Environment**


全局变量，是大多数编程语言的必备之恶，global variables are a necessary evil of most programming languages。一方面，全局变量的使用，很容易导致代码复杂，将程序中显然无关的部分纠缠在一起。另一方面，明智地使用全局变量，可以更好地表达程序中真正的全局内容；此外，全局常量是无害的，但像 Lua 这样的动态语言，却无法从变量中区分出常量来。像 Lua 这样的嵌入式语言，又给这种组合添加了另一成分：全局变量是指在整个程序中可见的变量，但 Lua 没有程序的明确概念，取而代之的是由主机应用程序所调用的代码块（chunks）。


籍由不带全局变量，但却不遗余力地假装自己有全局变量，Lua 解决了这个难题。我们可以近似地认为，Lua 将其所有全局变量，保存在一个称为 *全局环境，global environment* 的常规表中。在本章的后面部分，我们将看到 Lua 可以将其 “全局” 变量，保存在多个环境中。现在，我们将专注使用第一种近似方法。


使用表来存储全局变量，简化了 Lua 的内部实现，因为全局变量不需要不同的数据结构。另一个优点是，我们可以像操作其他表一样，操作这个表。为了方便操作，Lua 将全局环境本身，存储在全局变量 `_G` 中。（因此，`_G._G` 就等于 `_G`。）例如，以下代码打印出了定义在全局环境中所有变量的名字：


```console
> for n in pairs(_G) do print(n) end
assert
error
tostring
xpcall
_G
rawlen
warn
coroutine
string
rawequal
collectgarbage
debug
os
load
pcall
type
getmetatable
dofile
loadfile
pairs
Account
setmetatable
_VERSION
a
arg
utf8
math
next
ipairs
package
rawset
print
io
rawget
require
table
tonumber
select
```


> **译注**：以上是在执行 `lua -i lib/account.dual-rep.lua` 后，打印出的全局环境中所有变量的名字。下面则是仅执行 `lua -i` 时的情况。


```console
> for n in pairs(_G) do print(n) end
utf8
collectgarbage
string
pairs
require
io
_VERSION
rawget
package
select
math
error
xpcall
setmetatable
dofile
ipairs
load
warn
arg
debug
os
assert
rawlen
tonumber
getmetatable
_G
rawequal
coroutine
loadfile
type
rawset
next
print
table
tostring
pcall
```

> 对比二者的差异，可以发现代码块中定义的公开变量会进入到全局环境中，局部变量则不会进入到全局环境。


## 有着动态名字的全局变量

**Global Variables with Dynamic Names**


通常，对于访问和设置全局变量来说，赋值操作就足够了。不过，有时我们会需要某种形式的元编程，some form of meta-programming，比如当我们需要操作某个名字存储在另一变量中，或者名字是在运行时，以某种方式计算出来的全局变量时。为了获取这样一个变量的值，有些程序员会这样写：


```lua
    value = load("return " .. varname)()
```

例如，当 `varname` 为 `x` 时，那么上面字符串连接的结果就是 `"return x"`，运行后就能得到想要的结果。不过，这段代码涉及到一个新代码块的创建和编译，开销就会有点高。我们可以用下面的代码，来达成同样的效果，他比上面的代码的效率，要高出不止一个数量级：


```lua
    value = _G[varname]
```


由于环境是个常规表，因此我们只需用所需的键（变量名），对其进行索引即可。


以类似的方式，我们可以通过写下 `_G[varname] = value`，来为名字为动态计算出的全局变量赋值。但请注意：有些程序员对这些功能感到有点兴奋，而最终编写出类似 `_G["a"] = _G["b"]` 的代码，这只是 `a = b` 的一种复杂写法。


上面这个问题的概括，便是允许在动态名字中使用字段，如 `"io.read"` 或 `"a.b.c.d"`。如果我们写下 `_G["io.read"]`，显然就无法获得从 `io` 表中获取到 `read` 字段。但我们可以编写一个函数 `getfield`，使 `getfield("io.read")` 返回预期的结果。这个函数主要是个循环，从 `_G` 开始，逐个字段进行推进：

```lua
    function getfield (f)
        local v = _G    -- 从全局变量表开始

        for w in string.gmatch(f, "[%a_][%w_]*") do
            v = v[w]
        end

        return v
    end
```

我们依靠 `gmatch` 遍历 `f` 中的所有标识符。


设置字段的相应函数，就会稍微复杂一些。像 `a.b.c.d = v` 这样的赋值，相当于下面的代码：


```lua
    local temp = a.b.c
    temp.d = v
```

也就是说，我们必须检索到最后的名字，然后单独处理这个最后的名字。[图 22.1 “函数 `setfield`”](#图-221-setfield-函数) 中的函数 `setfield`，就可以完成这项任务，并在路径中的中间表不存在时，创建出他们。


### 图 22.1 `setfield` 函数


```lua
function setfield (f, v)
    local t = _G                -- 从全局变量表开始
    for w, d in string.gmatch(f, "([%a_][%w_]*)(%.?)") do
        if d == "." then        -- 不是最后的名字？
            t[w] = t[w] or {}   -- 在缺失时创建表
            t = t[w]            -- 获取到该表
        else                    -- 是最后的名字时
            t[w] = v            -- 进行赋值
        end
    end
end
```


这里的模式会捕获变量 `w` 中的字段名字，以及变量 `d` 中可选的后跟点。如果字段后面没有点，则其就是最后的名字了。


有了前面的函数，接下来的调用将创建一个全局表 `t`、另一个表 `t.x`，并将 `10` 赋值给 `t.x.y`：


```console
$ lua -i lib.lua
Lua 5.4.4  Copyright (C) 1994-2022 Lua.org, PUC-Rio
> Lib.setfield("t.x.y", 10)
> t.x.y
10
> Lib.getfield("t.x.y")
10
```


## 全局变量的声明

**Global-Variable Declarations**


Lua 中的全局变量不需要声明。虽然这种行为对小型程序来说很方便，但在稍大的一些程序中，一个简单拼写问题，就可能导致难以发现的错误。不过，如果我们愿意，也可以改变这种行为。由于 Lua 将全局变量保存在常规表中，因此我们可以使用元表，来检测 Lua 于何时访问不存在的变量。


第一种方法仅是检测任何对全局表中不存在键的访问：


```lua
Lib.setfield("_PROMPT", "*-*: ")

setmetatable(_G, {
    __newindex = function (_, n)
        error("尝试写入未声明的变量 " .. n, 2)
    end,
    __index = function (_, n)
        error("尝试读取未声明的变量 " .. n, 2)
    end
})
```

这段代码后，任何访问不存在全局变量的尝试，都会引发错误：


```console
$ lua -i lib.lua
Lua 5.4.4  Copyright (C) 1994-2022 Lua.org, PUC-Rio
*-*: print(a)
stdin:1: 尝试读取未声明的变量 a
stack traceback:
        [C]: in function 'error'
        lib.lua:208: in metamethod 'index'
        stdin:1: in main chunk
        [C]: in ?
```


但是我们如何声明新变量呢？一个选项是使用会绕过元方法的 `rawset`：


（其中带 `false` 的 `or`，确保了这个新全局变量，会始终得到一个与 `nil` 不同的值。）


一种更简单的选项，是将对新全局变量的赋值，限制在函数内部，而允许在代码块的外层进行自由赋值，restrict assignment to new global variables only inside functions, allowing free assignments in the outer level of a chunk。


要检查某个赋值是否在主块中，我们就必须使用调试库。调用 `debug.getinfo(2, "S")` 会返回一个表，其中的 `what` 字段，会显示调用元方法的函数，是个主代码块、常规 Lua 函数，还是 C 函数。(我们将在 [“内省设施，Introspective Facilities”](reflection.md#内省设施) 小节中，详细介绍 `debug.getinfo`）。使用这个函数，我们可以像下面这样重写 `__newindex` 元方法：


```lua
    __newindex = function (t, n, v)
        local w = debug.getinfo(2, "S").what
        if w ~= "main" and w ~= "C" then
            error("尝试写入未声明的变量 " .. n, 2)
        end
        rawset(t, n, v)
    end,
```

这个新版本还接受来自 C 代码的赋值，因为这种代码通常知道他在做什么。


当我们需要测试某个变量是否存在时，我们不能简单地将他与 `nil` 进行比较，因为如果他为 nil，访问就会引发错误。相反，我们可以使用避免了使用元方法的 `rawget`：


```lua
    if rawget(_G, var) == nil then
        -- ‘var’ 未经声明
        ...
    end
```

目前，咱们的方案不允许全局变量的值为 `nil`，因为他们会被自动视为未声明变量。但要解决这个问题并不难。我们只需一个辅助表，来保存那些已声明变量的名字。每当某个元方法被调用时，元方法都会在该表中，检查变量是否为未声明变量。这样的代码可以如下 [图 22.2：“检查全局变量声明”](#图-222-检查全局变量的声明)。


### 图 22.2 检查全局变量的声明

```lua
local declaredNames = {}

setmetatable(_G, {
    __newindex = function(t, n, v)
        if not declaredNames[n] then
            local w = debug.getinfo(2, "S").what
            if w ~= "main" and w ~= "C" then
                error("尝试写入未经声明的变量"..n, 2)
            end
            declaredNames[n] = true
        end
        rawset(t, n, v)     -- 执行真正设置
    end,

    __index = function (_, n)
        if not declaredNames[n] then
            error("尝试读取未经声明的变量 "..n, 2)
        else
            return nil
        end
    end,
})
```


现在，即使像 `x = nil` 这样的赋值，也足以声明某个全局变量了。

这两种解决方案的开销都可以忽略不计。在第一种方案下，于正常运行期间，那些元方法永远不会被调用。而在第二种方案下，他们可以被调用，但只有当程序访问某个保存着 `nil` 的变量时，才会被调用。



## 非全局的环境

**Non-Global Environment**


在 Lua 中，全局变量并不需要是真正全局的。正如我（作者）已经暗示过的，Lua 甚至没有全局变量。这乍听起来可能有些奇怪，因为这本书中我们一直在使用全局变量。正如我（作者）曾讲过的，Lua 不遗余力地给程序员，制造全局变量的假象。现在我们就来看看 Lua 是如何制造这种假象的<sup>[1](#foot-not-1)</sup>。


> <a name="foot-note-1"><sup>1</sup></a>该机制是 Lua 从 5.1 版到 5.2 版变化最大的部分之一。以下讨论几乎不适用于 Lua 5.1。
