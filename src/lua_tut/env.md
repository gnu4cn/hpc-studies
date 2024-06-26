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



