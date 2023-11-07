# 查漏补缺

**Filling some Gaps**


在前面的示例中，我们已经使用了 Lua 的大部分语法结构，但很容易遗漏一些细节。为了完整起见，本章将在本书第一部分的结尾，介绍更多有关这些语法结构的细节。


## 本地（局部）变量与代码块


默认情况下，Lua 中的变量是全局变量。所有局部变量，都必须被声明。与全局变量不同，局部变量的作用域，仅限于声明他的代码块。所谓 *代码块，block*，是指控制结构的主体，the body of a control structure、函数的主体，the body of a function或块，a chunk（声明变量的文件或字符串）：


```lua
x = 10
local i = 1         -- 相对这个块，chunk，是本地的

while i <= x do
    local x = i * 2 -- 相对于这个 while 主体，是本地的
    print(x)
    i = i + 1
end


if i > 20 then
    local x         -- 相对于 then 这个主体，是本地的
    x = 20
    print(x + 2)    -- （在 if 测试成功时，应打印出 22）
else
    print(x)        -- 10（全局的那个）
end

print(x)            -- 10（全局的那个）
```


请注意，如果咱们以交互模式输入，最后一个示例将无法按预期工作。在交互模式下，每一行本身就是一个块（除非他不是一个完整的命令）。一旦咱们输入示例的第二行（`local i = 1`），Lua 就会运行他，并在下一行中开始一个新块。到那时，`local` 的声明已经超出了范围。为了解决这个问题，我们可以显式地分隔整个块，以关键字 `do-end` 将其括起来。一旦你输入了 `do`，命令只会在相应 `end` 处完成，故而 Lua 不会自己执行每一行。


当我们需要更精细地控制，某些局部变量的作用域时，这些 `do` 块也很有用：


```lua
local x1, x2
do
    local a2 = 2*a
    local d = (b^2 - 4*a*c)^(1/2)

    x1 = (-b + d)/a2
    x2 = (-b - d)/a2
end                         -- 'a2' 与 'd' 的作用域在这里结束

print(x1, x2)               -- 'x1' 与 `x2` 仍在作用域中
```


尽可能使用局部变量，是一种良好的编程风格。局部变量以非必要的名字，避免了搞乱全局变量；他们还可以避免程序不同部分之间的名字冲突。此外，访问局部变量比访问全局变量更快。最后，一旦局部变量的作用域结束，他就会消失，从而允许垃圾回收器释放出他的值。


鉴于局部变量比全局变量“更好”，有人认为 Lua 应该默认使用局部变量。然而，默认使用局部变量，也有其自身的问题（例如，访问非局部变量的问题）。更好的方法，是不使用默认值，也就是说，所有变量都应在使用前声明。Lua 发行版自带了一个用于全局变量检查的模块 `strict.lua`；如果我们在某个函数中，试图给某个不存在的全局变量赋值，或者使用某个不存在的全局变量，他就会抛出错误。在开发 Lua 代码时，使用 `strict.lua` 这个全局变量检查模块，是个好习惯。


每个局部声明，都可以包含一个初始的赋值，其工作方式与传统的多重赋值相同：多余的值会被丢弃，多余的变量会得到 `nil`。如果某个声明没有初始赋值，那么他的所有变量，都将被初始化为 `nil`：


```lua
local a, b = 1, 10
if a < b then
    print(a)    --> 1
    local a     -- 这里 '= nil' 是隐式的
    print(a)    -- nil
end
print(a, b)     --> 1   10
```


Lua 中一个常见的习惯用法是：

```lua
local foo = foo
```

此代码会创建出局部变量 `foo`，并用全局变量 `foo` 的值，对其进行初始化。（局部变量 `foo` 只有在声明 *后* 才可见。）对于加快对 foo 的访问速度，此习惯用法很有用。在即使后来其他函数，改变了全局变量 `foo` 的值，而仍要保修 `foo` 的原始值时，这种方法也很有用；特别是，他能使代码免受猴子修补，monkey patching，<sup>注 3</sup>的影响。任何以 `local print = print` 开头的代码，都将使用原始函数 `print`，即使 `print` 被猴子修补成了其他东西。

