# 在 IBM LSF 上运行 `X` 应用


## 无法以 LSF 管理员或根用户以外的任何用户身份运行 `lsrun` 或 `lsgrun`


**现象**：当普通用户运行 `lsrun` 或 `lsgrun` 在不同主机上交互运行任务时，会出现 “User permission denied” 的错误。

**原因**：在 `$LSF_TOP/conf/lsf.conf` 中设置 `LSF_DISABLE_LSRUN=y`。


**解决方案**：移除或注释掉 `lsf.conf` 中的 `LSF_DISABLE_LSRUN=y` 。


## `Can't open display: sta-fpga-d.xfoss.com:50.0` 问题

**现象**：


```console
lenny.peng@sta-fpga-d:~$ bsub -Is xterm
Job <47> is submitted to default queue <interactive>.
<<Waiting for dispatch ...>>
<<Starting on sta-fpga-d.xfoss.com>>
xterm: Xt error: Can't open display: sta-fpga-d.xfoss.com:50.0
```

**解决方法**：使用 `-XF` 提交作业，比如在 `sta-fpga-d` 主机上执行：

```bash
bsub —XF -m sta-fpga-b.xfoss.com firefox
```

将能在主机 `sta-fpga-b` 上运行 `firefox`，并在 `sta-fpga-d` 主机上，显示出 `firefox` 的窗口。反之亦然。
