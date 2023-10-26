# Tk 小部件

关于小部件，有三点需要说明。首先是路径，the path。这一点咱们在前面已经解释过了。所有小部件的路径，都必须是唯一的，并在需要访问该小部件时，会用到。其次是选项，the options。每个部件都有一些选项，可以用来对其进行配置。这通常是在小部件声明时完成的，但也可以在声明后完成。最后便是命令，commands。每个小部件，都有一些命令，这些命令也可以用来配置他，或让他完成某些事情。

但在开始之前，咱们需要了解一下打包 `pack` 命令。这在前面已经解释过了，但现在要再解释一遍，这样咱们就不用按浏览器返回键了。`pack` 是一种几何管理器。另一种几何管理器是 `grid`，我（作者）更喜欢他 -- 咱们将在后面探讨。`pack` 要比 `grid` 简单得多。


`pack .hello` 这一行，告诉解释器，要打包名为 `.hello` 的小部件。


如果命令是 `pack .hello -in .frame`，那么 `.hello` 这个小部件，就将被打包到另一个名为 `.frame` 的小部件中。在没有 `-in` 选项的情况下，所指定的小部件，会放在主窗口中。


## `button`

这将生成一个按钮。其可以被配置为，在按下时执行一些代码。所执行的代码，通常是指一个函数，因此当按钮被按下时，函数就会运行。下面使用 HTML 展示了一个按钮。


<button>Push Me</button>


**一些选项**

| 选项 | 选项描述 |
| :-- | :-- |
| `-text "TEXT"` | `TEXT` 将是显示在该按钮上的文本。 |
| `-command "CODE"` | `CODE` 将是在该按钮被按下时，所执行的代码。 |


*示例*：


```tcl
proc push_button {} {
	... whatever ...
}

button .but -text "Push Me" -command "push_button"
pack .but
```

## `entry`

输入小部件，the entry，是一个显示单行文本字符串的部件，用户可以在其中输入和编辑文本。当输入焦点在条目上时，他就会显示一个插入光标，an insertion cursor，指示新字符将插入的位置。下面使用 HTML，给出了一个输入元素。


<input type="text" value="Text can be inputed here." />


**一些选项**

| 选项 | 描述 |
| :-- | :-- |
| `-width NUMBER` | 这个输入字段的宽度。其中的 `NUMBER` 应是整数。 |
| `-textvariable VARIABLE` | 变量 `VARIABLE` 的内容，将显示在该小部件中。在小部件中的文本被编辑时，变量也将自动被编辑。在给到 `VARIABLE` 时，前面应 **不带** `$` 符号。 |
| `-state STATE` | 这个输入字段的状态。可以是 `normal`、`disabled` 或 `readonly`。如果是 `readonly` 状态，则无法编辑文本。 |


**一些命令**

| 命令 | 描述 |
| :-- | :-- |
| `path get` | 输入字段内的文本，可以通过此命令提取。 | `set name [.ent get]` |
| `path delete FIRST ?LAST?` | 删除该输入部件的一或多个元素。`FIRST` 是要删除的第一个字符索引，`LAST` 是要删除的最后字符之后字符的索引。如果没有指定 `LAST`，则其默认为 `FIRST+1`，即只删除一个字符。此命令将返回空字符串。 | `.ent delete 0 end` |
| `path insert index STRING` | 将 `STRING` 中的字符，插入索引所表示字符之前。第一个字符的索引为 `0`。最后一个字符可以使用 `end`（结束）。 | `.ent insert end {Hello}` |

**示例**：


```tcl
set input {World}

proc push_button {} {
	.ent insert 0 {Hello, }
}

entry .ent -textvariable input
button .but -text "Push Me" -command "push_button"

pack .ent .but
```



