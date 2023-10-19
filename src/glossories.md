# 词汇表


## EGO, Enterprise Grid Orchestrator

企业网格编排器, [Manage LSF on EGO](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=configuration-manage-lsf-ego)

## 环境变量，Environment Variables

环境变量是计算机上，存储了某个值的动态对象。在基于 Unix 的操作系统（`bash`）上，咱们可以：

- 以 `export <variable-name>=<value>`，设置某个变量的值；

- 以 `echo $<variable-name>`，读取某个变量的值。

软件（或用户）可以引用环境变量，来获取或设置有关系统或环境的信息。请参阅下面的几个环境变量示例，了解他们的用法及作用。

**Unix 系统上常见的一些环境变量**

| 环境变量 | 内容 |
| :-- | :-- |
| `$USER` | 咱们的当前用户名 |
| `$PWD` | 咱们当前所在的目录 |
| `$HOSTNAME` | 咱们所在计算机的主机名，`hostname` |
| `$HOME` | 咱们的主目录 |
| `$PATH` | 执行命令时搜索的目录清单 |
