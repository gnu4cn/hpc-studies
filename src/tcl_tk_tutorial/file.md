# 文件处理

与所有其他优秀语言一样，Tcl 也可以打开、读取及写入文件。和其他所有优秀的教程一样，本教程也会教大家如何做到这一点。首先让我们看看如何打开文件。


## `open`

*语法*：

```tcl
open fileName ?access? ?permission?
```

`fileName` 是文件名。`access` 参数（如果存在），指定出访问文件的方式。他可以有以下任意值：

- `r`，打开文件仅供读取；文件必须已经存在。在未指定访问权限 `access` 参数时，这是默认值；

- `r+`，打开文件供读写；文件必须已经存在；

- `w`，打开文件，仅供写入。如果存在该文件名的文件，则会删除该文件的所有内容。如果不存在，则创建一个新文件；

- `w+`，打开文件进行读写。如果存在该文件名的文件，则删除该文件的所有内容。如果不存在，则创建一个新文件；

- `a`，打开文件，仅供写入。如果文件不存在，则创建一个新的空文件。会将初始访问位置，the initial access position，设置到文件末尾；

- `a+`，打开文件供读写。如果文件不存在，则创建一个新的空文件。会将初始访问位置，设置到文件末尾。


咱们来看一个示例。


```tcl
#Open the file called "jokes.txt" for writing
open "jokes.txt" w
```

现在我们知道如何打开文件了。没什么用，不是吗？为了让这个函数发挥作用，我们需要写入文件。


## `puts`

*语法*：

```tcl
puts ?-nonewline? ?channelId? string
```

只有在写入文件的字符串末尾，不需要换行时，才使用 `-nonewline` 选项。`channelID` 参数，表示必须要写入输出流的 ID（如果不明白是什么意思，不用担心，稍后会明白）。`string` 便是要写入文件的字符串。让我们看看示例。


```tcl
#Open the file called "jokes.txt" for writing
set out [open "jokes.txt" w]
puts $out "Computers make very fast, very accurate mistakes."
```
