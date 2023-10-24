# 清单

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
set to_do [linsert $to_do 1 "Capture Osama Bin Laden"]
label .list -text "New List\n$to_do"

#Change an item
set to_do [lreplace $to_do 3 3 "Someone already did that"]
label .latest -text "Latest List\n$to_do"

label .total -text "Total number of jobs to do = [llength $to_do]"

pack .list .latest .total
```

此处用于列表的命令，及其说明：


| 命令 | 语法 | 描述 |
| :-- | :-- | :-- |
| `list` | `list ?value value value...?` | 该命令返回一个包含所有参数的列表，在没有指定参数时，返回一个空字符串。|
| `lappend` | `lappend listName ?value value value...?` | 此命令将 `listName` 所给到变量，视为一个列表，并将各个值参数作为独立元素，追加到该列表中，这些元素之间用空格隔开。如果 `listName` 不存在，则会创建包含那些值参数所给元素的一个列表。 |
