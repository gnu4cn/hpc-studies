# Tk 小部件

关于小部件，有三点需要说明。首先是路径，the path。这一点咱们在前面已经解释过了。所有小部件的路径，都必须是唯一的，并在需要访问该小部件时，会用到。其次是选项，the options。每个部件都有部分选项，可以用来对其进行配置。这通常是在小部件声明时完成的，但也可以在声明后完成。最后便是命令，commands。每个小部件，都有一些命令，这些命令也可以用来配置他，或让他完成某些事情。

但在开始之前，咱们需要了解一下打包 `pack` 命令。这在前面已经解释过了，但现在要再解释一遍，这样咱们就不用按浏览器返回键了。`pack` 是一种几何管理器。另一种几何管理器是 `grid`，我（作者）更喜欢他 -- 咱们将在后面探讨。`pack` 要比 `grid` 简单得多。


`pack .hello` 这一行，告诉解释器，要打包名为 `.hello` 的小部件。


如果命令是 `pack .hello -in .frame`，那么 `.hello` 这个小部件，就将被打包到另一个名为 `.frame` 的小部件中。在没有 `-in` 选项的情况下，所指定的小部件，会放在主窗口中。


## `button`

这将生成一个按钮。其可以被配置为，在按下时执行一些代码。所执行的代码，通常是指一个函数，因此当按钮被按下时，函数就会运行。下面使用 HTML 展示了一个按钮。


<button>Push Me</button>


**部分选项**

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


**部分选项**

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


## `label`


这个小部件显示文本消息。


**示例**：

```tcl
proc push_button {} {
	.ent insert 0 {Hello }
}

label .lab -justify left -text {Enter name:}
entry .ent
button .but -text {Push Me} -command "push_button"

pack .lab .ent .but
```


## `frame`

框架是一种简单的部件。其主要用途，是作为复杂窗口布局的间隔或容器。边框的唯一特征，是其背景颜色和可选的三维边框，可使边框看起来凸起或凹陷。

**部分选项**


| 选项 | 描述 |
| :-- | :-- |
| `-relief STYLE` | 指定该 `frame` 部件所需的三维效果。可接受的值有 `raised`、`sunken`、`flat`、`ridge`、`solid` 和 `groove`。该值表示这个小部件内部相对于外部的显示效果；例如，`raised` 表示部件内部相对于外部，突出屏幕。 |

**示例**：


```tcl
proc push_button {} {
	.ent insert 0 {Hello }
}

frame .frm -relief groove
label .lab -justify left -text {Enter name:}
entry .ent
button .but -text {Push Me} -command "push_button"

pack .lab -in .frm
pack .ent -in .frm

pack .frm
pack .but
```


## `text`

