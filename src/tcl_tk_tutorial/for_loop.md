# 控制流循环

## `for` 循环

最常用的循环，是 `for` 循环。当咱们必须在很少或没有变化的情况下，执行一组给定指令时，这个循环非常有用。


*语法*：

`for init test next body`

我（作者）更喜欢下面这种语法：

```tcl
for { init } { test } { next } {
    body
}
```

现在，咱们要第一次编写脚本，来做一些有用的事情 -- 构造一个乘法表。想知道这有什么用吗？当你像我（作者）一样忘记数学时，就会发现他非常有用。


```tcl
# 乘法表...
set n 4 ;# 咱们要的是 4 的乘法表
set table ""

for { set i 1 } { $i <= 10 } { incr i } {
# 这将把 n 的所有数相乘，追加到名为
# table 的变量
	set table "$table $i x $n = [expr $i \* $n]\n"
}

label .mul -text [encoding convertto utf-8 "Multiplication table for $n\n\n$table"]
pack .mul
```

> **注意**：以下是完整的乘法表（需在 Linux 系统上运行，否则会出现乱码）：

```tcl
#!/usr/bin/env wish

# 乘法表...
set table ""

for { set i 1 } { $i < 10 } { incr i } {
# 这将把 n 的所有数相乘，追加到名为
# table 的变量
	for { set j 1 } { $j <= $i } { incr j } {
		set tmpExp  "$j x $i = [expr $j \* $i]"
		set table [ expr [string length $tmpExp] <= 9 ? { "$table$tmpExp\t\t" } : { "$table$tmpExp\t" } ]
	}
	set table "$table\n"
}

label .mul -justify left -text "乘法表\n\n$table"
pack .mul
```


## `foreach`

*语法*：

`foreach varName list body`

> **注意**：同 `for` 循环一样，更具可读性的写法为：

```tcl
foreach varName list {
    body
}
```

这是一种可以让编程变得更简单的循环。主要用于列表。例如......


```tcl
#Make the list
set list [list "Item 1" {Item 2} Last]

set text ""
foreach item $list {
	#Append the every item to $text
	set text "$text\n$item"
}

#Shows the result
label .lab -text "$text"
pack .lab
```


> **注意**：这里会显示出 4 个行，其中第一个是空行，因为 `list` 列表中第一个元素为 `list`，是个空列表。


通过下面这样一个普通的 `for` 循环，也能达到同样的效果。

```tcl
#Make the list
set list [list "Item 1" {Item 2} Last]

set text ""
for { set i 0 } { $i < [llength $list] } { incr i } {
	#Append the every item to $text
	set text "$text\n[lindex $list $i]"
}

label .lab -text "$text"
pack .lab
```
