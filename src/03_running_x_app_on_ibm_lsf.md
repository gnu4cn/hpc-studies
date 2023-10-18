# 在 IBM LSF 上运行 `X` 应用


## 无法以 LSF 管理员或根用户以外的任何用户身份运行 `lsrun` 或 `lsgrun`


**现象**：当普通用户运行 `lsrun` 或 `lsgrun` 在不同主机上交互运行任务时，会出现 “User permission denied” 的错误。

**原因**：在 `$LSF_TOP/conf/lsf.conf` 中设置 `LSF_DISABLE_LSRUN=y`。


**解决方案**：移除或注释掉 `lsf.conf` 中的 `LSF_DISABLE_LSRUN=y` 。
