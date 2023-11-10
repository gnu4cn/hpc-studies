# 日期与时间

Lua 的标准库，提供了少量用于操作日期和时间的函数。和往常一样，他提供的只是标准 C 库中可用的功能。然而，尽管他看似简单，我们却可以利用这些基本支持，构造相当多的功能。

Lua 使用了两种日期和时间的表示法。第一种是通过通常是整数的单个数字。尽管 ISO C 没有要求，但在大多数系统上，该数字是从称为 *纪元，epoch*）的某个固定日期以来的秒数。特别是，在 POSIX 和 Windows 系统中，纪元均为 1970 年 1 月 1 日 0:00 UTC。

Lua 用于日期和时间的第二种表示法是表。此类 *日期表，date tables*，具有以下的重要字段：`year`、`month`、`day`、`hour`、`min`、`sec`、`wday`、`yday` 和 `isdst`。除 `isdst` 外的所有字段，都有着整数值。前六个字段的含义很明显。 `wday` 字段是一周中的哪一天（一为星期日）； `yday` 字段是一年中的第几天（一为一月一日）。`isdst` 字段是个布尔值，若夏令时有效则为 `true`。例如，1998 年 9 月 16 日 23:48:10（星期三）对应了下面这个表：

```lua
{year = 1998, month = 9, day = 16, yday = 259, wday = 4,
hour = 23, min = 48, sec = 10, isdst = false}
```

日期表不会编码时区。由程序根据时区，来正确解释他们。


## 函数 `os.time`

在不带参数调用 `os.time` 时，他会返回编码为数字的当前日期和时间：

```lua
> os.time()         --> 1439653520
```

该日期对应着 2015 年 8 月 15 日 12:45:20。<sup>注 1</sup>在 POSIX 系统中，我们可以使用一些基本算术计算，来分解这个数字：

```lua
local date = 1439653520
local day2year = 365.242                -- 一年中的天数
local sec2hour = 60 * 60                -- 一小时的秒数
local sec2day = sec2hour * 24           -- 一天中的秒数
local sec2year = sec2day * day2year     -- 一年中的秒数

-- 年份
print(date // sec2year + 1970)        --> 2015.0

-- 小时（按 UTC）
print(date % sec2day // sec2hour)     --> 15

-- 分钟
print(date % sec2hour // 60)          --> 45

-- 秒
print(date % 60)                      --> 20
```

> **注 1**：除非另有说明，我（作者）的日期，都是来自于在里约热内卢运行的一台 POSIX 系统。
