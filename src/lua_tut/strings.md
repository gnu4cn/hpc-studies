# 字符串

字符串表示文本。Lua 中的字符串，可以包含单个的字母，或一整本书。在 Lua 中，处理有着 10 万或 100 万字符的字符串的程序，并不罕见。


Lua 中的字符串，是一些字节序列。Lua 内核，the Lua core，并不考虑这些字节如何编码文本。Lua 采用八位编码，Lua is eight-bit clean，其字符串可以包含任何数字编码的字节，包括嵌入的零。这意味着，我们可以将任何二进制数据，存储到字符串中。我们还可以任何表示形式（UTF-8、UTF-16 等），存储 Unicode 的字符串；不过，正如我们将要讨论的，有几个很好的理由，让我们尽可能使用 UTF-8。Lua 自带的标准字符串库，假定使用单字节字符，但他可以相当合理地处理 UTF-8 字符串。此外，从 5.3 版开始，Lua 自带了一个小型库，来帮助使用 UTF-8 编码。


Lua 中的字符串，是一些不可更改的值，immutable values。我们不能像在 C 语言中那样，更改字符串中的某个字符；相反，我们要创建一个新的字符串，并进行所需的修改，如下面的示例：


```lua
> a = "one string"
> b = string.gsub(a, "one", "another")
> a
one string
> b
another string
```


Lua 中的字符串，与所有其他 Lua 对象（表、函数等）一样，都属于自动内存管理对象。这意味着，我们不必担心字符串的内存分配和取消分配，Lua 会为我们处理。


我们可以使用长度运算符（用 `#` 表示），来获取字符串的长度：

```lua
> #a
10
> #b
14
>
> #"goodbye"
7
```

该运算符始终是以字节为单位，计算长度，而不同于某些编码中的字符。


我们可以使用连接运算符 `..`（两个点），将两个字符串连接起来。如果操作数是数字，Lua 会将其转换为字符串：


```lua
> "Hello ".."World"
Hello World
> "Result is "..3
Result is 3
```

（有些语言会使用加号表示连接，但 `3 + 5` 与 `3 .. 5` 是不同的）。


请记住，Lua 中的字符串是不可变值。连接操作符总是会创建出一个新字符串，而不会对操作数进行任何修改：


```lua
> a = "Hello"
> a .. " World"
Hello World
> a
Hello
```


## 字面的字符串

**Literal strings**


我们可以用成对的单引号或双引号，对字面字符串进行定界，delimit literal strings by single or double matching quotes：


```lua
> a = "a line"
> b = 'another line'
```


他们是等价的；唯一的区别是，在一种引号内，我们可以使用不带转义的另一种引号。


```lua
> a = "It's a line"
> a
It's a line
> b = 'He said, "We can win"'
> b
He said, "We can win"
```

作为一种风格，大多数程序员，总是会为同类字符串，使用同一种引号，字符串的 “类别”，the "kinds" of strings，取决于程序。例如，处理 XML 的库，可能会为 XML 代码片段，保留单引号字符串，因为这些片段通常包含双引号。


Lua 中的字符串，可以包含以下的类似 C 语言的转义序列：


| 转义 | 意义 |
| :-- | :-- |
| `\a` | 铃声 |
| `\b` | 退格 |
| `\f` | 换页（form feed） |
| `\n` | 换行 |
| `\r` | 回车（carriage return） |
| `\t` | 水平制表位（horizontal tab） |
| `\v` | 垂直制表位（vertical tab） |
| `\\` | 反斜杠（backslash） |
| `\"` | 双引号 |
| `\'` | 单引号 |



