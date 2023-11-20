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


函数 `load` 与 `loadfile`，从不抛出错误。在出现任何类型的错误时，他们都会返回 `nil`，与一条错误信息：


```lua
print(load("i i"))
    --> nil     [string "i i"]:1: syntax error near 'i'
```

此外，这两个函数从不会产生，任何类别的副作用，也就是说，他们不会修改，或创建变量，不会写入文件等。他们只是将代码块，编译成某种内部表示，并将该结果，作为匿名函数返回。一种常见的错误认识，是认为加载某个代码块，就会定义出一些函数。在 Lua 中，函数的定义，是一些赋值操作；因此，他们发生于运行时，而不是在编译时。例如，假设我们有个名为 `foo.lua` 的文件，内容如下：


```lua
-- 文件 'foo.lua'
function foo (x)
    print(x)
end
```

我们随后运行命令

```lua
f = loadfile("foo.lua")
```

这条命令会编译 `foo`，但不会定义出他。要定义出 `foo`，我们就必须运行那个代码块：


```lua
> f = loadfile("foo.lua")
> print(foo)
nil
> f()
> foo("ok")
ok
> print(foo)
function: 000001ab70327280
```

这种行为，听起来可能奇怪，但如果我们在不使用语法糖下，重写该文件，就会明白了：


```lua
-- 文件 'foo.lua'
foo = funtion (x)
    print(x)
end
```

在需要运行外部代码的生产级程序中，in a production-quality program that needs to run external code,我们应该那些，在处理加载代码块时，所报告的任何错误。此外，我们可能希望在受保护的环境中，运行新的代码块，以避免一些不愉快的副作用。我们将在第 22 章 [“环境”](environment.md) 中，详细讨论那些环境。


## 预编译的代码

**Precompiled Code**


正如我（作者）在本章开头曾提到的，在运行源代码之前，Lua 会对其进行预编译。Lua 还允许我们，以预编译的形式，发布代码。


生成预编译文件（在 Lua 术语中，也称为 *二进制代码块，binary chunk*）的最简单方法，是使用标准发布中的 `luac` 程序，the `luac` program that comes in the standard distribution。例如，下面这个调用，将创建出新文件 `prog.lc`，其中包含了文件 `prog.lua` 的预编译版本：


```bash
$ luac -o prog.lc prog.lua
```

Lua 解释器可以像执行普通 Lua 代码一样，执行这个新文件，其执行方式，与原始源代码完全相同：


```bash
$ lua prog.lc "file1" "file2"
```

Lua 在接受源代码的任何地方，都会接受预编译代码。特别是，`loadfile` 和 `load`，二者都接受预编译代码。

我们可以直接以 Lua，编写一个最小 `luac`：


```lua
p = loadfile(arg[1])
f = io.open(arg[2], "wb")
f:write(string.dump(p))
f:close()
```

这里的关键函数，是 `string.dump`：他接收一个 Lua 函数，在为今后由 Lua 加载而适当格式化后，返回该函数的预编译代码。

这个 `luac` 程序，还提供了其他一些有趣的选项。其中，选项 `-l` 会列出，对于给定代码块，编译器所生成的操作码，the opcodes that the compiler generates for a given chunk。例如，下图 16.1，“`luac - l` 的输出示例”，显示了在以下单行文件上，带有 `-l` 选项 `luac` 的输出：


```lua
a = x + y - z
```


**图 16.1，`luac -l` 的示例输出**


```txt

main <stdin:0,0> (10 instructions at 00000192bdc12970)
0+ params, 2 slots, 1 upvalue, 0 locals, 4 constants, 0 functions
        1       [1]     VARARGPREP      0
        2       [1]     GETTABUP        0 0 1   ; _ENV "x"
        3       [1]     GETTABUP        1 0 2   ; _ENV "y"
        4       [1]     ADD             0 0 1
        5       [1]     MMBIN           0 1 6   ; __add
        6       [1]     GETTABUP        1 0 3   ; _ENV "z"
        7       [1]     SUB             0 0 1
        8       [1]     MMBIN           0 1 7   ; __sub
        9       [1]     SETTABUP        0 0 0   ; _ENV "a"
        10      [1]     RETURN          0 1 1   ; 0 out
```

> **译注**：其中的 `<stdin:0,0>` 是这样得到的，首先以 `echo "a = x + y -z" | lua -` 命令，会将这个字符串，编译到 `luac` 的默认输出 `luac.out`，注意其中的 `luac -` 子命令，其中的 `-` 是个 `luac` 的参数：

```bash
$ luac
C:\tools\msys64\mingw64\bin\luac.exe: no input files given
usage: C:\tools\msys64\mingw64\bin\luac.exe [options] [filenames]
Available options are:
  -l       list (use -l -l for full listing)
  -o name  output to file 'name' (default is "luac.out")
  -p       parse only
  -s       strip debug information
  -v       show version information
  --       stop handling options
  -        stop handling options and process stdin
```

> 然后运行 `luac -l luac.out`，或直接运行 `luac -l`（此命令会默认读取并列出 `luac.out` 的操作码），即可看到上面的输出。
>
>
> 还需注意，上面的输出，是在 Windows 系统下（运行了 MSYS2）环境中的输出，而在 Linux 系统下的输出，则为：


```console
$ luac -l

main <stdin:0,0> (7 instructions at 0x55b6b5651c50)
0+ params, 2 slots, 1 upvalue, 0 locals, 4 constants, 0 functions
        1       [1]     GETTABUP        0 0 -2  ; _ENV "x"
        2       [1]     GETTABUP        1 0 -3  ; _ENV "y"
        3       [1]     ADD             0 0 1
        4       [1]     GETTABUP        1 0 -4  ; _ENV "z"
        5       [1]     SUB             0 0 1
        6       [1]     SETTABUP        0 -1 0  ; _ENV "a"
        7       [1]     RETURN          0 1
```

> 二者之间，有较大的不同。


（在本书中，我们不会讨论 Lua 的内部细节；若对这些操作码的更多细节感兴趣，请在网上搜索 `lua opcode`，应该会找到相关资料。）


预编译形式的代码，并不总是会比原始代码小，但其加载速度更快。另一个好处是，他可以防止源代码的意外更改。与源代码不同的是，被恶意破坏的二进制代码，会崩溃掉 Lua 解释器，甚至会执行用户提供的机器码。运行普通代码时，则无需担心。然而，咱们应避免运行，预编译形式的不可靠的代码。函数 `load`，有个专门用于此任务的选项。


除了必须的第一个参数外，`load` 还有另外三个参数，他们都是可选的。第二个参数，是代码块的名字，只会在错误消息中用到。第四个参数是某种环境，我们将在第 22 章 [“环境”](environment.md) 中讨论。第三个参数，就是我们在此感兴趣的参数，他控制着可以加载哪些类型的代码块。如存在，则该参数必须是个字符串：字符串 `"t"`，只会允许文本（普通）代码块；`"b"` 只会允许二进制（预编译）代码块；默认的 `"bt"` 则会同时允许这两种格式。


## 错误



