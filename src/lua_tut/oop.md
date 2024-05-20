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

function Account::deposit (v)
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




