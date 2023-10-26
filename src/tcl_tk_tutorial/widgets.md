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

构造出一个可由用户调整的滑块，用于输入变量。


**部分选项**

| 选项 | 说明 |
| :-- | :-- |
| `-from NUMBER` | 开始数字。 |
| `-to NUMBER` | 结束数字。 |
| `-tickinterval NUMBER` | 确定在滑块下方或左侧，所显示数字刻度线之间的间距。 |
| `-varable NAME` | 指定了链接到刻度盘的全局变量名称。每当变量值发生变化时，刻度盘就会更新以反映该值。无论何时对刻度盘进行交互式操作，该变量都将被修改，以反映刻度盘的新值。 |


**部分命令**

| 语法 | 说明 | 示例 |
| `path get` | 获取刻度盘的当前值。 | `set age [.scl get]` |
| `path set value` | 给刻度盘一个新值。 | `.scl set 20` |


**示例**


```tcl
#This function will be executed when the button is pushed
proc push_button {} {
	global age
	set name [.ent get]
	.txt insert end "Hello, $name.\nYou are $age years old."
}

#Global Variables
set age 10

#GUI building
frame .frm -relief groove
label .lab -text "Enter name:"
entry .ent -width 48

button .but -text "Push Me" -command "push_button"

#Age
scale .scl -label "Age :" -orient h -digit 1 -from 10 -to 50 \
	-variable age -tickinterval 5 -length 640

#Text Area
frame .textarea
text .txt -yscrollcommand ".srl_y set" -xscrollcommand ".srl_x set" \
	-width 48 -height 10
scrollbar .srl_y -command ".txt yview" -orient v
scrollbar .srl_x -command ".txt xview" -orient h

#Geometry Management
pack .lab -in .frm
pack .ent -in .frm
pack .frm

pack .scl
pack .but

grid .txt   -in .textarea -row 1 -column 1
grid .srl_y -in .textarea -row 1 -column 2 -sticky ns
grid .srl_x -in .textarea -row 2 -column 1 -sticky ew
pack .textarea
```

现在，我们的小例子越来越像一个程序。因为他变得越来越大，难以理解，咱们已经添加了注释。现在我们添加了一个滑块，可以输入年龄。咱们可能也注意到了，这里增加了一行 `global age`。这不是地球的年龄，也不是每个人类年龄的总和。他表示变量 `age` 应从全局作用域，移至那个 `push_button` 函数的作用域。


## `radiobutton`

所谓单选按钮，是一种必须从多个选项中，任选一个的输入方式。在已选择了一个按钮，但又点击了另一个按钮时，则上一个选择的按钮将失去状态，被点击的按钮将被选中。下面是一个图形示例（HTML 形式）。

<form name="frm">Choices
    <input name="no" id="one" type="radio" value="" CHECKED> 1 |
    <input name="no" id="two" type="radio" value=""> 2 |
    <input name="no" id="three" type="radio" value=""> 3
</form>


> *注*：他们之所以被称为无线电按钮，是因为其外观和操作方式，与老式收音机上的按钮类似，如下图所示。

![老式收音机](../images/old-radio.jpg)

