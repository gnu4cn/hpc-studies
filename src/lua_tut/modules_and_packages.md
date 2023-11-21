# 模组与包

通常，Lua 不会设置策略。相反，Lua 提供了功能强大的机制，让开发人员小组，可以实施最适合他们的策略。然而，这种方法并不能很好地适用于模块。模块系统的主要目标之一，是允许不同小组共用代码。缺乏通用策略，会阻碍这种共用。

从 5.1 版开始，Lua 已为模块和包（包是模块的集合），定义了一套策略。这些策略，并不要求语言提供任何额外设施；程序员可以使用我们到目前为止已见到的技巧，来实现他们。程序员可以自由使用不同策略。当然，其他一些实现方式，可能会导致程序无法使用外来模组，以及外来程序无法使用（咱们自己的）模组。


从用户角度来看，所谓模组，就是一些可以通过 `require` 函数加载，而创建出并返回表的代码（可以是 Lua 语言的，也可以是 C 语言的）。模组所导出的全部内容，如函数和常量，都在这个返回的表中定义，该表的运作方式，就如同某种命名空间。


例如，全部标准库，都属于模组。我们可以这样使用数学库：


```lua
local m = require "math"
print(m.sin(3.14))          --> 0.0015926529164868
```

不过，独立的解释器，使用与下面相同的代码，预加载了全部的标准库：

```lua
math = require "math"
string = require "string"
-- ...
```

这种预加载，就允许了我们再费心导入 `math` 模组下，写出通常的 `math.sin` 写法。


使用表来实现模块的一个显而易见的好处是，我们可以像操作其他表一样，操作模组，并利用 Lua 的全部能力，来创建出一些额外设施。在大多数语言中，模组都不是头等值（也就是说，他们不能存储在变量中，也不能作为参数，传递给函数等）；这些就会为想要提供模组，所需的每种额外设施，都需要一种特殊机制。在 Lua 中，我们可以无代价地获得这些额外设施。


例如，用户可以通过多种方式，调用模组中的函数。通常的方法是


```lua
local mod = require "mod"
mod.foo()
```


用户可以为该模组，设置任何的本地名字：


```lua
local m = require "mod"
m.foo()
```

他还可以为各个函数，提供替代的名字：


```lua
local m = require "mod"
local f = m.foo
f()
```

他还可以只导入某个特定的函数：

```lua
local f = require "mod".foo         -- (require("mod")).foo
f()
```

这些设施的优点，是无需 Lua 提供特殊支持。他们使用的，均是 Lua 语言已提供的特性。


## 函数 `require`


尽管 `require` 在 Lua 的模组实现中，扮演着核心角色，但他只是一个普通函数，并无特殊权限。要加载某个模组，我们只需以模组名称一个参数，调用 `require` 这个函数。请记住，当函数的单一参数，是个字面字符串时，括号就是可选的，在 `require` 的常规用法中，括号因此就通常省略了。不过，下面的用法，也都是正确的：


```lua
local m = require("math")

local modname = 'math'
local m = require(modname)
```

函数 `require` 尽量减少了对模块是什么的假设。对他来说，模块就是定义了，一些诸如函数或包含函数的表，的代码。通常情况下，代码会返回一个包含着模组函数的表。然而，由于这一操作是由模组代码，而非 `require` 完成的，因此某些模组，就可能会选择返回一些别的值，甚至产生副作用（例如，创建出一些全局变量）。


`require` 的第一步，是在 `package.loaded` 表中，检查该模块是否已被加载。如果是，`require` 会返回该模组相应的值。因此，一旦某个模组加载完毕，其他导入该同一模组的调用，就只需返回这同一值，而无需再次运行任何代码。


在该模组尚未加载时，`require` 就会搜索带有该模组名字的 Lua 文件。(此搜索由 `package.path` 变量引导，稍后咱们将讨论到）。如果找到了，就用 `loadfile` 加载他。结果便是我们称之为 *加载器，loader* 的函数。(加载器是个，在其被调用时，加载模块的函数。）


在找不到有着该模组名字的 Lua 文件时，`require` 就会搜索有着该名字的 C 库 <sup>注 1</sup> 。（在这种情况下，搜索会由变量 `package.cpath` 引导。）如果找到了 C 库，他就会使用底层函数 `package.loadlib` 加载该库，寻找名为 <code>luaopen_</code><i>modname</i> 的函数。在这种情况下，加载器就是 `loadlib` 的结果，即用表示为某个 Lua 函数的 C 函数 <code>luaopen_</code><i>modname</i>。