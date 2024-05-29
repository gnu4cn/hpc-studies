# 面向对象编程

**Object-Oriented Programming**


Lua 中的表，在不止一种意义上是个对象。与对象一样，表也有状态。与对象一样，表也有一个与其值无关的身份（`self`）。具体来说，具有相同值的两个对象（表）是不同的对象，而某个对象在不同时间，亦可以具有不同值。与对象一样，表的生命周期与创建者或在何处被创建无关。


对象有自己的操作。表也可以有操作，如下面的代码片段：


```lua
Account = {balance = 0}
function Account.withdraw (v)
    Account.balance = Account.balance - v
end
```

该定义创建了一个新函数，并将其存储在对象 `Account` 的 `withdraw` 字段中。然后，我们可以像这样调用他：


```lua
Account.withdraw(100.00)
```


这种函数几乎就是我们所说的方法。然而，在函数中使用全局的名字 `Account` 是一种可怕的编程做法。首先，该函数只对这个特定对象有效。其次，即使是这个特定的对象，只要该对象仍存储在这个特定的全局变量中，函数就会起作用。如果我们更改了对象的名称， `withdraw` 就不再起作用了：


```console
> a, Account = Account, nil
> a.withdraw(100.00)
lib/account.lua:3: attempt to index a nil value (global 'Account')
stack traceback:                                                                                                                                  lib/account.lua:3: in function <lib/account.lua:2>                                                                                        (...tail calls...)                                                                                                                        [C]: in ?
```


此类行为违反了对象具有独立生命周期的原则，the principle that objects have independent life cycles。


一种更具原则性的方法，是对操作的 *接收者，receiver* 进行操作。为此，我们的方法需要一个包含接收者值的额外参数。这个参数的名称，通常是 `self` 或 `this`：


```lua
function Account.withdraw (self, v)
    self.balance = self.balance - v
end
```


现在，当我们调用该方法时，就必须指定他要操作的对象：


```console
$ lua -i lib/account.lua
Lua 5.4.4  Copyright (C) 1994-2022 Lua.org, PUC-Rio
> a1, Account = Account, nil
> a1.balance = 1000.00
> a1.withdraw(a1, 100.00)
> print(a1.balance)                                                                                                                       900.0
```

通过 `self` 参数的使用，我们便可以对多个对象，使用这同一个方法：


```console
$ lua -i lib/account.lua
Lua 5.4.4  Copyright (C) 1994-2022 Lua.org, PUC-Rio
> a2 = {balance=0, withdraw = Account.withdraw}
> a2.withdraw(a2, 260.00)
> print(a2.balance)                                                                                                                       -260.0
```

`self` 参数的使用，是任何面向对象语言的核心要点。大多数面向对象编程语言，对程序员隐藏了这一机制，因此程序员不必声明这一参数（不过仍可在方法中使用 `self` 或 `this` 的名字）。Lua 也可以通过 *冒号操作符, the colon operator*，来隐藏这个参数。使用他，咱们就可以将之前的方法调用，重写为 `a2:withdraw(260.00)`，并将之前的定义重写为下面这样：


```lua
function Account:withdraw (v)
    self.balance = self.balance - v
end
```


冒号的作用，是在方法调用中增加一个额外的参数，并在方法定义中增加一个额外的隐藏参数。冒号仅是一种语法工具，a syntactic facility, 尽管很方便；这里并没有什么新东西。我们可以用点语法定义一个函数，然后用冒号语法调用他，反之亦然，只要我们能正确处理额外的参数：


```lua
Account = {balance = 0,
    withdraw = function (self, v)
        self.balance = self.balance - v
    end
}

function Account:deposit (v)
    self.balance = self.balance + v
end
```


```console
$ lua -i lib/account.lua
Lua 5.4.4  Copyright (C) 1994-2022 Lua.org, PUC-Rio
> Account.deposit(Account, 2000.00)
> Account.balance
2000.0
> Account:withdraw(150.00)
> Account.balance                                                                                                  1850.0
```



## 类

**Classes**


到目前为止，我们的对象已经有了身份、状态和对状态的操作。他们仍然缺乏类系统、继承和隐私，lack a class system, inheritance, and privacy。咱们来解决第一个问题：如何创建具有相似行为的多个对象？具体来说，我们如何创建多个账户？


