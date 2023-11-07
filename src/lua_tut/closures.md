# 闭包

Lua 中的函数，是具有适当词法作用域的一些头等值，functions in Lua are first-class values with proper lexical scoping。

函数是 “头等值”，是什么意思？这意味着，在 Lua 中，函数是与数字和字符串等常规值，具有相同权利的值。程序可以将函数，存储在变量（包括全局变量与局部变量）和表中，将函数作为参数，传递给其他函数，以及将函数作为结果返回。


函数具有“词法作用域，lexical scoping”，是什么意思？这意味着函数可以访问其外层函数的变量，functions can access variables of their enclosing functions。(这也意味着，Lua 正确地包含了 [lambda/λ 演算，the lambda calculus](https://en.wikipedia.org/wiki/Lambda_calculus)。）



