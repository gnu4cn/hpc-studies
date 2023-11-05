# 外部世界

由于其在可移植性，与可嵌入性方面的强带哦，Lua 本身，并没有提供太多与外部世界通信的设施。真实 Lua 程序中的大多数 I/O，从图形到数据库及网络的访问，要么由主机应用程序完成，要么通过主发行版中未包含的一些外部库完成。 纯粹的 Lua，仅提供 ISO C 标准提供的功能，即基本文件操作，加上一些额外功能。在本章中，我们将了解标准库，如何涵盖这些功能。


## 简单 I/O 模型

I/O 库提供了两种不同的文件操作模型。其中简单模型假设了，*当前输入流，current input stream*，和 *当前输出流，current out stream*，且其 I/O 操作是对这两种流进行操作。该库将当前输入流，初始化为进程的标准输入 (`stdin`)，将当前输出流，初始化为进程的标准输出 (`stdout`)。因此，当我们执行 `io.read()` 之类的操作时，我们会从标准输入中，读取一行。

我们可以使用 `io.input` 和 `io.output` 函数，更改这些当前流。像 `io.input(filename)` 这样的调用，会以读取模式，在文件上的打开流，并将其设置为当前输入流。从此时起，所有输入，都将来自该文件，直到再次调用 `io.input`。函数 `io.output`，则对输出执行类似的工作。如果出现错误，两个函数都会抛出错误。如果咱们想要直接处理错误，就应使用 完整 I/O 模型，the complete I/O model。

由于相较 `read`，`write` 要简单一些，因此我们首先看他。函数 `io.write` 只是接受任意数量的字符串（或数字），并将他们写入当前输出流。因为我们可以使用多个参数来调用他，所以我们应该避免像 `io.write(a..b..c);` 这样的调用。调用 `io.write(a, b, c)`，会以更少资源，达到相同的效果，因为他避免了连接运算。

通常，咱们应仅将 `print`，用于快速而肮脏的程序或调试，quick-and-dirty programs or debugging；当咱们需要完全控制输出时，请始终使用 `io.write`。与 `print` 不同，`write` 不会向输出，添加额外字符，例如制表符或换行符。此外，`io.write` 允许咱们重定向输出，而 `print` 则始终使用标准输出，the standard output。最后， `print` 会自动将 `tostring`，应用于其参数；这对于调试来说很方便，但这也可能隐藏一些微妙的错误，subtle bugs。

函数 `io.write`，会按照通常的转换规则，将数字转换为字符串；为了完全控制这种转换，我们应该使用 `string.format`：

```lua
> io.write("sin(3) = ", math.sin(3), "\n")
sin(3) = 0.14112000805987
file (0x7f386f1505c0)
> io.write(string.format("sin(3) = %.4f\n", math.sin(3)))
sin(3) = 0.1411
file (0x7f386f1505c0)
```

函数 `io.read`，会从当前输入流读取字符串。他的参数，控制着读取的内容：<sup>注 1</sup>


| 参数 | 读取内容 |
| :-- | :-- |
| `"a"` | 读取整个文件。 |
| `"l"` | 读取下一行（丢弃新行字符，dropping the newline）。 |
| `"L"` | 读取下一行（保留新行字符，keeping the newline）。 |
| `"n"` | 读取一个数字。 |
| `num` | 将 `num` 个字符，作为字符串读取。 |


> **注 1**：在 Lua 5.2 及之前版本中，所有字符串选项前面，都应该有一个星号，an asterisk, `*`。 Lua 5.3 仍然接受星号，以实现兼容性。


`io.read("a")` 这个调用，会从当前位置开始，读取整个当前输入文件。如果我们位于文件末尾，或者文件为空，则该调用会返回一个空字符串。


因为 Lua 可以有效地处理长字符串，故以 Lua 编写过滤器的一种简单技巧，便是将整个文件读入字符串，处理该字符串，然后将字符串写入输出：


```lua
> io.input("data")
file (0x564a2d55ffe0)
> io.output("new-data")
file (0x564a2d5a1510)
> t = io.read("a")
> t = string.gsub(t, "the", "that")
> io.write(t)
file (0x564a2d5a1510)
> io.close()
```

作为更具体的示例，以下代码块，是使用 MIME *扩起来的可打印* 编码，the MIME *quoted-printable* encoding，对文件内容进行编码的完整程序。这种编码将每个非 ASCII 字节，编码为 `=xx`，其中 `xx` 是字节的十六进制值。为了保持编码的一致性，他还必须对等号进行编码：


```lua
> io.input("data")
> t = io.read("a")
> t = string.gsub(t, "([\128-\255=])", function (c) return string.format("=%02X", string.byte(c)) end)
> io.write(t)
```

其中的函数 `string.gsub`，将匹配所有非 ASCII 字节（从 `128` 到 `255` 的代码），加上等号，并调用给定函数来提供替换。 （我们将在第 10 章 [”模式匹配”](pattern_matching.md) 中详细讨论模式匹配。）

调用 `io.read("l")`，会返回当前输入流中的下一行，不带换行符；调用 `io.read("L")` 类似，但他会保留换行符（如文件中存在）。当我们到达文件末尾时，调用会返回 `nil`，因为没有下一行要返回。选项 `“l”` 是 `read` 函数的默认选项。通常，仅在算法自然地逐行处理数据时，我（作者）才使用此选项；否则，我喜欢使用选项 `“a”` 立即读取整个文件，或者如我们稍后将看到的，分块读取。

