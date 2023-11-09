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
