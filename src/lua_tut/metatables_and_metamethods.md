# 元表与元方法

**Metatables and Metamethods**


通常，Lua 中的每个值，都有一套相对可预测的操作。我们可以把数字相加，可以连接字符串，可以将键值对，插入表等等。但是，我们不能把表相加，不能把函数作比较，也不能调用字符串。除非我们使用元表。


元表允许我们在某个值面临某种未知操作时，改变其行为。例如，运用元表，我们可以定义 Lua 如何计算表达式 `a + b`，其中 `a` 和 `b` 是表。每当 Lua 尝试将两个表相加时，他都会检查两个表之一，是否有个 *元表，metatable*，以及元表是否有个 `__add` 字段。如果 Lua 找到了这个字段，他就会调用相应的值 -- 即所谓的 *元方法，metamethod*，其应是个计算和的函数。


我们可以把元表，看作面向对象的术语体系中，一种受限制的类。与类一样，元表定义了其实例的行为。不过，元表比类更受限，因为他们只能将行为赋予给一组预定义操作；同时，元表不具有继承性。不过，我们将在第 21 章，[面向对象编程](oop.md) 中，看到如何在元表的基础上，构建出一种相当完整的类系统。


Lua 中的每个值，都可以有个元表。表和用户数据，都有各自的元表；其他类型的值，则共享该类型全体值的单个元表。Lua 总是会创建出，不带元表的新表：



```lua
t = {}
print(getmetatable(t))      --> nil
```

我们可以使用 `setmetatable`，来设置或更改某个表的元表：


```lua
t1 = {}
setmetatable(t, t1)
assert(getmetatable(t) == t1)
```