作为基于行输入的运用简单示例，以下程序，会将其当前输入，复制到当前输出，并对每行进行编号：

```lua
> io.input("data")
file (0x5650b9a53fe0)
> for count = 1, math.huge do
>> local line = io.read("L")
>> if line == nil then break end
>> io.write(string.format("%6d ", count), line)
>> end
     1 Dozens were killed and many more injured in a blast at the Al-Maghazi refugee camp in the central Gaza Strip late Saturday night, according to hospital officials.
     2
     3 The explosion in the camp killed 52 people, said Mohammad al Hajj, the director of communications at the nearby Al-Aqsa Martyr’s hospital in Deir Al-Balah. He told CNN that the explosion was the result of an Israeli airstrike.
     4
     5 One resident of the camp told CNN: “We were sitting in our homes, suddenly we heard a very, very powerful sound of an explosion. It shook the whole area, all of it.”
     6
     7 The Israel Defense Forces (IDF) says it is looking into the circumstances around the explosion.
     8
     9 Dr. Khalil Al-Daqran, the head of nursing at the Al-Aqsa Martyr’s hospital told CNN he had seen at least 33 bodies from what he also claimed was an Israeli airstrike.
```


但是，`io.lines` 迭代器实现了使用更简单的代码，来逐行迭代整个文件：


```lua
local count = 0

for line in io.lines() do
    count = count + 1
    io.write(string.format("%6d ", count), line, "\n")
end
```

> **注意**：原文的代码如下，若在 Lua 交互模式下，因为变量作用域的缘故，而报出了在 `nil` 上执行算术运算的错误。

```console
> local count = 0
> for line in io.lines() do
>> count = count + 1
>> io.write(string.format("%6d ", count), line, "\n")
>> end
stdin:2: attempt to perform arithmetic on a nil value (global 'count')
stack traceback:
        stdin:2: in main chunk
        [C]: in ?
```

作为基于行输入的另一示例，下图 7.1 “对文件进行排序的程序” 给出了对文件行进行排序的一个完整程序。

**图 7.1，一个对文件加以排序的程序**

```lua
local lines = {}

-- 将文件中的行，读入到表 `lines` 中
for line in io.lines() do
    lines[#lines + 1] = line
end

-- 排序
table.sort(lines)

-- 写所有行
for _, l in ipairs(lines) do
    io.write(l, "\n")
end
```

调用 `io.read("n")`，会从当前输入流中，读取一个数字。这是 `read` 返回数字（整数或浮点数，遵循 Lua 扫描器的相同规则），而不是字符串的唯一情况。如果在跳过空格后，`io.read` 在当前文件位置找不到数字（由于格式错误或文件结尾），则返回 `nil`。

除了基本的读取模式之外，咱们还可以使用数字 *n* 作为参数，来调用 `read`：在这种情况下，他会尝试从输入流中，读取 *n* 个字符。如果无法读取任何字符（文件结尾），则调用返回 `nil`；否则，他会从流中返回最多包含 *n* 个字符的字符串。作为此读取模式的示例，以下程序是将文件从 `stdin`，复制到 `stdout` 的有效方法：


```lua
while true do
    local block = io.read(2^13)         -- 块大小为 8k
    if not block then break end
    io.write(block)
end
```

作为一种特殊情况，`io.read(0)` 用作文件结尾的测试：如果有更多内容要读取，则返回空字符串，否则返回 `nil`。

我们可以使用多个选项，来调用 `read`；对于每个参数，该函数将返回相应的结果。假设我们有一个文件，每行包含三个数字：

```txt
6.0     -3.23   15e12
4.3     234     1000001
89      95      78
...
```

现在我们要打印出每行的最大值。我们可以通过一次 `read` 调用，读取每行的所有三个数字：

```lua
while true do
    local n1, n2, n3 = io.read("n", "n", "n")
    if not n1 then break end
    print(math.max(n1, n2, n3))
end
```


输出为:

```console
15000000000000.0
1000001
95
```


## 完整 I/O 模型

简单的 I/O 模型，对于简单的事情来说很方便，但对于更高级的文件操作（例如同时读取或写入多个文件）来说，还不够。对于这些操作，我们需要完整模型。

要打开文件，咱们要使用模仿 C 函数 `fopen` 的 `io.open` 函数。他以要打开的文件名，和 *模式，mode* 字符串作为参数。此模式字符串，可以包含用于读取的 `r`、用于写入的 `w`（这也会删除文件以前的任何内容），或用于追加的 `a`，以及用于打开二进制文件的可选项 `b`。函数 `open` 返回一个文件上的新流。如果发生错误，`open` 会返回 `nil`，加上错误消息，以及与系统相关的错误编号：


```console
> print(io.open("data-num", "r"))
nil     data-num: No such file or directory     2
> print(io.open("data-number", "w"))
nil     data-number: Permission denied  13
```

一种检查错误的典型习惯用法，便是使用函数 `assert`：

```console
> f = assert(io.open("data", "r"))
> f
file (0x563c8dffcfe0)
>
> f = assert(io.open("data-number", "r"))
> f
file (0x563c8e03f270)
> f = assert(io.open("data-number", "w"))
stdin:1: data-number: Permission denied
stack traceback:
        [C]: in function 'assert'
        stdin:1: in main chunk
        [C]: in ?
```
