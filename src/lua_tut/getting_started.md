# 入门

为了保持传统，咱们用 Lua 编写的第一个程序，只是打印 `"Hello World"`：


```lua
print("Hello World")
```

如果咱们使用的是独立的 Lua 解释器，要运行第一个程序，只需调用解释器 -- 通常命名为 `lua` 或 `lua5.3`，并输入包含程序的文本文件名称即可。如果将上述程序保存在 `hello.lua` 文件中，下面的命令就可以运行它：

```bash
% lua hello.lua
```


作为一个更复杂示例，下一个程序定义了一个计算给定数字阶乘的函数，要求用户输入一个数字，并打印其阶乘：


```lua
-- defines a factorial function
function fact (n)
    if n == 0 then
        return 1
    else
        return n * fact(n - 1)
    end
end

print("Please enter a number:")
a = io.read("*n")               -- reads a number
print(fact(a))
```

> **注意**：此 Lua 脚本，只能计算到 `25` 的阶乘，`26` 往上将发生溢出。


## 代码块

**Chunks**


我们将 Lua 执行的每段代码（如某个文件，或交互模式下的一行代码），称为一个 *代码块，chunk*（块）。一个代码块就是一个命令（或语句）序列。


代码块可以是简单的一条语句，如 "Hello World "示例；也可以由语句和函数定义（实际上是赋值，稍后我们将看到）混合组成，如那个阶乘示例。代码块大小可以随心所欲。由于 Lua 同时也是一种数据描述语言，a data-description language，因此几兆字节的代码块并不少见。Lua 解释器在处理大块时，完全没有问题。


咱们可以在交互模式下，运行独立解释器，the stand-alone interpreter，而不用将程序写入文件。如果不带任何参数调用 `lua`，咱们将得到这样的提示符：

```lua
$ lua
Lua 5.4.6  Copyright (C) 1994-2023 Lua.org, PUC-Rio
>
```

此后，输入的每一条命令（如 `print "Hello World"`），都会在输入后立即执行。要退出交互模式与解释器，只需键入文件结束控制字符（POSIX 中为 `ctrl-D`，Windows 中为 `ctrl-Z`），或调用操作系统库中的 `os.exit` 函数 -- 必须键入 `os.exit()`。


从 5.3 版本开始，咱们可以在交互模式下，直接输入表达式，Lua 就会打印出他们的值：


```bash
~ lua
Lua 5.4.6  Copyright (C) 1994-2023 Lua.org, PUC-Rio
> math.pi / 4
0.78539816339745
> a = 15
> a^2
225.0
> a + 2
17
```

在较早版本中，咱们需要在这些表达式前面，加上等号：


```bash
% lua5.2
Lua 5.2.3 Copyright (C) 1994-2013 Lua.org, PUC-Rio
> a = 15
> = a^2             --> 225
```

为了兼容性，Lua 5.3 仍然接受这些等号。


而要将这些代码，作为代码块运行（非交互模式下），咱们必须将表达式，包含在对 `print` 的调用中：


```lua
print(math.pi / 4)
a = 15
print(a^2)
print(a + 2)
```


Lua 通常将咱们在交互模式下键入的每一行，解释为一个完整的块或表达式。然而，如果他检测到该行不完整，他就会等待更多的输入，直到有一个完整的块。这样，咱们就可以直接在交互模式下，输入多行的定义，例如之前那个阶乘函数。然而，通常更方便的做法是，将这样的定义放在一个文件中，然后调用 Lua 来运行该文件。


咱们可以使用 `-i` 选项，来指示 Lua 在运行给定块后，启动交互式会话：


```bash
% lua -i prog
```

像这样的命令行，将运行文件 `prog` 中的代码块，然后提示交互，prompt for interaction。对于调试及手动测试，这特别有用。在本章最后，我们将看到独立解释器的其他选项。


运行代码块的另一方法，是使用 `dofile` 函数，其可以立即执行文件。例如，假设咱们有一个包含以下代码的 `lib.lua` 文件：


```lua
function norm (x, y)
    return math.sqrt(x^2 + y^2)
end

function twice (x)
    return 2.0 * x
end
```


然后，在交互模式下，咱们可以输入以下代码：


```bash
> dofile("lib.lua")
> n = norm(3.4, 1.0)
> n
3.5440090293339
> twice(n)
7.0880180586677
```

在咱们测试某段代码时，函数 `dofile` 也很有用。我们可以使用两个窗口：一个是有着咱们程序的文本编辑器（例如，在 `prog.lua` 文件中），另一个是以交互模式运行 Lua 的控制台。在咱们的程序中保存修改后，我们便在 Lua 控制台中，执行 `dofile(“prog.lua”)` 来加载新代码；然后咱们就可以运行新代码，调用其函数并打印结果。


## 部分词法规定

**Some Lexical Conventions**


Lua 中的标识符（或名称），可以是字母、数字和下划线的任意字符串，不能以数字开头；例如


```lua
i   j   i10     _ij
aSomewhatLongName   _INPUT
```

应避免使用以下划线开头、后跟一个或多个大写字母的标识符（例如 `_VERSION`）；他们在 Lua 中，被保留用于特殊用途。通常，我将标识符 `_`（单个下划线）保留给虚拟变量，dummy variables。


下列词语为保留字，不能用作标识符：


```lua
and     break       do      else        elseif
end     false       for     function    goto
if      in          local   nil         not
or      repeat      return  then        true
until   while
```

Lua 区分大小写：`and` 是一个保留字，但 `And` 和 `AND`，则是两个不同的标识符。


注释以两个连续的连字符 （`--`） 开始，直至行尾。Lua 还提供长注释，他们以两个连字符开始，后面是两个开头的方括号（`[[`），直到第一次出现两个连续的结尾方括号（`]]`）为止，就像下面这样：


```lua
--[[A multi-line
long comment
]]
```

我们注释掉一段代码的常用技巧，是将代码括在 `--[[` 和 `--]]` 之间，就像这里一样：


```lua
--[[
print(10)
--]]
```



