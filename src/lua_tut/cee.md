# 编译，执行与报错

尽管我们将 Lua 称作解释型语言，但 Lua 总是会在运行源代码之前，将其预编译为中间形式（这没什么大不了的：许多解释型语言，也是如此。）编译阶段的存在，听起来可能与解释型语言格格不入。然而，解释型语言的显著特点，并不是不编译，而是可以（而且很容易）执行即时生成的代码。我们可以说，正是因为有了 `dofile` 这样的函数，我们才有资格，把 Lua 称作解释型语言。


在本章中，我们将更详细地讨论，Lua 运行其代码块，its chunks，的过程，编译的含义与作用，Lua 如何执行编译后的代码，以及如何处理在这一过程中，出现的错误。


## 编译

**Compilation**


早先，我们将 `dofile`，作为运行 Lua 代码块的一种原语操作，加以了引入，但 `dofile` 实际上是一个辅助函数，an auxiliary function：函数 `loadfile` 真正完成了艰苦工作。与 `dofile` 一样，`loadfile` 会从文件，加载 Lua 块，但他不运行该块。相反，他只会编译块，并将编译后的块，作为函数返回。此外，与 `dofile` 不同，`loadfile` 不会抛出错误，而是返回错误代码。我们可以像下面这样，定义一个 `dofile`：


```lua
function dofile (filename)
    local f = assert(loadfile(filename))
    return f()
end
```

请注意，其中那个在 `loadfile` 失败时，用于抛出错误的 `assert` 的运用。


对于简单的任务，`dofile` 是很方便的，因为一次调用中，他就能完成全部工作。不过，`loadfile` 更为灵活。如果出现错误，`loadfile` 会返回 `nil` 和错误信息，这就允许我们，以自定义的方式处理错误。此外，如果需要多次运行某个文件，我们可以调用一次 `loadfile`，然后多次调用其结果。这种方法，比多次调用 `dofile` 开销要低，因为 `loadfile` 只需编译一次文件。(与语言中的其他任务相比，编译是一项有些开销高昂的操作。）

函数 `load`，类似于`loadfile`，不同之处在于，他会从字符串或函数中，读取代码块，而不是从文件中读取。<sup>注 1</sup>例如，请考虑下面这行代码：

> **注 1**：在 Lua 5.1 中，函数 `loadstring`，扮演了加载字符串的角色。

```lua
f = load("i = i + 1")
```

这段代码之后，在被调用时，`f` 将个是执行 `i = i + 1` 的函数：


```lua
i = 0
f(); print(i)   --> 1
f(); print(i)   --> 2
```

函数 `load` 功能强大；我们应谨慎使用。他也是一个开销高昂的函数（与某些替代函数相比），并能导致代码难以理解。在使用之前，咱们要确保，解决手头的问题，已没有更简单的方法。

在我们打算执行一次快速而不太规范的 `dostring`（即，加载并运行某个代码块）时，a quick-and-dirty `dostring`，我们可以直接调用 `load` 的结果：


```lua
s = "i = i + 1"
load(s)(); print(i)     --> 3
```


通常，在字面字符串上使用 `load`，没有意义。例如，下面的两行，就大致相同：


```lua
f = load("i = i + 1")
f = function () i = i + 1 end
```

不过，第二行要快得多，因为 Lua 会将函数与其外层代码块，一起编译。而在第一行中，到 `load` 的调用，则需要单独编译。


由于 `load` 不会以词法范围（作用域）编译，does not compile with lexical scoping，因此上个示例中的两行，可能并不真正等价。为了弄清其中的区别，咱们来稍微修改一下那个示例：

```lua
i = 32
local i = 0
f = load("i = i + 1; print(i)")
g = function () i = i + 1; print(i) end
f()             --> 33
g()             --> 1
```

函数 `g` 如预期那样，操作了局部变量 `i`，但函数 `f` 操作的，是全局的 `i`，因为 `load`，总是在全局环境中，编译他的代码块。

加载的最典型用途，是运行外部代码（即来自咱们程序外部的，一些代码片段），或动态生成的代码。例如，我们可能想要绘制某个用户定义的函数；用户输入该函数的代码，然后我们使用 `load`，对其进行计算。请注意，`load` 预期得到是个代码块，即一些语句。在打算计算某个表达式时，我们可以在表达式前，加上 `return`，这样我们就能得到，返回给定表达式值的一个语句。请看示例：

```lua
print "enter your expression:"
local line = io.read()
local func = assert(load("return " .. line))
print("the value of your express ion is " .. func())
```

由于 `load` 返回的函数，是个常规函数，因此我们可以多次调用他：


```lua
print "enter function to be plotted (with variable 'x'):"
local line = io.read()
local f = assert(load("return " .. line))
for i = 1, 20 do
    x = i   -- 全局的 'x' (要对该代码块可见)
    print(string.rep("*", f()))
end
```


我们也可以将一个 *读取函数，reader function*，用作其第一个参数，调用 `load`。读取函数可以分部分地，返回代码块；`load` 会连续调用读取函数，直到返回表示数据块结束的 `nil`。例如，下面这个调用，等同于 `loadfile`：


```lua
f = load(io.lines(filename, "*L"))
```

正如我们在第 7 章，[“外部世界”](external.md) 中所看到的，那个 `io.lines(filename, "*L")` 调用，在每次调用时，都会返回一个，从给定文件返回一行新内容的函数。因此，`load` 就会，逐行读取文件中的代码块。以下版本与之类似，但效率略高：


```lua
f = load(io.lines(filename, 1024))
```

这里，`io.lines` 所返回的迭代器，会以 1024 字节的块，读取该文件。


Lua 会将任何独立的代码块，都视为 [可变函数](functions.md#可变函数) 的主体。例如，`load("a = 1")` 会返回，以下表达式的等价内容：


```lua
function (...) a = 1 end
```

与其他函数一样，代码块可以声明出一些局部变量：

```lua
f = load("local a = 10; print(a + 20)")
f()         --> 30
```

运用这些特性，咱们就可以重写上面的绘图示例，以避免使用全局变量 `x`：


```lua
print "enter function to be plotted (with variable 'x'):"
local line = io.read()
local f = assert(load("local x = ...; return " .. line))
for i = 1, 20 do
    print(string.rep("*", f(i)))
end
```

这段代码中，我们在那个代码块的开头，添加了 `"local x = ..."` 的声明，从而将 `x` 声明为了，一个局部变量。然后，我们以参数 `i`，调用 `f`，参数 `i` 就将成为那个可变参数表达式（`...`）的值。

> **译注**：这里，若把行 `local f = assert(load("local x = ...; return " .. line))`，修改为 `local f = assert(load("local x = ...; return " .. line .. " + x"))`，将更能反应出 `load` 的代码块中，可变参数表达式 `...` 的意义。
