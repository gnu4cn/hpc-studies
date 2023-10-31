# 入门

为了保持传统，咱们用 Lua 编写的第一个程序，只是打印 `"Hello World"`：


```lua
print("Hello World")
```

如果咱们使用的是独立的 Lua 解释器，要运行第一个程序，只需调用解释器 -- 通常命名为 `lua` 或 `lua5.3`，并输入包含程序的文本文件名称即可。如果将上述程序保存在 `hello.lua` 文件中，下面的命令就可以运行它：

```bash
% lua hello.lua
```


作为一个更复杂示例，下一个程序定义了一个计算给定数字阶乘的函数，要求用户输入一个数字，并打印其阶乘：


```lua
-- defines a factorial function
function fact (n)
    if n == 0 then
        return 1
    else
        return n * fact(n - 1)
    end
end

print("Please enter a number:")
a = io.read("*n")               -- reads a number
print(fact(a))
```

> **注意**：此 Lua 脚本，只能计算到 `25` 的阶乘，`26` 往上将发生溢出。


## 代码块

**Chunks**



