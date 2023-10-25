# `while` 循环

只要满足条件，就重复执行脚本。在给到的语法中，`test` 是条件，`body` 是脚本。只要 `test` 为真，脚本就会重复执行。


*语法*：

```tcl
while test body
```

而我（作者）更喜欢下面这种......

```tcl
while { test } {
    body
}
```

与我们在 `for` 循环中，用到的程序相同。现在介绍 -- `while` 循环：


```tcl
#Multiplication table...
set n 4 ;# We want the multiplication table of 4

set table ""
set i 1
while { $i <= 10 } {
# This will append all multiples of all numbers for the number n
#		into a variable called table
	set table "$table $i x $n = [expr $i \* $n]\n"
	incr i
}

label .mul -text "Multiplication table for $n\n\n$table"
pack .mul
```

> **注意**：使用 Tcl 的 `while` 循环，打印完整乘法表的代码如下：

```tcl
#!/usr/bin/env wish

# 乘法表...
set table ""
set i 1

while { $i < 10 } {
# 这将把 n 的所有数相乘，追加到名为
# table 的变量
	set j 1
	while { $j <= $i } {
		set tmpExp  "$j x $i = [expr $j \* $i]"
		set table [ expr [string length $tmpExp] <= 9 ? { "$table$tmpExp\t\t" } : { "$table$tmpExp\t" } ]
		incr j
	}

	incr i
	set table "$table\n"
}

label .mul -justify left -text "乘法表\n\n$table"
pack .mul
```

![Tcl `while` 循环打印的完整乘法表](../images/multiplication_table.png)
