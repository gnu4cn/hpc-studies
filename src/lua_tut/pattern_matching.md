# 模式匹配

与其他几种脚本语言不同，Lua 在进行模式匹配时，既不使用 POSIX 正则表达式，也不使用 Perl 正则表达式。做出这一决定的主要原因，在于规模：POSIX 正则表达式的典型实现，需要 4000 多行代码，是全部 Lua 标准库总和的一半还多。相比之下，Lua 中模式匹配的实现，只需不到 600 行代码。当然，Lua 中的模式匹配，并不能像完整的 POSIX 实现那样，做到所有事情。不过，Lua 中的模式匹配，是一个强大的工具，他包含了一些标准 POSIX 实现，难以企及的功能。


## 模式匹配函数


字符串库提供了基于 *模式，patterns* 的四个函数。我们已经简要介绍了 `find` 和 `gsub`；另外两个函数是 `match` 和 `gmatch`（ *全局匹配* ）。现在我们将详细了解他们。


### 函数 `string.find`


函数 string.find 会在给定主题字符串里，检索某种模式。模式的最简单形式，是只匹配其自身副本的一个单词。例如，模式 `"hello"`，就将搜索主题字符串中的子串 `"hello"`。`string.find` 找到模式后，会返回两个值：匹配开始的索引，与匹配结束的索引。如果没有找到匹配，则返回 `nil`：


```lua
s = "hello world"
i, j = string.find(s, "hello")
print(i, j)                     --> 1       5
print(string.sub(s, i, j))      --> hello
print(string.find(s, "world"))  --> 7       11
i, j = string.find(s, "l")
print(i, j)                     --> 3       3
print(string.find(s, "lll"))    --> nil

s = "这是一个测试"
print(string.find(s, "测试"))   --> 13      18
```

匹配成功时，咱们便可以 `find` 返回的值，调用 `string.sub`，来获取到主题字符串中，与模式匹配的部分。对于简单模式，这必然是模式本身。


函数 `string.find`，有两个可选参数。第三个参数是告知在主题串中的哪个位置，开始检索的一个索引。第四个参数是个布尔值，表示普通检索，a plain search。顾名思义，普通检索会在主题中，进行普通的 “查找子串” 检索，does a plain "find substring" search，不考虑模式：


```lua
> string.find("a [word]", "[")
stdin:1: malformed pattern (missing ']')
stack traceback:
        [C]: in function 'string.find'
        stdin:1: in main chunk
        [C]: in ?
> string.find("a [word]", "[", 1, true)
3       3
```

在第一次调用中，该函数会抱怨，因为在模式中，`"["` 有着特殊含义。而在第二次调用中，该函数会将 `"["` 视为简单字符串。请注意，若没有第三个可选参数，我们就无法传递第四个可选参数。


### 函数 `string.match`


函数 `string.match` 与 `find` 类似，也是在字符串中检索模式。不过，与返回找到模式的位置不同，他会返回主题字符串中，与模式匹配的部分：


```lua
print(string.match("hello world", "hello"))     --> hello
```

对于 `"hello"` 这种固定模式，该函数毫无意义。在与可变（变量）模式，variable patterns，一起使用时，他就会显示出他的威力，就像下面这个示例一样：


```lua
date = "Today is 9/11/2023"
d = string.match(date, "%d+/%d+/%d+")
print(d)    --> 9/11/2023
```

很快，我们就将讨论模式 `"%d+/%d+/%d+"` 的含义，以及 `string.match` 的更多高级用法。


### 函数 `string.gsub`


函数 `string.gsub` 有着三个必选参数，three mandatory parameters：主题字符串，a subject string、模式，a pattern 以及替换的字符串，a replacement。他的基本用途，是用替换字符串替代主题字符串中，所有出现的模式：


```lua
s = string.gsub("Lua is cute", "cute", "great")
print(s)        --> Lua is great

s = string.gsub("all lii", "l", "x")
print(s)        --> axx xii

s = string.gsub("Lua is great", "Sol", "Sun")
print(s)        --> Lua is great
```


