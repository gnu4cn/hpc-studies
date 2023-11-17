# 编译，执行与报错

尽管我们将 Lua 称作解释型语言，但 Lua 总是会在运行源代码之前，将其预编译为中间形式（这没什么大不了的：许多解释型语言，也是如此。）编译阶段的存在，听起来可能与解释型语言格格不入。然而，解释型语言的显著特点，并不是不编译，而是可以（而且很容易）执行即时生成的代码。我们可以说，正是因为有了 `dofile` 这样的函数，我们才有资格，把 Lua 称作解释型语言。


在本章中，我们将更详细地讨论，Lua 运行其代码块，its chunks，的过程，编译的含义与作用，Lua 如何执行编译后的代码，以及如何处理在这一过程中，出现的错误。


## 编译

**Compilation**


早先，我们将 `dofile`，作为运行 Lua 代码块的一种原语操作，加以了引入，但 `dofile` 实际上是一个辅助函数，an auxiliary function：函数 `loadfile` 真正完成了艰苦工作。与 `dofile` 一样，`loadfile` 会从文件，加载 Lua 块，但他不运行该块。相反，他只会编译块，并将编译后的块，作为函数返回。此外，与 `dofile` 不同，`loadfile` 不会抛出错误，而是返回错误代码。我们可以像下面这样，定义一个 `dofile`：


```lua
function dofile (filename)
    local f = assert(loadfile(filename))
    return f()
end
```

请注意，其中那个在 `loadfile` 失败时，用于抛出错误的 `assert` 的运用。