在 Lua 中，我们只能设置表的元表；要操作其他类型值的元表，我们必须使用 C 代码，或调试库。(这一限制的主要原因，是为了限制宽类型元表的过度使用，to curb excessive use of type-wide metables。一些老版本 Lua 的经验表明，这些全局设置，经常会导致不可重用的代码。）字符串库为字符串设置了元表；所有其他类型，默认情况下，均无元表：


```lua
print(getmetatable("hi"))               --> table: 000002634fa4aea0
print(getmetatable("xuxu"))             --> table: 000002634fa4aea0
print(getmetatable(10))                 --> nil
print(getmetatable(print))              --> nil
```

任何的表，都可以是任何值的元表；一组相关的表，可以共用一个描述他们共同行为的共同元表；某个表可以是他自己的元表，从而用来描述他自己的单独行为。任何的配置，都是有效的。


## 算术的元方法

**Arithmetic Metamethods**


在这一小节中，我们将引入一个运行示例，来解释元表的基础知识。假设我们有个使用表来表示集合，并使用函数来计算集合的并集、交集等的模组，如下图 20.1，“一个简单的集合模块” 所示。


### 图 20.1，一个简单的集合模组


```lua
local Set = {}

-- 以给定列表，创建出一个新的集合
function Set.new (l)
    local set = {}
    for _, v in ipairs(l) do set[v] = true end
    retur set
end

function Set.union (a, b)
    local res = Set.new{}
    for k in pairs(a) do do res[k] = true end
    for k in pairs(b) do do res[k] = true end
    return res
end

function Set.intersection (a, b)
    local res = Set.new{}
    for k in pairs(a) do
        res[k] = b[k]
    end
    return res
end


-- 将集合表示为字符串
function Set.tostring (set)
    local l = {}    -- 将该集合中全部元素放入的列表
    for e in pairs(set) do
        l[#l + 1] = tostring(e)
    end
    return "{" .. table.concat(l, ", ") .. "}"
end

return Set
```


现在，我们打算使用加法运算符，来计算两个集合的并集。为此，我们将安排所有代表集合的表，共享某个元表。这个元表将定义出，他们对加法运算符的反应。我们的第一步，是创建出一个常规表，并将其用作集合的元表：


```lua
local mt = {}       -- 集合的元表
```


下一步是修改创建出集合的 `Set.new`。新版本只多了将 `mt`，设置为其所创建出表的元表的一行：


```lua
function Set.new (l)        -- 第二版
    local set = {}
    setmetatable(set, mt)
    for _, v in ipairs(l) do set[v] = true end
    retur set
end
```


自那以后，我们使用 `Set.new` 创建的每个集合，都将以那同一个表，作为其元表：


```lua
s1 = Set.new{10, 20, 30, 50}
s2 = Set.new{30, 1}
print(getmetatable(s1))         --> table: 000002ade230b160
print(getmetatable(s2))         --> table: 000002ade230b160
```

最后，我们将 *元方法，metamethod* `__add`，一个描述如何执行加法运算的字段，添加到那个元表：


```lua
mt.__add = Set.union
```

自那以后，每当 Lua 尝试加上两个集合时，他都会调用 `Set.union`，并将两个操作数，作为参数。

有了这个元方法，我们就可以使用加法运算符，来完成集合的并集运算：


```lua
s3 = s1 + s2
print(Set.tostring(s3))         --> {1, 30, 10, 20, 50}
```

类似地，我们也可以将乘法运算符，设置为执行集合的交集运算：


```lua
mt.__mul = Set.intersection

print("s1 x s2 = ", Set.tostring(s2 * s1))  --> {30}
```

对于每个算术运算符，都有一个元方法名字与之对应。除加法和乘法外，还有：

- 减法（`__sub`）

- 浮除，float division（`__div`）

- 底除，floor division（`__idiv`）

- 求反，negation（`__unm`）

- 取模，modulo（`__mod`）

- 及幂运算（`__pow`）

同样，所有位操作，也都有相应的元方法：

- 位与操作，AND (`__band`)

- 或，OR (`__bor`)

- 异或，OR (`__bxor`)

- 非，NOT (`__bnot`)

- 左移位 (`__shl`)

- 右移位 (`__shr`)

我们还可以用（元表中的）字段 `__concat`，来定义连接运算符（`..`）的行为。


> **译注**：Lua 的这种元表与元方法的特性，与 Rust 中 [运用特质实现运算符重载](https://doc.rust-lang.org/rust-by-example/trait/ops.html) 类似。


在我们将两个集合相加时，不存在使用哪种元表的问题。不过，我们可能会编写一个，混合了两个有着不同元表的值的表达式，例如像这样：

```lua
s = Set.new{1, 2, 3}
s = s + 8
```

在查找元方法时，Lua 会执行以下步骤：在第一个值有着带有所需元方法的元表时，那么 Lua 就会独立于第二个值，而使用这个元方法；否则，在第二个值有着带有所需元方法的元表时，Lua 就会使用这个元方法；否则，Lua 就会抛出错误。因此，最后这个示例，与表达式 `10 + s` 和 `"hello" + s` 一样，都将调用 `Set.union`（因为数字和字符串，都没有元方法 `__add`）。

Lua 不会关心这些混合类型，但我们的实现会关心。如果我们运行 `s = s + 8` 那个示例，我们会得到函数 `Set.union` 内部的一个报错：

```console
bad argument #1 to 'for iterator' (table expected, got number)
```

如果我们想要获得更清晰的错误信息，就必须在尝试执行该运算前，显式检查操作数的类型，例如使用下面这样的代码：

```lua
    if getmetatable(a) ~= mt or getmetatable(b) ~= mt then
        error("attempt to 'add' a set with a non-set value", 2)
    end

    -- as before
```

请记住，`error` 的第二个参数（本例中为 `2`），会将错误信息中的源位置，设置到调用该运算的代码。

> **注意**：这句话的意思，是说报错本来是在 `mod_sets` 模组中，但因为这个第二参数 `2`，最终的报错输出，会显示为导入该模组的程序中。实际输出为：

```console
lua: ./arithmetic_metamethod.lua:16: attempt to 'add' a set with a non-set value
stack traceback:
        [C]: in function 'error'
        ./mod_sets.lua:14: in function 'mod_sets.union'
        ./arithmetic_metamethod.lua:16: in main chunk
        [C]: in ?
```

> 表示在 `arithmetic_metamethod.lua` 的第 16 行出错，该行正是调用了 `Set.union` 的 `s = s + 8` 语句。


## 关系型元方法

**Relational Metamethods**


元表还可以通过元方法

- `__eq` (等于)；

- `__lt` (小于)；

- 和 `__le` (小于等于)

而赋予这些关系运算符以意义。其他三个关系运算符，则没有单独的元方法： Lua 会

- 把 `a ~= b` 转换为 `not (a == b)`；

- 把 `a > b` 转换为 `b < a`；

- 把`a >= b` 转换为 `b <= a`。

在旧有版本中，Lua 曾通过把 `a <= b`，转换为 `not (b < a)`，把所有顺序运算符，order operators，都转换为单个运算符。然而，在我们有着其中的全部元素，并非都是恰当排序的类型，这种 *部分序，partial order* 时，这样的转换是不正确的。例如，由于非数值，Not a Number，`NaN` 值的存在，大多数机器都没有浮点数的一种总顺序，a total order for floating-point numbers。根据 IEEE 754 标准，`NaN` 表示未定义的值，例如 `0/0` 的结果。这意味着 `NaN <= x` 总是假，而 `x < NaN` 也是假。这也意味着在这种情况下，从 `a <= b` 到 `not (b < a)` 的转换，是无效的。
