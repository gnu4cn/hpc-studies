# 控制流

**The Control Flow**


## `if` 条件

*语法*：

```tcl
if { test1 } {
    body1
} elseif { test2 } {
    body2
} else {
    bodyn
}
```

如果不喜欢大括号，咱们也可以去掉他们。但这样一来，咱们就必须在一行中给出完整内容。我知道，当咱们看完这些语法之后，还在想这到底是怎么回事。别担心，一个例子就能让咱们明白。



```tcl
#The marriage status script...
#Change the status please
set marital_status "After"

label .thesis -text "Marriage is a three ring circus..."

if { $marital_status=="Before" } {
    set ring "Engagement"
} elseif { $marital_status=="During" } {
    set ring "Wedding"
} else {
    set ring "suffe -"
}

label .proof -text "$marital_status Marriage: $ring ring"

pack .thesis
pack .proof
```

运行此脚本，并将 `marital_status` 设为 `"Before"`、`"During"` 及 `"After"`，看看不同的结果。


### 运算符

**Operators**

咱们需要运算符，来进行（条件）检查。幸运的是，Tcl 中的运算符，与其他语言中的运算符相同。因此，只要对任何一种语言有一点经验，就能保证咱们对所有运算符了如指掌。


Tcl 有两种运算符。


*关系运算符，Relational Operators*：`<`、`<=`、`>`、`>=`、`==` 及 `!=`，他们会返回 `0`（`false`）或 `1`（`true`）。

| Tcl 中的运算符 | 意义 | 示例 |
| :-- | :-- | :-- |
| `==` | 等于 | `5 == 6` |
| `!=` | 不等于 | `5 != 6` |
| `<` | 小于 | `5 < 6` |
| `<=` | 小于等于 | `5 <= 6` |
| `>` | 大于 | `5 > 6` |
| `>=` | 大于等于 | `5 >= 6` |

*逻辑运算符，Logical Operators*：`&&`、`!` 及 `||` 运算符，与（`AND`）、非（`NOT`）及或（`OR`）运算符。


| 运算符 | 逻辑等价物 | 示例 |
| :-- | :-- | :-- |
| `! expression` | 非（`NOT`） | `!$a` |
| `expression1 && expression2` | 与（`AND`） | `$a > 6 && $a < 10` |
| <code>expression1 &#124;&#124; expression2</code> | 或（`OR`） | <code>$a != 6 &#124;&#124; $a != 5</code> |
