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

    for i = 1, #a do
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

(请记住，字符串第一个字符索引为 `1`。）


我们在 Lua 中编写的函数，也可以返回多个结果，方法是在 `return` 关键字后，列出所有结果。例如，查找某个序列中最大元素的函数，便可以返回最大值及其位置：


```lua
function maxium (a)
    local mi = 1            -- 最大值的索引
    local m = a[mi]         -- 最大值

    for i = 1, #a do
        if [ai] > m then
            mi = i; m = a[i]
        end
    end

    return m, mi
end

print(maxium({8, -1, 10, 23, 12, 5}))       --> 23      4
```


Lua 总是会根据调用的具体情况，调整函数结果的数量。当我们以语句形式调用函数时，Lua 会丢弃函数的所有结果。当我们将函数调用，作为表达式（例如加法的操作数）时，Lua 会只保留第一个结果。只有当调用是表达式列表中，最后一个（或唯一一个）表达式时，我们才能得到所有结果。这些列表会出现在 Lua 的四种结构中：

- 多重赋值

- 函数调用的参数

- 表构造器

- 以及 `return` 语句


为了说明所有这些情况，我们将在接下来的示例中，假设以下定义：


```lua
> function foo0 () end                      -- 不返回结果
> function foo1 ()  return 'a' end          -- 返回 1 个结果
> function foo2 ()  return 'a', 'b' end     -- 返回 2 个结果
```


在多重赋值中，作为最后（或唯一）表达式的函数调用，会产生与变量匹配所需的任意多个结果：


```lua
> x, y = foo2()
> print(x, y)
a       b
> x = foo2()                -- 这里返回的 'b' 会被丢弃
> print(x)
a
> x, y, z = 10, foo2()
> print(x, y, z)
10      a       b
```


在多重赋值中，如果函数的结果少于我们的所需，Lua 会为缺失的值生成一些 `nil`：


```lua
> x,y = foo0()
> print(x, y)
nil     nil
> x,y = foo1()
> print(x, y)
a       nil
> x,y,z = foo2()
> print(x, y, z)
a       b       nil
```

请记住，只有当调用是列表中的最后（或唯一）的表达式时，才会出现多个结果。如果函数调用不是表达式列表中的最后一个元素，则总是只产生一个结果：


```lua
> x,y = foo2(), 20
> print(x, y)
a       20
> x,y = foo0(), 20, 30
> print(x, y)
nil     20
```


当函数调用是另一调用的最后一个（或唯一一个）参数时，第一个调用的所有结果，都将作为参数。我们已经在 `print` 中，看到了这种结构的例子。由于 `print` 可以接收可变数量的参数，因此语句 `print(g())` 会打印出 `g` 返回的所有结果。


```lua
> print(foo0())             -- （没有结果）

> print(foo1())
a
> print(foo2())
a       b
> print(foo2(), 1)
a       1
> print(foo2() .. 'x')      -- （请参阅下文）
ax
```

当对 `foo2` 的调用，出现在某个表达式中时，Lua 会将结果数调整为一个；因此，在最后一行中，连接操作只会使用第一个结果 `"a"`。


在我们写下 `f(g())`，且 `f` 有着固定参数数目时，Lua 会将 `g` 的结果数，调整为 `f` 的参数数目。这并非偶然，这与多重赋值中发生的行为，完全相同。


表构造器，也会收集调用的所有结果，而不做任何调整：



```lua
> t = {foo0()}                              -- t = {}（一个空表）
> for k, v in pairs(t) do print(k, v) end
> t = {foo1()}                              -- t = {'a'}
> for k, v in pairs(t) do print(k, v) end
1       a
> t = {foo2()}                              -- t = {'a', 'b'}
> for k, v in pairs(t) do print(k, v) end
1       a
2       b
```


与往常一样，只有当调用是列表中的最后一个（或唯一一个）表达式时，才会出现这种行为；在任何其他位置的调用，都只会产生一个结果：


```lua
> t = {foo0(), foo2(), 4}                   -- t = {nil, 'a', 4}
> for k, v in pairs(t) do print(k, v) end
2       a
3       4
```


> **注意**：这里 `t[1]` 没有打印出来。



最后，`return f()` 这样的语句，会返回 `f` 所返回的所有值：
