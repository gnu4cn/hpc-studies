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


此类行为违反了对象具有独立生命周期的原则，objects have independent life cycles。



