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
