# 布局小部件

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

## `panedwindow`

窗格视窗，panedwindow，的作用，与框架 `frame` 小部件类似，但有一个明显例外。窗格的边框，可以拖动和展开。该部件包含了任意数量的窗格，根据 `-orient` 选项值，水平或垂直排列起来。每个窗格包含一个视窗小部件，同时每对窗格之间，用可移动的窗框隔开。拖动窗格可以移动边框。这将调整窗框两侧部件的大小。


**部分选项**


| 选项 | 说明 |
| :-- | :-- |
| `-orient DIRECTION` | 此选项指定应使用的方向。方向必须是 **水平，`horizontal`** 或 **垂直，`vertical`**，或者是其中之一的缩写（ `h` 或 `v`）。 |
| `-opaqueresize BOOLEAN` | 指定窗框移动时，是否应调整窗格大小（`true`），或者是否应推迟调整窗格大小，直到窗框被放下（`false`）。 |


**示例**


```tcl
panedwindow .pnd -orient v -opaqueresize 1\
    -sashwidth 10 -sashrelief groove

listbox .lst

.lst insert end {Item 1}
.lst insert end {Item 2}
.lst insert end {Item 3}
.lst insert end {Item 4}
.lst insert end {Item 5}

text .txt

.txt insert end {To Hack With It

     To Compute...
     Or Not To Compute...
     That Is The Question...
     Whether 'Tis Nobler In The Memory Bank..
     To Suffer The Slings And Circuits Of Outrageous Functions...
     ...Or To Take Up Arms Against A Sea Of..Transistors,
     Or Rather Transponders...
     Transcondu--
     Trans...
     Er...           Oh, To Hack With It.
}

.pnd add .lst
.pnd add .txt

pack .pnd -fill both -expand 1
```

