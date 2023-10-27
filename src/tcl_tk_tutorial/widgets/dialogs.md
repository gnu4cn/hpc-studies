# 对话框

所谓对话框，可被叫做程序中脱离主窗口的一些元素。这是一个非常笼统的定义，存在很多问题。但就目前而言，这个定义是可行的。Tk 提供了许多种对话框。


## `tk_messageBox`

这个程序，this procudure, `proc`，会创建并显示出一个消息窗口，其中包含了应用程序所指定的消息、图标及一组按钮。消息窗口中的每个按钮，都有一个唯一的符号名称，a unique symbolic name（参见 `-type` 选项）。消息窗口弹出后，`tk_messageBox` 会等待用户，选择其中一个按钮。请点击下面的按钮，查看消息框的示例。


<input type="button" value="Message" onClick="alert('This is a message box')" />



**部分选项**

| 选项 | 说明 |
| :-- | :-- |
| `-default name` | `name` 给到该消息窗口，默认按钮的符号名称（`ok`、`cancel` 等）。有关符号名称的清单，请参阅 `-type`。如未指定这个选项，对话框中的第一个按钮，将作为默认按钮。 |
| `-icon iconImage` | 指定出要显示的图标。`IconImage` 必须是下列图标之一：`error`、`info`、`question` 或 `warning`。如未指定这个选项，则将显示 `info` 图标。 |
| `-message string` | 指定要在此消息框中显示的消息。 |
| `-title string` | 指定作为消息框标题，而要显示的字符串。默认值为空字符串。 |
| `-type predefinedType` | 安排下要显示的一组预定义按钮。`predefinedType` 可有以下值：<br />- `abortretryignore`，显示三个按钮，其符号名称分别为中止（`abort`）、重试（`retry`）和忽略（`ignore`）；<br />- `ok`，显示一个按钮，其符号名称为 `ok`；<br />- `okcancel`，显示两个按钮，符号名称分别为 `ok` 和 `cancel`；<br />- `retrycancel`，显示两个按钮，符号名称分别为重试（`retry`）和取消（`cancel`）；<br />- `yesno`，显示两个按钮，符号名称分别为 `yes` 和 `no`；<br />- `yesnocancel`，显示三个按钮，符号名称分别为 `yes`、`no` 和 `cancel`。 |