-- 摘自 [`<input type="radio">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/radio)


**部分选项**

| 选项 | 说明 |
| :-- | :-- |
| `-command COMMAND` | 指定与该按钮相关联的一条 Tcl 命令。当鼠标按钮 1 在这个按钮视窗上释放时，该命令通常会被调用到。 |
| `-variable VARIABLE` | 指定出设置用以表示此按钮是否选中的全局变量名字。 |
| `-value VALUE` | 指定在该按钮被选中时，要存储到按钮相关变量中的值。 |

**部分命令**


| 语法 | 说明 | 示例 |
| :-- | :-- | :-- |
| `path deselect` | 取消选择复选按钮，并将相关变量设置为其 `off` 值。 | `.rdb_m deselect` |
| `path select` | 选择复选按钮，并将相关变量设置为其 `on` 值。 | `.rdb_m select` |


**示例**

```tcl
#This function will be exected when the button is pushed
proc push_button {} {
    global age gender
    set name [.ent get]
    .txt insert end "$name\($gender\) is $age years old.\n"
}

#Global Variables
set age 10
set gender "Male"

#GUI building
frame .frm_name
label .lab -text "Name:"
entry .ent -width 48

#Age
scale .scl -label "Age :" -orient h -digit 1 -from 10 -to 50 \
    -variable age -tickinterval 5 -length 640

#Gender
frame .gender
label .lbl_gender -text "Sex "
radiobutton .gender.rdb_m -text "Male"   -variable gender -value "Male"
radiobutton .gender.rdb_f -text "Female" -variable gender -value "Female"
.gender.rdb_m select

button .but -text "Push Me" -command "push_button"

#Text Area
frame .textarea
text .txt -yscrollcommand ".srl_y set" -xscrollcommand ".srl_x set" \
    -width 48 -height 10
scrollbar .srl_y -command ".txt yview" -orient v
scrollbar .srl_x -command ".txt xview" -orient h

#Geometry Management
grid .frm_name -in . -row 1 -column 1 -columnspan 2
grid .lab -in .frm_name -row 1 -column 1
grid .ent -in .frm_name -row 1 -column 2

grid .scl -in . -row 2 -column 1 -columnspan 2

grid .gender -in . -row 3 -column 2
grid .lbl_gender -in .gender -row 1 -column 1
grid .gender.rdb_m -in .gender -row 1 -column 2
grid .gender.rdb_f -in .gender -row 1 -column 3

grid .but -in . -row 4 -column 1 -columnspan 2

grid .txt   -in .textarea -row 1 -column 1
grid .srl_y -in .textarea -row 1 -column 2 -sticky ns
grid .srl_x -in .textarea -row 2 -column 1 -sticky ew
grid .textarea -in . -row 5 -column 1 -columnspan 2
```

这次程序的变化更大 -- 几何管理器现在是完全网格化的。不再有 `pack` 的实例。当布局变得更加复杂时，咱们会发现这是必要的。希望咱们能在如此艰难的时刻，与我同行。



## `checkbutton`

勾选按钮，是一个输入项，有两个选项 -- 关闭或打开 -- 必须任选其一。可以通过点击来改变状态。示例如下。


<input type="checkbox" name="" value="check me"> check box

**部分选项**

| 选项 | 说明 |
| :-- | :-- |
| `-offvalue VALUE` | 指定在按钮被取消选择时，存储到按钮相关变量中的值。默认值为 `0`。 |
| `-onvalue VALUE` | 指定在每次按钮被选择时，要存储到按钮相关变量中的值。默认为 `1`。 |
| `-comman COMMAND` | 指定与该按钮相关联的一条 Tcl 命令。当鼠标按钮 1 于按钮窗口上释放时，该命令通常会被调用。 |
| `-variable VARIABLE` | 指定设置用于表示该按钮是否被选中的全局变量名字。 |


**部分命令**


| 语法 | 说明 | 示例 |
| `path deselect` | 取消选择该勾选按钮，并将相关变量设置为 `off` 值。 | `.chk deselect` |
| `path select` | 选择该勾选按钮，并将相关变量设置为其 `on` 值。 | `.chk select` |
| `path toggle` | 切换该勾选按钮的选择状态，重新显示按钮，并修改其相关变量以反映新的状态。 | `.chk toggle` |


**示例**

```tcl
#This function will be executed when the button is pushed
proc push_button {} {
    global age occupied gender
    set name [.ent get]
    .txt insert end "$name\($gender\) is $age years old and is "

    if { $occupied == 1 } {
        .txt insert end {occupied.}
    } else {
        .txt insert end {unemployed.}
    }

    .txt insert end "\n"
}

#Global Variables
set age 10
set occupied 1
set gender {Male}

#GUI building
frame .frm_name
label .lab -text {Name:}
entry .ent -width 48

#Age
scale .scl -label {Age :} -orient h -digit 1 -from 10 -to 50 \
    -variable age -tickinterval 10 -length 640
checkbutton .chk -text {Occupied} -variable occupied

#Gender
frame .gender
label .lbl_gender -text {Sex }
radiobutton .gender.rdb_m -text {Male}   -variable gender -value {Male}
radiobutton .gender.rdb_f -text {Female} -variable gender -value {Female}
.gender.rdb_m select

button .but -text {Push Me} -command "push_button"

#Text Area
frame .textarea
text .txt -yscrollcommand ".srl_y set" -xscrollcommand ".srl_x set" \
    -width 48 -height 10
scrollbar .srl_y -command ".txt yview" -orient v
scrollbar .srl_x -command ".txt xview" -orient h

#Geometry Management
grid .frm_name -in . -row 1 -column 1 -columnspan 2
grid .lab -in .frm_name -row 1 -column 1
grid .ent -in .frm_name -row 1 -column 2

grid .scl -in . -row 2 -column 1
grid .chk -in . -row 2 -column 2

grid .gender -in . -row 3 -column 2
grid .lbl_gender -in .gender -row 1 -column 1
grid .gender.rdb_m -in .gender -row 1 -column 2
grid .gender.rdb_f -in .gender -row 1 -column 3

grid .but -in . -row 4 -column 1 -columnspan 2

grid .txt   -in .textarea -row 1 -column 1
grid .srl_y -in .textarea -row 1 -column 2 -sticky ns
grid .srl_x -in .textarea -row 2 -column 1 -sticky ew
grid .textarea -in . -row 5 -column 1 -columnspan 2
```


## `listbox`

列表框是一种显示字符串列表的小部件，每行一个字符串。首次创建时，新的列表框没有任何元素。可以使用下面讲到的小部件命令，添加或删除元素。


**部分选项**


| 选项 | 描述 |
| :-- | :-- |
| `-listvariable VARIABLE` | 指定变量名称。`VARIABLE` 的值是要该小部件中显示的列表；如果 `VARIABLE` 的值发生变化，该小部件将自动更新，以反映新值。 |
| `-selectmode MODE` | 指定操作选项的几种样式之一。`MODE` 可以是任意的，但默认的绑定，the default bindings，希望其为 `single`、`browse`、`multiple` 或 `extended`；默认值是 `browse`。 |


**部分命令**

| 语法 | 说明 | 示例 |
| :-- | :-- | :-- |
| `path curselection` | 返回一个列表，其中包含了列表框中所有当前选中元素的数字索引。如果列表框中没有选中元素，则返回空字符串。 | `set sel [.lst curselection]` |
| `path delete first ?last?` | 删除列表框中的一或多个元素。`first`（第一个）和 `last`（最后一个）属于索引，指定了要删除范围内的第一和最后一个元素。如果没有指定 `last`，则默认为 `first`，即删除一个元素。 | `.lst delete 5` |
| `path get first ?last?` | 如果省略 `last`，则返回 `first` 指向的列表框元素内容；如果 `first` 指向的元素不存在，则返回空字符串。如果指定了 `last`，命令将返回一个列表，其元素是 `first` 和 `last` 之间的所有列表框元素，包括首尾元素。 | `.lst get 5 end` |
| `path index index` | 返回与 `index` 对应的整数索引值。如果索引为 `end`，则返回值为列表框中，元素的个数（而不是最后一个元素的索引）。 | `.lst index 5` |
| `path insert index ?element element ...?` | 在列表中插入零或多个新元素，位于正好 `index` 所指定元素之前。如果 `index` 指定为 `end`，则新元素会被添加到列表的末尾。此命令返回空字符串。 | `.lst insert end {Me}` |
| `path size` | 返回一个十进制字符串，表示列表框中元素的总数。 | `set count [.lst size]` |
| `path xview` | 该命令用于查询及更改该小部件视窗中，信息的水平位置。另一个类似的命令是 `yview`。 | `.lst xview` |


**示例**


```tcl
#This function will be exected when the button is pushed
proc push_button {} {
    global age occupied gender
    set name [.ent get]
    .txt insert end "$name\($gender\) is $age years old and is "

    if { $occupied == 1 } { ;#See whether he is employed
        set job_id [.lst curselection] ;#Get the No. of selected jobs
        if { $job_id=={} } { ;#If there is no job
            set job {a Non worker.}
        } else {
            set job [.lst get $job_id] ;#Get the name of the job
            .txt insert end "a $job."
        }
    } else {
        .txt insert end {unemployed.}
    }

    .txt insert end "\n"
}

#Jobs will be activated only if occupation is enabled
proc activate_jobs {} {
    global occupied
    if { $occupied == 1 } {
        .lst configure -state normal
    } else {
        .lst configure -state disable
    }
}

#Global Variables
set age 10
set occupied 1
set gender {Male}

#GUI building
frame .frm_name
label .lab -text {Name:}
entry .ent -width 48

#Age
scale .scl -label {Age :} -orient v -digit 1 -from 10 -to 50 \
    -variable age -tickinterval 5 -length 640

#Jobs
frame .frm_job

checkbutton .chk -text {Occupied} -variable occupied -command "activate_jobs"
.chk deselect

listbox .lst -selectmode single
#Adding jobs
.lst insert end {Student} {Teacher} {Clerk} {Business Man} \
    {Military Personal} {Computer Expert} {Others}
.lst configure -state disable ;#Disable jobs

#Gender
frame .gender
label .lbl_gender -text {Sex }
radiobutton .gender.rdb_m -text {Male}   -variable gender -value {Male}
radiobutton .gender.rdb_f -text {Female} -variable gender -value {Female}
.gender.rdb_m select

button .but -text {Push Me} -command "push_button"

#Text Area
frame .textarea
text .txt -yscrollcommand ".srl_y set" -xscrollcommand ".srl_x set" \
    -width 40 -height 10
scrollbar .srl_y -command ".txt yview" -orient v
scrollbar .srl_x -command ".txt xview" -orient h

#Geometry Management
grid .frm_name -in . -row 1 -column 1 -columnspan 2
grid .lab -in .frm_name -row 1 -column 1
grid .ent -in .frm_name -row 1 -column 2

grid .scl -in . -row 2 -column 1

grid .frm_job -in . -row 2 -column 2
grid .chk -in .frm_job -row 1 -column 1 -sticky w
grid .lst -in .frm_job -row 2 -column 1

grid .gender -in . -row 3 -column 1 -columnspan 2
grid .lbl_gender -in .gender -row 1 -column 1
grid .gender.rdb_m -in .gender -row 1 -column 2
grid .gender.rdb_f -in .gender -row 1 -column 3

grid .but -in . -row 4 -column 1 -columnspan 2

grid .txt   -in .textarea -row 1 -column 1
grid .srl_y -in .textarea -row 1 -column 2 -sticky ns
grid .srl_x -in .textarea -row 2 -column 1 -sticky ew
grid .textarea -in . -row 5 -column 1 -columnspan 2
```

哇！我们的“小”例子，现在成了一个大程序（而毫无意义）。从现在开始，我要停止“示例”了。

这很复杂，不是吗？咱们为什么不运行一下脚本，看看我们做了一个多么漂亮的脚本。复制上述脚本，并将其粘贴到一个名为 `info.tcl` 的文件中，然后双击该文件。瞧！咱们是 TCL/TK 程序员了。


有必要解释一下。在 `Occupied` 激活状态处于关闭时，工作这个列表框，将处于停用状态。而在 `Occupied` 勾选框被勾选时，这个列表框就将被激活。按下 `Push Me` 按钮后，将调用 `push_button` 函数，收集所有输入字段的详细信息，并将汇总写入那个 `.txt` 字段。

注意到有些注释以 `#` 开头，而有些则以 `;#` 开头吗？在新行中开始注释时，使用 `#`，而若把注释放在行尾，则要使用 `;#`。`;` 字符表示命令已结束，否则编译器会认为，注释是程序的一部分。这是 Tcl 程序员最常犯的错误之一。


## `menubutton`

菜单按钮，是一个显示文本字符串、位图或图像的部件，并与某个菜单小部件相关联。在一般使用中，左键单击菜单按钮，会使相关菜单显示在该菜单按钮的下方。


**部分选项**

| 选项 | 说明 |
| :-- | :-- |
| `-direction DIRECTION` | 指定其关联菜单，要弹出的位置。`above` 会尝试将菜单，弹出到菜单按钮上方；`below` 则会尝试将菜单，弹出到菜单按钮下方；`left` 会尝试将菜单，弹出到菜单按钮左侧；`right` 会尝试将菜单，弹出到菜单按钮右侧；`flush` 会将菜单，直接弹出到菜单按钮上方。 |
| `-menu NAME` | 指定与该菜单按钮关联的菜单路径名，the path name of the menu associated with this menubutton。这个菜单必须是该菜单按钮的子菜单。 |


## `menu`


菜单是一种用于显示，按一列或多列排列的单行条目集合的小部件。有几种不同类型的条目，每种条目都有不同属性。不同类型的条目，可以组合在一个菜单中。菜单条目与输入 `entry` 部件不同。事实上，菜单条目甚至并非独特部件，menu entries are not even distinct widgets；整个菜单就是一个小部件。


**部分选项**

| 选项 | 说明 |
| :-- | :-- |
| `-tearoff BOOLEAN` | 此选项必须有一个恰当的布尔值，指定菜单是否应在顶部，包含一个撕离条目，a tear-off entry。如果是，该条目就将作为菜单的第 `0` 个条目存在，而其他条目将从第 `1` 条目开始编号。 默认的菜单绑定，会在调用这个撕离条目时，将菜单展开。 |
| `-title STRING` | 在展开该菜单时，这个字符串将用于所创建出的视窗标题。如果标题为空，则那个视窗，将使用菜单按钮的标题，或调用该菜单的级联项的文本。 |
| `-type OPTION` | 该选项可以是 `menubar`、`tearoff` 或 `normal` 之一，并在菜单被创建时得以设置。如果此选项被修改，那么配置数据库返回的字符串也会改变，但这不会影响菜单小部件的行为。 |


**部分命令**


| 语法 | 说明 | 示例 |
| :-- | :-- | :-- |
| `path add type ?option value option value ...?` | 在菜单底部，添加一个新条目。新条目的类型，由 `type` 指定，必须是 `cascade`、`checkbutton`、`command`、`radiobutton` 或 `separator` 中的一种，或者是上述几种之一的唯一缩写。如果有附加参数，则指定以下任一选项：<br />
- `-accelerator VALUE` 指定在该菜单项右侧，要显示的字符串。通常是描述一个加速按键序列，输入该序列便可调用与菜单项相同的功能。该选项不适用于分隔符，或展开条目。<br />
- `-columnbreak VALUE` 当该选项为 `0` 时，菜单项会出现在上一个菜单条目下方。而当该选项为 `1` 时，该菜单项则会显示在菜单中，新列的顶部。<br />
- `-label VALUE` 指定在菜单条目中，作为标识标签显示的字符串。此选项不适用于分隔符或展开条目。<br />
- `-compound VALUE` 指定该菜单条目，是否要同时显示图像及文本，在同时显示时，指定图像相对于文本的位置。该选项的有效值为 `botton`、`center`、`left`、`none`、`right` 和 `top`。<br />
- `-image VALUE` 指定菜单中要显示的图片，而不是文本字符串或位图。所要显示的图片，必须是早先调用 `image create` 命令已创建好的。该选项会覆盖 `-label` 与 `-bitmap` 选项，但可以重置为空字符串，以便显示文本或位图的标签。该选项不适用于分隔符或展开条目。<br />
- `-underline VALUE` 指定要在菜单条目中，加上下划线字符的整数索引。该选项用于键盘快捷键。`0` 代表条目中所显示文本的第一个字符，`1` 代表下一个字符，依此类推。 |
| `path clone newPathName` | 构造出一个名为 `newPathName` 的当前菜单克隆。该克隆菜单，本身就是一个菜单，但对克隆菜单的任何更改，都会传播到原始菜单，反之亦然。 |
| `path delete index1 ?index2?` | 删除 `index1` 和 `index2`（含）之间的所有菜单条目。如果 `index2` 被省略，则默认为 `index1`。删除展开菜单条目的尝试，将被忽略（相反，咱们应修改 `tearOff` 选项，来删除展开条目）。 |


**示例**


```tcl
proc menu_clicked { no opt } {
    tk_messageBox -message \
        "You have clicked $opt.\nThis function is not implanted yet."
}

#Declare that there is a menu
menu .mbar
. config -menu .mbar

#The Main Buttons
.mbar add cascade -label {File} -underline 0 \
    -menu [menu .mbar.file -tearoff 0]

.mbar add cascade -label {Others} \
    -underline 0 -menu [menu .mbar.oth -tearoff 1]

.mbar add cascade -label {Help} -underline 0 \
    -menu [menu .mbar.help -tearoff 0]

## File Menu ##
set m .mbar.file
$m add command -label {New} -underline 0 \
    -command { .txt delete 1.0 end } ;# A new item called New is added.
$m add checkbutton -label {Open} -underline 0 -command { menu_clicked 1 {Open} }
$m add command -label {Save} -underline 0 -command { menu_clicked 1 {Save} }
$m add separator
$m add command -label {Exit} -underline 1 -command exit

## Others Menu ##
set m .mbar.oth
$m add cascade -label {Insert} -underline 0 -menu [menu $m.mnu -title {Insert}]
$m.mnu add command -label {Name} \
    -command { .txt insert end "Name : Binny V A\n"}
$m.mnu add command -label {Website} -command { \
    .txt insert end "Website: http://www.bin-co.com/\n"}
$m.mnu add command -label {Email} \
    -command { .txt insert end "E-Mail : binnyva@hotmail.com\n"}
$m add command -label {Insert All} -underline 7 \
    -command {
        .txt insert end {
            Name : Binny V A
            Website : http://www.bin-co.com/
            E-Mail : binnyva@hotmail.com
        }
    }

## Help ##
set m .mbar.help
$m add command -label {About} -command {
    .txt delete 1.0 end
    .txt insert end {
        About
        ----------
        This script created to make a menu for a tcl/tk tutorial.
        Made by Binny V A
        Website : http://www.bin-co.com/
        E-Mail : binnyva@hotmail.com
    }
}

#Making a text area
text .txt -width 50
pack .txt
```

将主按钮创建为级联菜单，并将这些菜单，创建为他们的从属菜单。更多信息请参阅手册。


## `tk_optionMenu`

构造出一个按钮，其在被点击后，会显示一个包含可用选项的列表。当用户需要在多个选项中，做出一个选择时，非常有用。下面是 HTML 格式的选项菜单。需要注意的是，Tcl/Tk 的选项菜单外观，与此截然不同。

<form name="selecter" action="">
    <select name="select1">
        <option value="none">Select from menu</option>
        <option value="none">--------------------</option>
        <option value="http://www.bin-co.com/">Main Site</option>
        <option value="http://www.google.com">Google</option>
        <option value="../index.php">Tcl Page in my site</option>
    </select>
    <input type="button" value="Go" onclick="javascript:void(0)" />
</form>


*语法*

```tcl
tk_optionMenu path varName value ?value value ...?
```

**示例**......

```tcl
set opt {Two}

tk_optionMenu .omn opt {One} {Two} {Three} {Four} {Five} {etc.}
pack .omn
```
