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

我们还可以日期表，调用 `os.time`，将表表示法，转换为数字。`year`、`month`、`day` 三个字段，是必填字段。在没有提供 `hour`、`min` 和 `sec` 字段时，会默认为中午 (12:00:00)。其他字段（包括 `wday` 和 `yday`），都将被忽略。


```lua
> os.time({year=2023, month=11, day=10, hour=12, min=45, sec=35})
1699591535
> os.time({year=1970, month=1, day=1, hour=0})
-28800
> os.time({year=1970, month=1, day=1, hour=0, sec=1})
-28799
> os.time({year=1970, month=1, day=1})
14400
```

请注意，其中 `-28800` 是以秒为单位的负八小时（时区），而 `14400` 则是 `-28800`，加上以秒为单位的 12 小时。

> **注意**：原文 `os.time({year=1970, month=1, day=1, hour=0})` 的输出为 `10800`。根据上面的输出，纪元应是 1970 年 1 月 1 日 08：00 UTC。


## 函数 `os.date`

尽管其名字不同，函数 `os.date` 却是 `os.time` 的某种逆向函数：他把表示日期和时间的数字，转换为某种更高级别的表示形式，可以是日期表，也可以是字符串。他的第一个参数，是描述咱们想要表示形式的 *格式字符串，format string*。第二个参数，是数字的日期-时间；在没有提供时，则默认为当前的日期和时间。


为生成一个日期表，我们就要使用格式字符串 `"*t"`。例如，调用 `os.date("*t", 906000490)`，会返回下面的表：

```lua
> date_table = os.date("*t", 906000490)
> for k, v in pairs(date_table) do
>> print(k, v) end
min     48
year    1998
sec     10
yday    260
hour    10
wday    5
month   9
isdst   false
day     17
```


一般来说，对于任何有效时间 `t`，我们都有 `os.time(os.date("*t", t)) == t`。


除 `isdst` 之外，结果字段是以下范围内的整数：

| 字段 | 范围 |
| :-- | :-- |
| `year` | 一个完整的年份（`2023`） |
| `month` | 1-12 |
| `day` | 1-31 |
| `hour` | 0-23 |
| `min` | 0-59 |
| `sec` | 0-60 |
| `wday` | 1-7 |
| `yday` | 1-366 |

（秒可以达到 60，以允许闰秒。）
