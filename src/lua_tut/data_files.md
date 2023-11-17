# 数据文件与序列化

在处理数据文件时，写入数据通常要比回读数据，容易得多。在写入文件时，我们可以完全掌控，正在发生的事情。另一方面，当我们读取文件时，我们并不知道，会得到什么。除了某个正确文件，可能包含的各种数据外，健壮的程序，还应该优雅地处理坏文件。因此，编写出健壮输入例程，总是困难重重。在本章中，我们将了解如何使用 Lua，消除从程序中读取数据的所有代码，只需将数据以适当的格式写入即可。更具体地说，我们会将数据编写成 Lua 程序的形式，当运行这些程序时，就会重建数据。<sup>译注 1</sup>

> **译注 1**：此处原文为：In this chapter, we will see how we can use Lua to eliminate all code for reading data from our programs, simply by writing the data in an appropriate format. More specifically, we write data as Lua programs that, when run, rebuild the data.


