# 你好世界

**Hello World**

让我们像其他教程一样，从 `Hello World` 程序开始。创建一个名为 `Hello.tcl` 的文件，并输入以下内容。


```tcl
#!/usr/bin/env wish
# 构造出一个 "Hello World" 的标签

label .hello -text "Hello World"
pack .hello
```

第一行 -- `#!/usr/bin/env wish` 在 windows 中是不需要的。在 Linux 中，他告知的是脚本语言处理器的名称。不明白这是什么意思？不用担心。把他放在文件顶端就可以了。但如果咱们打算制作一个良好可移植的脚本，就不要使用这一行。请使用下面这一行。


```tcl
#!/bin/sh
#The next line executes wish - wherever it is \
exec wish "$0" "$@"
```

为什么？原因请参见 [Unix 中的 Tcl/Tk]()。

{{#include ./appendix.md:20}}