文本小部件显示一或多行文本，并允许对文本进行编辑。与 [输入小部件](#entry) 类似，但尺寸更大。


**部分选项**

| 选项 | 描述 |
| :-- | :-- |
| `-xscrollcommand COMMAND` | 这是为了实现文本小部件和滚动条小部件之间的通信。还有一个 `-yscrollcommand` 与之类似。 |
| `-font FONTNAME` | 指定在 `text` 小部件内，绘制文本时使用的字体。 |
| `-width NUMBER` | 指定 `text` 小部件的宽度。 |
| `-height NUMBER` | 指定 `text` 小部件的高度，猜对了。 |


**一些命令**

| 语法 | 描述 | 示例 |
| :-- | :-- | :-- |
| `path get index1 ?index2 ...?` | 返回该文本输入框的某个字符范围。返回值将是文本中从索引为 `index1` 的字符开始，到索引为 `index2` 字符之前的所有字符（不会返回索引为 `index2` 的字符）。如果省略 `index2`，则返回 `index1` 处的单个字符。<br />请注意，文本的索引与输入 `entry` 部件的索引不同。文本输入框部件的索引格式为 `LINE_NO.CHARECTER_NO`。这意味着 `1.0` 表示第一行第一个字符。 | `set contents [.txt get 1.0 end]` |
| `path insert index DATA` | 在索引处的字符前，插入所有参数字符。如果索引指向文本输入框的末尾（最后一个换行符之后的字符），那么新文本将插入到最后一个换行符之前。 | `.txt insert end "Hello World"` |


**示例**


```tcl
proc push_button {} {
    set name [.ent get]
    .txt insert end "Hello, $name"
}

frame .frm -relief groove
label .lab -justify left -text {Enter name:}
entry .ent
button .but -text {Push Me} -command "push_button"
text .txt -width 20 -height 10

pack .lab -in .frm
pack .ent -in .frm

pack .frm
pack .but
pack .txt
```


## `scrollbar`

滚动条是一种显示出两个箭头的小部件，箭头位于滚动条的两端，滑块位于滚动条的中间部分。他提供了显示着某种文档（如正在编辑的文件或绘图）的相关视窗中，可见内容的信息。滑块的位置和大小，表示文档哪一部分，在关联窗口中可见。例如，如果竖直滚动条中的滑块，覆盖了两个箭头之间区域的顶部三分之一，就表示滚动条关联的窗口，显示了其文档顶部的三分之一。他可以与文本输入框等，其他部件一起使用。


**部分选项**


| 选项 | 说明 |
| :-- | :-- |
| `-orient DIRECTION` | 对于可按水平，或垂直方向布局的那些小部件（如滚动条），该选项指定了应使用的方向。`DIRECTION` 必须是 `horizontal` 或 `vertical`，或者是其中之一的缩写, an abbreviation of one of these。 |
| `-command COMMAND` | 在滚动条被移动时，这条命令会被执行。该选项的值几乎总是 `.t xview` 或 `.t yview`，由小部件部件的名称和 `xview`（当滚动条是在水平滚动时）或 `yview`（用于垂直滚动）组成。所有可滚动部件，都有着 `xview` 和 `yview` 命令，并会取与由滚动条所附加的，完全相同的额外参数。 |


**示例**


```tcl
proc push_button {} {
    set name [.ent get]
    .txt insert end "Hello, $name."
}

frame .frm -relief groove
label .lab -text "Enter name:"
entry .ent
button .but -text "Push Me" -command "push_button"

frame .textarea
text .txt -width 20 -height 10 \
    -yscrollcommand ".srl_y set" -xscrollcommand ".srl_x set"

scrollbar .srl_y -command ".txt yview" -orient v
scrollbar .srl_x -command ".txt xview" -orient h

pack .lab -in .frm
pack .ent -in .frm
pack .frm
pack .but

grid .txt -in .textarea -row 1 -column 1
grid .srl_y -in .textarea -row 1 -column 2 -sticky ns
grid .srl_x -in .textarea -row 2 -column 1 -sticky ew
pack .textarea
```

## `grid`


正如所看到的，咱们在这里用到了 `grid`。网格不是一个小部件。他是一个类似于 `pack` 的几何管理器，但更加先进。咱们来仔细看看这条命令 -- `grid .txt -in .textarea -row 1 -column 1`。

这一行将告诉解释器，将名为 `.txt` 的部件，放到名为 `.textarea` 的部件中（这是一个框架，还记得吗？）。他将被放在第一行第一列。下面的示意图可以帮助咱们理解。


<table>
<tr><td></td><td>第一列</td><td>第二列</td></tr>
<tr><td>第一行</td><td>`.txt` 小部件将在这里</td><td>`.srl_y` 小部件的地方</td></tr>
<tr><td>第二行</td><td>`.srl_x` 小部件的位置</td><td></td></tr>
</table>


**部分选项**

| 选项 | 说明 |
| :-- | :-- |
| `-sticky STYLE` | 该选项可用于在小部件的单元格内，定位（或拉伸）小部件。`STYLE` 是一个字符串，包含 `n`、`s`、`e` 或 `w` 中的零个或多个字符。每个字母指的是从属小部件，将 “附着，stick” 的一面（北、南、东或西）。如果同时指定了 `n` 和 `s`（或 `e` 和 `w`），从属小部件将被拉伸，以填满其空格的整个高度（或宽度）。 |
| `-in MASTER` | 小部件将被放置在这个 `MASTER` 小部件中。 |
| `-ipadx AMOUNT` | `AMOUNT` 指定在从属小部件两侧，各留出多少水平内部填充。这是在从属小部件边框内，所添加的空间。 |
| `-ipady AMOUNT` | `AMOUNT` 指定在从属小部件两侧，各留出多少垂直的内部填充。选项与 `-ipadx` 相同。 |
| `-padx AMOUNT` | 该值指定在从属小部件两侧，各留多少水平外部填充（以屏幕单位表示）。`AMOUNT` 可以是个包含两个值的列表，分别指定左右两侧的填充量。 |
| `-pady AMOUNT` | 指定从属小部件顶部和底部的垂直外部填充量（屏幕单位）。选项与 `-padx` 相同。 |
| `-row N` | 插入从属小部件，使其占据网格的第 `N` 行。行号以 `0` 开头。如没有提供该选项，则从属小部件将与此次调用 `grid` 命令时，所指定的前一从属小部件，安排在同一行，如果是第一个从属小部件，则会安排在第一个未被占用的行。 |
| `-column N` | 插入从属小部件，使其占据网格的第 `N` 列。选项与 `-row` 相同。 |
| `-rowspan N` | 插入从属小部件，使其占据网格中的 `N` 行。默认为一行。 |
| `-columnspan N` | 插入从属小部件，使其占据网格中的 `N` 列。 |


使用网格需要一点经验，但如果咱们懂 HTML，就会有很大帮助。网格的行和列，与 HTML 表格中的行和列一样，但代码却截然不同。


## `scale`