大多数面向对象编程语言，都提供类的概念，其充当了创建对象的模具。在这类语言中，每个对象都是个特定类的实例。Lua 没有类的概念；元表的概念有些类似，但将其用作类，并不会让我们走得太远。相反，我们可以效仿基于原型的语言（如 [Self](https://selflanguage.org/)，Javascript 同样遵循了这条路径），在 Lua 中模拟出类。在这些语言中，对象同样没有类。相反，每个对象都可能有是个常规对象的原型，a prototype, which is a regular object，首个对象会在原型中，查找他不知道的任何操作。要在这类语言中表示类，我们只需创建一个对象，专门用作其他对象（其实例）的原型。类和原型，都是放置多个对象共用行为的地方。


在 Lua 中，我们可以使用在 [`__index` 元方法](https://hpcl.xfoss.com/lua_tut/metatables_and_metamethods.html#__index-%E6%96%B9%E6%B3%95) 小节中，看到的继承概念来实现原型。更具体地说，如果我们有两个对象 `A` 和 `B`，要使 `B` 成为 `A` 的原型，我们只需这样做：


```lua
    setmetable(A, {__index = B})
```


之后，`A` 会在 `B` 中，查找他没有的任何操作。把 `B` 看作对象 `A` 的类，不过是术语上的变化而已。


咱们回到银行账户的例子。要创建行为与 `Account` 类似的其他账户，我们可以使用 `__index` 元方法，让这些新对象从 `Account` 继承其操作。


```lua
local mt = {__index = Account}

function Account.new (o)
    o = o or {}     -- 若用户没有提供表，就要创建出表
    setmetatable(o, mt)
    return o
end
```

在这段代码之后，当我们创建一个新账户并调用某个方法时，会发生什么呢？


```console
$ lua -i lib/account.lua
Lua 5.4.4  Copyright (C) 1994-2022 Lua.org, PUC-Rio
> a = Account.new{balance = 0}
> a:deposit(100.00)
> a.balance
100.0
```

当我们创建新帐户 `a` 时，他将使用 `mt` 作为其元表。当我们调用 `a:deposit(100.00)` 时，我们实际上是在调用 `a.deposit(a, 100.00)`；冒号只是语法糖。然而，Lua 在表 `a` 中找不到 `deposit` 条目；因此，Lua 会查看元表的 `__index` 条目。现在的情况或多或少是这样的:

```lua
getmetatable(a).__index.deposit(a, 100.00)
```


`a` 的元表是 `mt`，而 `mt.__index` 是 `Account`。因此，前一个表达式就会求值到这个表达式：


```lua
Account.deposit(a, 100.00)
```

也就是说，Lua 调用了原先的 `deposit` 函数，但将 `a` 作为 `self` 参数传递。因此，这个新账户 `a` 就从 `Account` 继承了 `deposit` 函数。通过同样的机制，他也继承了 `Account` 的所有字段。

我们可以对这种方案做两处小的改进。首先，我们不需要为其中的元表角色，创建一个新表；相反，我们可以使用 `Account` 表本身，来实现这一目的。第二处改进是，我们也可以为 `new` 方法使用冒号语法。有了这两处改动，方法 `new` 就变成了下面这样：


```lua
function Account:new (o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end
```

现在，当我们调用 `Account:new()` 时，那个隐藏参数 `self` 的值，即为 `Account`，我们使 `Account.__index` 同样等于 `Account`，进而将 `Account` 设置为其中新对象的元表。第二处改动（其中的冒号语法），似乎并没有给我们带来什么好处；在下一节中介绍类的继承时，使用 `self` 的好处就会显现出来。


继承不仅适用于方法，也适用于在新账号中，缺失的其他字段。因此，某个类不仅可以提供方法，还可以为其实例的字段，提供常量及默认值。请记住，在 `Account` 的首个定义中，我们提供了一个值为 `0` 的字段 `balance`。因此，如果我们创建出一个没有初始余额的新账户，他将继承这个默认值：


```console
$ lua -i lib/account.lua
Lua 5.4.4  Copyright (C) 1994-2022 Lua.org, PUC-Rio
> b = Account:new()
> print(b.balance)                                                                                                                 0
0
```

当我们调用 `b` 上的 `deposit` 方法时，他会运行与以下代码等效的代码，因为 `self` 就是 `b`：

```lua
b.balance = b.balance + v
```

其中的表达式 `b.balance` 的计算结果为零，并且该方法会将初始存款，分配给 `b.balance`。后续访问 `b.balance` 将不会调用索引的元方法，因为现在 `b` 有了自己的 `balance` 字段。


## 继承

**Inheritance**


因为类属于对象，所以他们也可以从其他类中获取方法。这种行为使得继承（在通常的面向对象意义上）就很容易在 Lua 中实现。

假设我们有个如下图 21.1 中 “`Account` 类” 的基类，a base class。


**图 21.1 `Account` 类**


```lua
Account = {balance = 0}

function Account:new (o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end

function Account:deposit (v)
    self.balance = self.balance + v
end

function Account:withdraw (v)
    if v > self.balance then error"资金不足" end
    self.balance = self.balance - v
end
```


现在我们打算从该类，派生出一个允许客户提取超过余额金额的子类 `SpecialAccount`。我们从一个直接从其基类，继承了所有操作的空类开始：


```lua
SpecialAccount = Account:new()
```


到目前为止，`SpecialAccount` 还只是 `Account` 的一个实例。现在，神奇的事情发生了：


```console
s = SpecialAccount:new{limit=1000.00}
```