可选的第四个参数，会限制替换次数：

```lua
s = string.gsub("all lii", "l", "x", 1)
print(s)        --> axl lii

s = string.gsub("all lii", "l", "x", 2)
print(s)        --> axx lii
```

`string.gsub` 的第三个参数，除了可以是替换字符串外，还可以是个被调用（或被索引），以生成替换字符串的函数（或表）；我们将在 [“替换物，replacements”](#替换物) 小节，介绍这一功能。

函数 `string.gsub` 还会返回作为第二个结果的替换次数。


```lua
s, n = string.gsub("all lii", "l", "x")
print(s, n)     --> "axx xii"       3
```


## 函数 `string.gmatch`


函数 `string.gmatch` 会返回，对字符串中某种模式的全部存在，加以迭代的一个函数（即：迭代器，iterator？）。例如，下面的示例，会收集给定字符串 `s` 的所有单词：


```lua
s = "Most pattern-matching libraries use the backslash as an escape. However, this choice has some annoying consequences. For the Lua parser, patterns are regular strings."

words = {}
for w in string.gmatch(s, "%a+") do
    words[#words + 1] = w
end
```


正如我们即将讨论到的，模式 `"%a+"` 会匹配一个或多个字母字符的序列（即单词）。因此，其中的 `for` 循环，将遍历主题字符串中的所有单词，并将他们存储在列表 `words` 中。


## 模式

大多数模式匹配库，都将反斜杠（`/`），用作了转义字符。不过，这种选择，会带来一些令人讨厌的后果。对于 Lua 解析器来说，模式就是一些常规字符串。他们没有特殊待遇，遵循了与其他字符串相同的规则。只有模式匹配函数，才将他们解释为模式。因为反斜杠是 Lua 中的转义字符，因此我们必须将其转义，才能将其传递给任何函数。模式原本就很难读懂，到处写 `"\\"` 而不是 `"\"`，也无济于事。


通过使用长字符串，将模式括在双重方括号之间，咱们就可以改善这个问题。（某些语言就推荐这种做法。）然而，对于通常较短的模式来说，长字符串表示法，似乎有些繁琐。此外，我们将失去在模式内部使用转义的能力。（一些模式匹配工具，则通过重新实现通常的字符串转义，绕过了这种限制。）


Lua 的解决方案就更简单了：Lua 中的模式，将百分号用作了转义符。(C 语言中的几个函数，如 `printf` 和 `strftime`，也采用了同样的解决方案）。一般来说，任何转义过的字母数字字符，都具有某种特殊含义（例如，`"%a"` 就匹配任意字母），而任何转义的非字母数字字符，都代表其本身（例如，`"%."` 匹配点）。


我们将从 *字符类，character classes*，开始讨论模式。所谓字符类，是某个模式中，可以匹配到特定字符集中，任何字符的一个项目。例如，字符类 `%d`，就可以匹配任何数字。因此，我们可以使用 `"%d%d/%d%d/%d%d%d"` 模式，检索格式为 `dd/mm/yyyy` 的日期：


```lua
s = "Deadline is 30/11/2023, firm"
date = "%d%d/%d%d/%d%d%d%d"
print(string.match(s, date))    --> 30/11/2023
```

下表列出了那些预定义的字符类，及其含义：


| 字符类 | 含义 |
| :-- | :-- |
| `.` | 全部字符 |
| `%a` | 字母，包括大小写, `a-zA-Z`） |
| `%c` | 控制字符，control characters |
| `%d` | 数字，`0-9`）|
| `%g` | 除空格外的可打印字符，printable characters except spaces |
| `%l` | 小写字母 |
| `%p` | 标点符号，punctuation characters |
| `%s` | 空格 |
| `%u` | 大写字母 |
| `%w` | 字母和数字字符 |
| `%x` | 十六进制数字，`0-9a-fA-F`？ |