> **注 3**：关于 “猴子修补”，参见 [Wikipedia: Monkey patch](https://en.wikipedia.org/wiki/Monkey_patch)。


一些人认为，在代码块中间使用声明，是一种不好的做法。恰恰相反：通过只有在需要时才声明变量，我们就很少需要在没有初始值的情况下，声明变量（因此我们也很少会忘记初始化变量）。此外，我们还缩短了变量的作用域，从而提高了可读性。


## 控制结构


Lua 提供了一小套常规的控制结构，其中 `if` 用于条件执行，而 `while`、`repeat` 和 `for`，用于迭代。所有控制结构的语法，都有明确的终止符：`end` 终止 `if`、`for` 和 `while` 结构；`until` 终止 `repeat` 结构。


控制结构的条件表达式，可以产生任何值。请记住，Lua 将不同于 `false` 和 `nil` 的所有值，都视为 `true`。(特别是，Lua 将 `0` 和空字符串，都视为 `true`。）


### `if-then-else`

`if` 语句会测试其条件，并相应地执行 *`then` 部分，`then`-part* 或 *`else` 部分，`else`-part*。`else` 部分是可选的。

```lua
if a < 0 then a = 0 end

if a < b then return a else return b end

if line > MAXLINES then
    showpage()
    line = 0
end
```

要编写嵌套的 `if`，我们可以使用 `elseif`。他类似于一个 `else` 后面跟一个 `if`，但避免了多个 `end` 的需要：


```lua
if op == "+" then
    r = a + b
elseif op == "-" then
    r = a - b
elseif op == "*" then
    r = a*b
elseif op == "/" then
    r = a/b
else
    error("invalid operation")
end
```

由于 Lua 没有 `switch` 语句，所以这种链条会比较常见。


### `while`


顾名思义，`while` 循环，会在条件为真的情况下，重复其循环体，its body。通常，Lua 会首先测试 `while` 条件；如果条件为假，则循环结束；否则，Lua 会执行循环体，并重复循环过程。


```lua
local i = 1
while a[i] do
    print(a[i])
    i = i + 1
end
```

### `repeat-util`


顾名思义，`repeat-until` 语句，会重复执行其主体，its body，直到条件为真。该语句是在循环体之后，进行测试，因此总是会至少执行一次循环体。


```lua
-- 打印出首个非空的输入行
local line

repeat
    line = io.read()
until line ~= ""

print(line)
```


与大多数其他语言不同，在 Lua 中，循环内声明的局部变量的作用域，会将条件包含起来：


```lua
-- 使用 Newton-Raphson 方法，计算 'x' 的平方根
function NR_sqrt (x)
    local sqrt = x / 2

    repeat
        sqrt = (sqrt + x/sqrt) / 2
        local error = math.abs(sqrt^2 - x)
    until error < x/10000       -- 循环体中的本地 'error' 变量，在这里仍然可见

    return sqrt
end
```


### 数值的 `for`

**Numerical `for`**


`for` 语句有两个变体：*数值的，numerical* `for` 和 *泛型的，generic* `for`。


数值的 `for`，有着以下语法：


```lua
for var = exp1, exp2, exp3 do
    something
end
```

此循环将对 `var`，从 `exp1` 到 `exp2` 的每个值执行 `something`，将 `exp3` 用作递增 `var` 的 *步长，step*。其中第三个表达式是可选的；在没有第三个表达式时，Lua 将假定步长为 `1`。如果咱们想要一个没有上限的循环，可以使用常量 `math.huge`：


```lua
for i = 1, math.huge do
    if (0.3*i^3 - 20*i^2 - 500 >=0) then
        print(i)
        break
    end
end
```


`for` 循环有一些微妙之处，要很好地利用他，咱们就应掌握这些微妙之处。首先，在循环开始之前，所有三个表达式都要求值一次。其次，那个控制变量，是 `for` 语句自动声明的一个局部变量，只在循环内部才可见。典型的错误，便是假定了该变量，在循环结束后仍然存在：


```lua
for i = 1, 10 do print(i) end
max = i         -- 可能就是错的了！

print(max)      -- 这里将打印出 nil
```

在循环结束后（通常是在中断循环时），如果咱们需要那个控制变量的值，则必须将其，保存到另一变量中：


```lua
-- 找到列表中的某个值
a = {0, 1, 3, 5, 7, -1, 9, -13}

local found = nil
for i = 1, #a do
    if a[i] < 0 then
        found = i   -- 保存 'i' 的值
        break
    end
end

print(found, a[found])
```

第三，咱们不应修改控制变量的值：这种修改的效果，是不可预测的。咱们如果想在 `for` 循环正常结束之前，结束他，可以使用 `break`（就像我们在上一示例中所做的那样）。



### 泛型的 `for`



