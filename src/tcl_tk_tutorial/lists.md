# 清单/列表

Tcl 列表包含着一个元素序列，a sequence of elements，每个元素则可以是数字、字符串或其他列表。咱们来构造一个列表：


```tcl
set list_name "To Do List"

# Create an Empty list using the list command. Not very nessary
set to_do [list]

#Add items to our to do list
lappend to_do "Buy Groceries"
lappend to_do "Tame Nature"
lappend to_do "Split Atom"

# lappend to_do "Buy Groceries" "Tame Nature" "Split Atom" 250 true

#Display all things
label .desc -text "The $list_name\n$to_do"

label .one -text "First thing to do : [lindex $to_do 0]"; # Get first element
label .second -text "Second thing to do : [lindex $to_do 1]" ;#Get second element
label .third -text "Third thing to do : [lindex $to_do 2]" ;#and so on

pack .desc .one .second .third

#Insert a new Item in the second place
set to_do [linsert $to_do 1 "Capture Osama Bin Laden" "Learning Tcl/Tk"]
label .list -text "New List\n$to_do"

#Change an item
set to_do [lreplace $to_do 2 3 "Someone already did that" "New task I" "Making food"]
label .latest -text "Latest List\n$to_do"

label .total -text "Total number of jobs to do = [llength $to_do]"

pack .list .latest .total
```

此处用于列表的命令，及其说明：


| 命令 | 语法 | 描述 |
| :-- | :-- | :-- |
| `list` | `list ?value value value...?` | 该命令返回一个包含所有参数的列表，在没有指定参数时，返回一个空字符串。|
| `lappend` | `lappend listName ?value value value...?` | 此命令将 `listName` 所给到变量，视为一个列表，并将各个值参数作为独立元素，追加到该列表中，这些元素之间用空格隔开。如果 `listName` 不存在，则会创建包含那些值参数所给元素的一个列表。 |
| `lindex` | `lindex list ?index...?` | `lindex` 命令会取某个 Tcl 列表，并返回其第 `index` 个索引元素。请记住，列表从 `0` 开始，第一个元素便是其第 `0` 个。 |
| `linsert` | `linsert list index element ?element element...?` | 该命令将所有元素参数，插入第 `index` 个元素之前，从而从列表生成一个新的列表。 |
| `lreplace` | `lreplace list first last ?element element...?` | 通过以元素参数，替换列表的一个或更多元素，`lreplace` 会返回由此构成的一个新的列表。语法中的 `first` 和 `last`，分别指定出要替换元素范围的第一个和最后一个索引。 |
| `llength` | `llength list` | 将 `list` 视为列表，并返回一个十进制字符串，表示其中元素的个数。 |

> **注意**：
>
> 1. Tcl 列表中可以存储不同类型的数据。如上面示例中就存储了字符串、数字和布尔值；
>
> 2. `llength` 可传入字符串参数。如：

```tcl
#!/usr/bin/env tclsh
set str "The quick brown fox jumps over the lazy dog."

puts [llength $str]
```

> 将输出：`9`，表示这个字符串有 9 个单词。

还有更多与列表相关的命令，如 `lsort`、`lset`、`lrange`、`lsearch` 以及 `split`、`join` 等。有关这些命令的详细信息，请参阅 [手册](https://tcl.tk/man/tcl8.6.13/TclCmd/list.html)。


**`split`**


