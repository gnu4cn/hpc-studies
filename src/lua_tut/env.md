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

也就是说，我们必须检索到最后的名字，然后单独处理这个最后的名字。[图 22.1 “函数 `setfield`”](#f-22.1) 中的函数 `setfield`，就可以完成这项任务，并在路径中的中间表不存在时，创建出他们。


<a name="f-22.1">**图 22.1 `setfield` 函数**</a>


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

目前，咱们的方案不允许全局变量的值为 `nil`，因为他们会被自动视为未声明变量。但要解决这个问题并不难。我们只需一个辅助表，来保存那些已声明变量的名字。每当某个元方法被调用时，元方法都会在该表中，检查变量是否为未声明变量。这样的代码可以如下 [图 22.2：“检查全局变量声明”](#f-22.2)。


<a name="f-22.2">**图 22.2 检查全局变量的声明**</a>

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


在 Lua 中，全局变量并不需要是真正全局的。正如我（作者）已经暗示过的，Lua 甚至没有全局变量。这乍听起来可能有些奇怪，因为这本书中我们一直在使用全局变量。正如我（作者）曾讲过的，Lua 不遗余力地给程序员，制造全局变量的假象。现在我们就来看看 Lua 是如何制造这种假象的<sup>[1](#foot-note-1)</sup>。

首先，让我们忘掉全局变量。相反，我们将从自由名字的概念开始，instead, we will start with the concept of free names。所谓 *自由名字* ，是个未与显式声明绑定的名称，也就是说，他不会出现在某个对应的局部变量作用域中。例如，在下面的代码块中，`x` 和 `y` 都是自由名字，但 `z` 不是：


```lua
local z = 10
x = y + z
```

重要部分来了： Lua 编译器会将代码块中的任何自由名字 `x`，转换为 `_ENV.x`。因此，上一代码块与下面这个完全等价：


```lua
local z = 10
_ENV.x = _ENV.y +z
```


而这个新的 `_ENV` 变量是什么呢？


`_ENV` 不可能是全局变量；我们刚刚说过 Lua 没有全局变量。编译器再度发挥了作用，again, the compiler does the trick。我（作者）已经提到过，Lua 会将任何代码块，都视为匿名函数。实际上，Lua 会将我们的原始代码，编译成如下代码：


```lua
    local _ENV = some value
    return funtion (...)
        local z = 10
        _ENV.x = _ENV.y + z
    end
```


也就是说，Lua 会在一个名为 `_ENV` 的预定义上值（一个外部的局部变量，a predefined upvalue, an external local variable）存在的情况下，编译任何的代码块。那么，任何变量都要么是本地变量（当其是个有边界的名字时），要么就是 `_ENV` 中的一个字段，而 `_ENV` 本身则是个本地变量（一个上值）。


`_ENV` 的初始值可以是任何表。（实际上，他不需要是个表；稍后会详细介绍。）任何这种表，都被称作环境。为了保留全局变量的假象，Lua 在内部保留了一个用作全局环境的表。通常，当我们加载某个代码块时，函数 `load` 就会使用该全局环境，初始化这个预定义的上值。所以，我们原来的代码块，就相当于这个：


```lua
    local _ENV = the global environment
    return function (...)
        local z = 10
        _ENV.x = _ENV.y + z
    end
```


所有这些安排的结果便是，全局环境中的 `x` 字段值，为 `y` 字段的值加上 `10`。


乍一看，这似乎是操作全局变量的一种相当复杂的方法。我不会说这是最简单的方法，但他提供了更简单实现方式下，难以达到的灵活性。


在继续之前，我们先总结一下 Lua 中对全局变量的处理：


- 编译器会在任何其编译的代码块之外，创建出一个局部变量 `_ENV`；

- 编译器会将任何自由名字 `var` 转换为 `_ENV.var`；

- 函数 `load`（或 `loadfile`）会以 Lua 内部保存的一个常规表的全局环境，初始化代码块的第一个上值。


毕竟，这并不复杂。


有些人会感到困惑，因为他们会试图从这些规则中，推断出额外的魔法。其实并没有什么额外的魔法。尤其是前两条规则，是完全由编译器完成的。除了被编译器预定义之外，`_ENV` 就是个普通的常规变量。在编译器之外，`_ENV` 这个名字对 Lua 来说，没有任何特殊含义。<sup>[2](#foot-note-2)</sup> 同样，从 `x` 到 `_ENV.x` 的转换，是个简单的语法转换，没有任何隐藏含义。特别是，在转换后，`_ENV` 将按照标准的可见性规则，指向代码中该处可见的任何 `_ENV` 变量。

> - <a name="foot-note-1"><sup>1</sup></a>该机制是 Lua 从 5.1 版到 5.2 版变化最大的部分之一。以下讨论几乎不适用于 Lua 5.1。
>
> - <a name="foot-note-2"><sup>2</sup></a>老实说，Lua 在错误信息中就使用了这个名字，因此他会将涉及变量 `_ENV.x` 的错误，报告为有关 `global x` 的错误。



## 使用 `_ENV`


在本节中，我们将看到一些对 `_ENV` 所带来灵活性加以探索的方法。请记住，本节中的大多数示例，都必须作为一个单独代码块来运行。如果我们在交互模式下，逐行输入代码，那么每行都将成为不同的代码块，因此每行都将有个不同的 `_ENV` 变量。而要将一段代码作为单独代码块运行，我们可以从文件中运行它，或者将其封装在 `do--end` 块中。


因为 `_ENV` 是个常规变量，所以我们可以像其他变量一样，对其赋值及读取。`_ENV = nil` 这个赋值，将使其余代码块中，对全局变量的直接访问无效。这对于控制我们的代码使用哪些变量，会非常有用：


```lua
local print, sin = print, math.sin

_ENV = nil
print(13)
print(sin(13))
print(math.cos(13))
```

*脚本：`env-demo.lua`*


```console
$ lua env_demo.lua
13
0.42016703682664
lua: env_demo.lua:6: attempt to index a nil value (upvalue '_ENV')
stack traceback:
        env_demo.lua:6: in main chunk
        [C]: in ?
```

对自由名字（某个 “全局变量”）的赋值，都会引发类似的错误。


我们可以明确写出 `_ENV`，来绕过某个本地的声明：

```lua
a = 13          -- 全局的
local a = 12    
print(a)        --> 12 （局部的）
print(_ENV.a)   --> 13 （全局的）
```


我们可以使用 `_G`，实现同样目的：


```lua
a = 13          -- 全局的
local a = 12    
print(a)        --> 12 （局部的）
print(_G.a)   --> 13 （全局的）
```


通常，`_G` 和 `_ENV` 指向的是同一个表，但尽管如此，他们是完全不同的实体。`_ENV` 是个局部变量，所有对 “全局变量” 的全部访问，实际上都是对他的访问。而 `_G` 则是个全局变量，没有任何特殊地位。根据定义，`_ENV` 总是指向当前环境；而 `_G` 则通常指向全局环境，前提是他是可见的，而且没有人改变过他的值，`_G` usually refers to the global environment, provided it is visible and no one changed its value。


`_ENV` 的主要用途，是更改某段代码所用到的环境。一旦我们更改了环境，那么所有全局的访问，都将使用这个新表：


```lua
-- 将当前环境修改未一个新的空表
_ENV = {}
a = 1           -- 在 _ENV 中创建出一个字段
print(a)
    --> stdina:4: attempt to call global 'print'(a nil value)
```


> **注意**：实际输出与上面的原书中的输出有差异。


```console
$ lua env_demo.lua
lua: env_demo.lua:4: attempt to call a nil value (global 'print')
stack traceback:
        env_demo.lua:4: in main chunk
        [C]: in ?
```

> 这可能与 Lua 的版本有关。



