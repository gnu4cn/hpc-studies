# IBM LSF 社区版的安装


## 下载及提取文件

首先，我们将从以下 [URL](https://epwt-www.mybluemix.net/software/support/trial/cst/programwebsite.wss?siteId=680&h=&tabId=) 下载适用于 `armv8` 的 IBM Spectrum LSF CE 软件包，及快速入门指南。请注意，咱们需要注册一个 IBMid（如果还没有的话）才能访问软件包。展开压缩包后，会看到两个压缩包：一个是包含二进制文件的 `armv8` 包，另一个是安装包。接下来，解压缩 `lsfinstall` 压缩包。其中包含 IBM Spectrum LSF CE 的安装程序。


```sh
[root@flotta2 tmp]# ls
lsfsce10.2.0.11-armv8.tar.gz
[root@flotta2 tmp]# tar zxvf ./lsfsce10.2.0.11-armv8.tar.gz
lsfsce10.2.0.11-armv8/
lsfsce10.2.0.11-armv8/lsf/
lsfsce10.2.0.11-armv8/lsf/lsf10.1_lnx312-lib217-armv8.tar.Z
lsfsce10.2.0.11-armv8/lsf/lsf10.1_no_jre_lsfinstall.tar.Z
[root@flotta2 tmp]# cd lsfsce10.2.0.11-armv8/lsf/
[root@flotta2 lsf]# ls
lsf10.1_lnx312-lib217-armv8.tar.Z  lsf10.1_no_jre_lsfinstall.tar.Z
[root@flotta2 lsf]# tar zxvf ./lsf10.1_no_jre_lsfinstall.tar.Z
lsf10.1_lsfinstall/
lsf10.1_lsfinstall/instlib/
lsf10.1_lsfinstall/instlib/lsflib.sh
lsf10.1_lsfinstall/instlib/lsferror.tbl
lsf10.1_lsfinstall/instlib/lsfprechkfuncs.sh
....
....
```

## 配置安装程序

解压缩 `lsfinstall` 压缩包后，咱们会发现安装配置文件 `install.config`。该文件控制着安装方面的设置，包括安装位置、LSF 管理员账户、集群名称、主节点（调度程序守护进程运行所在）以及二进制源码包位置等。下面的 `diff` 显示了相关设置。请注意，用户账户 `lsfadmin` 已在系统中创建（并且必须存在于 LSF 集群中的所有服务器上）：

- 安装位置（`LSF_TOP`）：`/opt/ibm/lsfce`；

- LSF 管理员账号（`LSF_ADMINS`）：`lsfadmin`；

- LSF 集群名字（`LSF_CLUSTER_NAME`）：`xfoss.com`；

- LSF 二进制源码包位置（`LSF_TARDIR`）：`/home/lenny.peng/lsfsce10.2.0.12-x86_64/lsf` （ 步骤 1 中 `lsf10.1_lnx312-lib217-armv8.tar.Z` 的位置）。


```sh
[root@flotta2 lsf10.1_lsfinstall]# diff -u1 ./install.config_org ./install.config
--- ./install.config_org        2021-04-08 12:08:05.677381501 -0400
+++ ./install.config    2021-04-08 12:22:54.098764027 -0400
@@ -42,3 +42,3 @@
 # -----------------
-# LSF_TOP="/usr/share/lsf"
+LSF_TOP="/opt/ibm/lsfsce"
 # -----------------
@@ -52,3 +52,3 @@
 # -----------------
-# LSF_ADMINS="lsfadmin user1 user2"
+LSF_ADMINS="lsfadmin"
 # -----------------
@@ -69,3 +69,3 @@
 # -----------------
-# LSF_CLUSTER_NAME="cluster1"
+LSF_CLUSTER_NAME="xfoss.com"
 # -----------------
@@ -84,3 +84,3 @@
 # -----------------
-# LSF_MASTER_LIST="hostm hosta hostc"
+LSF_MASTER_LIST="sta-neo-fpga"
 # -----------------
@@ -94,3 +94,3 @@
 # -----------------
-# LSF_TARDIR="/usr/share/lsf_distrib/"
+LSF_TARDIR="/home/lenny.peng/lsfsce10.2.0.12-x86_64/lsf"
 # -----------------
```


## 运行安装程序


准备好安装配置文件后，我们就可以调用 IBM Spectrum LSF CE 安装程序了（为简洁起见，下面的安装输出已被截断）。


```console
root@sta-fpga-d:/home/lenny.peng/lsfsce10.2.0.12-x86_64/lsf/lsf10.1_lsfinstall# useradd lsfamdin
root@sta-fpga-d:/home/lenny.peng/lsfsce10.2.0.12-x86_64/lsf/lsf10.1_lsfinstall# ./lsfinstall -f ./install.config
Creating /opt/ibm/lsf/conf/resource_connector/ego ...
Creating /opt/ibm/lsf/conf/resource_connector/openstack ...
Creating /opt/ibm/lsf/conf/resource_connector/aws ...
Creating /opt/ibm/lsf/conf/resource_connector/azure ...
Creating /opt/ibm/lsf/conf/resource_connector/cyclecloud ...
Creating /opt/ibm/lsf/conf/resource_connector/google ...
Creating /opt/ibm/lsf/conf/resource_connector/openshift ...
Creating /opt/ibm/lsf/conf/resource_connector/ibmcloudgen2 ...
... Done creating resource connector configuration directories and files.
... Finished resource connector configuration.

... Inventory tag file ibm.com_IBM_Spectrum_LSF-10.1.0.swidtag is installed.
... LSF entitlement file is installed.
Creating lsf_getting_started.html ...
... Done creating lsf_getting_started.html

Creating lsf_quick_admin.html ...
... Done creating lsf_quick_admin.html

lsfinstall is done.
```

> **注意**：LSF 安装程序，需要 JDK/JRE 环境，且已知在 JDK17 下，会报出如下错误：

```console
root@sta-fpga-d:/home/lenny.peng/lsfsce10.2.0.12-x86_64/lsf/lsf10.1_lsfinstall# ./lsfinstall -f ./install.config

Logging installation sequence in /home/lenny.peng/lsfsce10.2.0.12-x86_64/lsf/lsf10.1_lsfinstall/Install.log

Missing ./lap/license/LA_id
Missing ./lap/license/LI_id
Error: Missing one or more required license files.
Exited with: 11
   Installation exiting ...
```

> 在 [IBM 社区论坛 "Missing lap license while lsfinstall"](https://community.ibm.com/community/user/businessanalytics/discussion/missing-lap-license-while-lsfinstall)，提到了其根本原因为 JDK17 的问题，需要降级 JDK。
