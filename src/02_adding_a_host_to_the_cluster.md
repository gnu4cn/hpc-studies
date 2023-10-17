# 添加主机到集群

**Adding a host to your cluster**

原文：[Adding a host to your cluster](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=queues-adding-host-your-cluster)

使用 LSF 安装脚本 `lsfinstall`，将新主机与主机类型，添加到咱们的集群。


## 开始之前

请确保咱们有着要添加主机类型的 LSF 分发文件，the LSF distribution files。例如，要在集群中添加运行 `x86-64` 内核 `2.6` 和 `3.x` 的 Linux 系统，请获取文件 `lsf10.1.0_linux2.6-glibc2.3-x86_64.tar.Z`。

可通过 [IBM Passport Advantage](http://www.ibm.com/software/howtobuy/passportadvantage/pao_customers.htm)，下载到所有受支持的 LSF 版本的分发包。


## 关于本次任务

向集群添加主机的主要步骤如下：

1. 安装该主机类型的 LSF 二进制文件；

2. 将主机信息添加到 `lsf.cluster.cluster_name`，如 `lsf.cluster.demo-cluster` 文件；

3. 设置这台新的主机。
