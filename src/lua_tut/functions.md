# 函数

函数是 Lua 中，语句和表达式抽象的主要机制。函数既可以执行特定任务（在其他语言中有时称为 *过程，procedure*，或 *子程序，subroutine*），也可以计算并返回值。在第一种情况下，我们会将函数调用用作语句，use a function call as a statement；在第二种情况下，我们将函数调用，用作表达式，use it as an expression：


```lua
> print(8*9, 9/8)
72      1.125
> a = math.sin(3) + math.cos(10)
> print(os.date())
11/03/23 14:12:05
```

两种情况下，用括号括起来的参数列表，都表示了这种函数调用；如果调用没有参数，我们仍必须写下一个空列表，`()`，来表示函数调用。这条规则有一个特例：在函数只有一个参数，且该参数是字面字符串，或表构造器时，表示函数调用的括号，则是可选的：


```lua
> print "Hello World"       <-->    print("Hello World")
Hello World
> dofile 'lib.lua'          <-->    dofile("lib.lua")
> function f(a) ; end
> f{x=10, y=20}             <-->    f({x=10, y=20})
> type{}                    <-->    type({})
table
```

Lua 还为面向对象的调用，提供了一种特殊的语法，即冒号操作符。像 `o:foo(x)` 这样的表达式，就调用了对象 `o` 中的方法 `foo`。在第 21 章 [*面向对象编程*](oop.md) 中，我们将更详细地讨论，这样的调用及面向对象编程。


Lua 程序可以使用在 Lua 及 C（或主机应用程序用到的任何其他语言）中，定义的函数。通常情况下，咱们使用 C 语言函数，是为了获得更好的性能，以及访问那些不易从 Lua 直接访问的设施（如操作系统设施）。例如，标准 Lua 库中的所有函数，都是用 C 语言编写的。不过，在调用函数时，Lua 中定义的函数，与 C 中定义的函数，并无区别。


正如我们在其他示例中看到的，Lua 中的函数定义，有着传统的语法，就像下面这样：


```lua
-- 将序列 'a' 的元素相加
function add (a)
    local sum = 0

    for i, #a do
        sum = sum + a[i]
    end

    return sum
end
```

在这种语法中，函数定义包含了一个 *名字，name*（在示例中为 `add`）、一个 *参数，parameters* 列表，和一个 *主体，body*（即语句的列表）。参数的作用，跟使用函数调用中传递的参数值，所初始化的局部变量完全相同。


我们可以使用与其参数数量不同的参数，来调用某个函数。 Lua 通过丢弃额外的参数，以及为额外的参数提供一些 `nil` 值，来调整参数的数量。例如，请考虑下面这个函数：


```lua
function f (a, b) print(a, b) end
```

其有着以下行为：


```lua
> f()
nil     nil
> f(3)
3       nil
> f(3, 4)
3       4
> f(3, 4, 5)        --> 5 会被丢弃
3       4
```

尽管这样的行为可能导致编程错误，programming errors（通过最少的测试，即可轻松发现），但他也很有用，尤其是对于默认参数。例如，请考虑下面的对某个全局计数器递增的函数：


```lua
function incCount (n)
    n = n or 1
    globalCounter = globalCounter + n
end
```

该函数的默认参数为 `1`；调用 `incCount()`（不带参数）时，`globalCounter` 会递增 `1`。当我们调用 `incCount()` 时，Lua 会首先将参数 `n`，初始化为 `nil`；而 `or` 表达式的结果为第二个操作数，因此 Lua 会将 `n` 赋值为默认的 `1`。



## 多个返回值

函数可以返回多个结果，这是 Lua 的一个非常规，但相当方便的特性。有几个 Lua 中预定义的函数，可以返回多个值。我们已经看到过函数 `string.find`，他可以在字符串中定位出某种模式。在找到模式时，该函数会返回两个索引：匹配开始处字符的索引，和匹配结束处字符的索引。多重赋值，a multiple assignment，允许程序获得这两个结果：


```lua
> s, e = string.find("Hello Lua users", "Lua")
> print(s, e)
7       9
```
