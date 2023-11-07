# 闭包

Lua 中的函数，是具有适当词法作用域的一些头等值，functions in Lua are first-class values with proper lexical scoping。

函数是 “头等值”，是什么意思？这意味着，在 Lua 中，函数是与数字和字符串等常规值，具有相同权利的值。程序可以将函数，存储在变量（包括全局变量与局部变量）和表中，将函数作为参数，传递给其他函数，以及将函数作为结果返回。


函数具有“词法作用域，lexical scoping”，是什么意思？这意味着函数可以访问其外层函数的变量，functions can access variables of their enclosing functions。(这也意味着，Lua 正确地包含了 [lambda/λ 演算，the lambda calculus](https://en.wikipedia.org/wiki/Lambda_calculus)。）


这两个特性一起，赋予了 Lua 语言极大的灵活性；例如，在运行一段不被信任的代码（比如通过网络接收的代码）时，程序就可以重新定义一个函数，来添加新的功能，或删除某个函数，来创建出安全的环境。更重要的是，这两种特性，允许我们在 Lua 中，应用函数式语言世界中的许多强大编程技术。即使咱们对函数式编程完全毫无兴趣，也值得学习一下如何探索这些技术，因为他们可以让咱们的程序，变得更小更简单。


## 函数作为头等值

正如我们刚看到的，函数是 Lua 中的头等值。下面的示例说明了这一点：


```lua
a = {p = print}         -- 'a.p' 指向函数 'print'
a.p("Hello World")      -- Hello World

print = math.sin        -- 'print' 现在指向正弦函数
a.p(print(1))           -- 0.8414709848079

math.sin = a.p          -- 'sin' 现在指向打印函数
math.sin(10, 20)        -- 10       20
```

如果函数是些值，那么有创建函数的表达式吗？事实上，在 Lua 中编写函数的通常方法，比如


```lua
function foo (x) return 2*x end
```

便是我们所讲的 *语法糖，syntactic sugar* 的一个实例；其只是编写以下代码的一种漂亮方式：

```lua
foo = function (x) return 2*x end
```

赋值右侧的表达式（ `function (x) body end`），是个函数构造器，a function constructor，就像 `{}` 是表构造器一样。因此，函数定义，a function definition，实际上是创建出一个 `function` 类型值，并将其赋值给某个变量的一条语句。


请注意，在 Lua 中，所有函数都是匿名的。与其他值一样，他们没有名称。当我们讲到函数名称（如 `print`）时，实际上，我们是在讲存放该函数的变量。尽管我们经常将函数赋值给全局变量，给到他们一个类似于名字的东西，但在某些情况下，函数仍然是匿名的。我们来看几个例子。


表库提供了 `table.sort` 函数，该函数取一个表，并对其元素进行排序。这种函数必须允许排序顺序无限制地变化：升序或降序、数字或字母、根据键排序的表等。`sort` 并没有试图提供各种选项，而是提供了单一的可选参数，即 *排序函数，order function*：接收两个元素，并返回第一个元素是否必须排在第二个元素之前。例如，假设我们有下面这种记录的一个表：


```lua
network = {
    {name = "grauna",   IP = "210.26.30.34"},
    {name = "arraial",  IP = "210.26.30.23"},
    {name = "lua",      IP = "210.26.23.12"},
    {name = "derain",   IP = "210.26.23.20"},
}
```

如果我们打算按字段 `name` 的字母倒序，对该表进行排序，只需这样写即可：

```lua
table.sort(network, function (a, b) return (a.name > b.name) end)
```

看看在这个语句中，匿名函数是多么方便。

将另一函数作为参数的函数，比如 `sort`，我们称之为 *高阶函数，higher-order function*。高阶函数是一种功能强大的编程机制，而使用匿名函数，来创建他们的函数参数，便可以极大地提高灵活性。尽管如此，请记住，高阶函数并无特殊权利；他们是 Lua 将函数，作为头等值处理的直接结果。

为进一步说明高阶函数的使用，我们将编写一个常见高阶函数，导数，the derivative，的简单实现。在某种非正式的定义中，函数 *f* 的导数，是指当 *d* 变得无限小时的函数 *f'(x) = (f(x + d) - f(x)) / d*，根据这一定义，我们可以计算出，导数的近似值如下：


```lua
function derivative (f, delta)
    delta = delta or 1e-4
    return function (x)
        return (f(x + delta) - f(x))/delta
    end
end
```

在给定某个函数 `f` 时，调用 `derivative(f)` 就会返回其导数（近似值），而这个导数，就是另一个函数了：


```console
> c = derivative(math.sin)
> print(math.cos(5.2), c(5.2))
0.46851667130038        0.46856084325086
> print(math.cos(10), c(10))
-0.83907152907645       -0.83904432662041
> c = derivative(math.sin, 0.000000001)
> print(math.cos(5.2), c(5.2))
0.46851667130038        0.46851666990477
> print(math.cos(10), c(10))
-0.83907152907645       -0.83907158998642
```


## 非全局函数

**Non-Global Functions**


头等的函数的一个明显结果，便是我们不仅可以将函数存储在全局变量中，还可以在表字段，及局部变量中存储函数。


我们已经看到过，几个表字段中函数的例子：大多数 Lua 库，都使用这种机制（例如，`io.read`、`math.sin`）。要在 Lua 中创建此类函数，我们只需将迄今为止所学到的知识，整合在一起即可：


```lua
Lib = {}
Lib.foo = function (x, y) return x + y end
Lib.goo = function (x, y) return x - y end

print(Lib.foo(2, 3), Lib.goo(2, 3))     --> 5       -1
```

当然，咱们也可以使用构造器：


```lua
Lib = {
    foo = function (x, y) return x + y end,
    goo = function (x, y) return x - y end
}
```
