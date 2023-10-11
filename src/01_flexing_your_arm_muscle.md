# Flexing your Arm Muscle

原文：[Flexing your Arm Muscle](https://medium.com/ibm-data-ai/flexing-your-arm-muscle-for-hpc-ce00c29f000d)


> “Flexing your Arm Muscle”，此处原文巧妙的使用了双关修辞，字面意思是 “秀出你的二头肌”，而在计算技术语境下，实为展示 Arm 电脑计算能力的意思。

从英格兰剑桥起步时的岌岌无名，Arm 现已成为处理器内核领域的全球领导者，而处理器内核正是我们数字世界的核心。但是，Arm 不再只是移动设备的代名词。如今，Arm 处理器已成为 [树莓派（Raspberry Pi）](https://www.raspberrypi.org/) 等单板计算机，以及苹果公司最新设备的动力，也是云计算（ [AWS Graviton](https://aws.amazon.com/ec2/graviton/) ）和目前世界上速度最快超级计算机 [Fugaku](https://en.wikipedia.org/wiki/Fugaku_(supercomputer)) 的动力。Arm 一直在大展拳脚，撼动了整个行业。在基于 Arm 的系统被广泛采用之前，我(原作者：Gábor Samu)就一直在使用它们。20 世纪 90 年代，Arm 系统在加拿大十分罕见，我有幸在加拿大奥利维蒂公司（Olivetti Canada），接触到了使用 Arm 技术的 Acorn Archimedes 计算机。当时我并不知道，Arm 在今天会已经如此普及。


> 富岳，Fugaku, 截至到 2022 年 5 月，已被 Frontier, 前沿超越，已不再是世界最快超级计算机（2023 年 10 月）。

在高性能计算（HPC）领域，由 Arm 驱动的系统已不再只是一个愿景。他们正在高性能计算领域掀起巨大波澜，解决包括 [COVID-19 研究](https://www.japantimes.co.jp/news/2021/03/09/national/science-health/fugaku-supercomputer-covid19-research/) 在内的复杂问题，软件生态系统也获得了显著的发展势头。


工作负载调度程序是任何高性能计算集群的重要软件组件，an essential software component of any high performance computing cluster is a workload scheduler。工作负载调度程序类似于交通警察，有助于确保集群中受调度作业，在正确的时间获得正确的资源。从表面上看，这似乎是一项简单的任务，但当集群包含了数千台服务器，用户在业务优先级的背景下争夺资源时，工作负载调度程序对于充分利用这些宝贵的计算资源，至关重要。如今有许多的工作负载调度程序，从开源到闭源专有程序都有。[IBM Spectrum LSF](https://www.ibm.com/us-en/products/hpc-workload-management) 是一套支持 x86-64、IBM Power (LE) 以及 Arm 处理器上 Linux 平台的工作负载调度程序。Spectrum LSF 在 HPC 工作负载调度方面有着悠久的历史，并提供了社区版，[IBM Spectrum LSF CE](https://epwt-www.mybluemix.net/software/support/trial/cst/programwebsite.wss?siteId=680&h=&tabId=) 可免费下载（需要注册），最多可在 10 台服务器（双插槽，dual-socket）上使用，最多可支持 1000 个活动作业。

下面，咱们将介绍在基于四核 Arm Cortex A-72 的单一系统（本例中为运行 openSUSE Tumbleweed (`aarch64`) 的 SolidRun [MACCHIATObin](https://www.solid-run.com/arm-servers-networking-platforms/macchiatobin/) ）上，安装 IBM Spectrum LSF Community Edition 的步骤。我们还将介绍运行几个作业示例。在之前的文章 (How do I love my HPC, let me count the ways)[https://medium.com/ibm-data-ai/how-do-i-love-my-hpc-let-me-count-the-ways-b218b886c3a1] 中，谈到了工作负载调度程序在高性能计算集群中的重要性。为什么我需要在单台服务器上使用 IBM Spectrum LSF CE？如果咱们使用功能强大的台式服务器，来运行建模和仿真等处理器和内存密集型工作负载，就需要一种方法来确保这些工作负载不会相互干扰。IBM Spectrum LSF CE 将确保在合理的时间安排工作，并能根据定义好的策略处理工作故障。


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


```sh
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


## 开始启动

安装过程通常很快。安装完成后，咱们现在就可以启动 IBM Spectrum LSF Community Edition，让其准备好接受并管理作业。在此之前，让我们先了解一些 LSF 的概念及术语，这将有助于理解下面的内容。


LSF 设计用于在内部及云上的主机（或虚拟机）集群上运行。LSF 集群必须至少包含一台管理主机，咱们可将其视为集群的协调器，the orchestrator for the cluster。他会运行调度程序，根据从环境中所有服务器收集到的负载信息，决定将工作放在何处。LSF 管理主机，management host，会运行以下守护进程：


- 管理的主机负载信息管理程序（`LIM`, Load Information Manager）；

- 资源执行服务器（`RES`, Resource Execution Server）；

- 服务器批处理守护进程（`SBATCHD`, Server Batch Daemon）；

- 管理批处理守护进程（`MBATCHD`, Management Batch Daemon）。


LSF 群集还可以配置一个备份的管理节点，即 *候选管理主机，management candidate host*。在 *管理主机，management host* 不论因何种原因不可用时，该主机便可以接管下来。从 *管理主机* 到 *候选管理主机* 的故障切换，对终端用户来说是无缝的。


而 LSF 服务器，便是集群中的 "工蜂"，LSF servers are the worker bees in the cluster -- LSF 会将作业发送到这些系统进行处理。请注意，在需要时，LSF 管理主机也可以运行批处理作业。LSF 服务器主机运行着以下守护进程：

- 服务器的主机负载信息管理程序（`LIM`, Load Information Manager）

{{#include ./01_flexing_your_arm_muscle.md:133:135}}

这个 LSF 集群中只有一台服务器。因此，他既是 LSF 管理节点，也是 LSF 服务器，可以运行作业。下面咱们将使用一些命令，来启动 LSF 以及提交和管理作业。下面将简要介绍这些命令：


- `lsadmin` - 控制 LIM 与 RES 守护进程的启动；

- `badmin` - 控制 SBATCHD 与 LSF 批处理系统；

- `lsid` - 显示有关该 LSF 集群的基本信息；

- `lsload` - 显示 LSF 主机的负载信息；

- `bhosts` - 显示 LSF 主机的批处理系统状态；

- `bsub` - 提交一个作业到 LSF；

- `bjobs` - 显示 LSF 作业的信息。


而随着 IBM Spectrum LSF CE 环境的建立。这将配置 `PATH` 及其他所需的环境变量。LSF 守护进程使用 `lsadmin` 和 `badmin` 命令启动。


```sh
root@sta-f4-d:/opt/ibm/lsfce/conf# pwd
/opt/ibm/lsfce/conf
root@sta-f4-d:/opt/ibm/lsfce/conf# . ./profile.lsf
root@sta-f4-d:/opt/ibm/lsfce/conf# lsadmin limstartup
Starting up LIM on <sta-f4-d.xfoss.com> ...... done
root@sta-f4-d:/opt/ibm/lsfce/conf# lsadmin resstartup
Starting up RES on <sta-f4-d.xfoss.com> ...... done
root@sta-f4-d:/opt/ibm/lsfce/conf# badmin hstartup
Starting up server batch daemon on <sta-f4-d.xfoss.com> ...... done
```

以非根用户身份，a non-rout user，请如上所示，为 IBM Spectrum LSF CE 创建环境，并检查群集状态。在下文中，咱们会用到用户命令 `lsid`、`lsload` 及 `bhosts`，确认 LSF 集群已经启动并运行，可以接受作业。有关这些命令的更多信息，请参阅 [IBM 文档](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0)。


```sh
lenny.peng@sta-f4-d:/opt/ibm/lsfce/conf$ pwd
/opt/ibm/lsfce/conf
lenny.peng@sta-f4-d:/opt/ibm/lsfce/conf$ . ./profile.lsf
lenny.peng@sta-f4-d:/opt/ibm/lsfce/conf$ lsid
IBM Spectrum LSF Community Edition 10.1.0.12, Jun 10 2021
Copyright IBM Corp. 1992, 2016. All rights reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.

My cluster name is hpc.xfoss.com
My master name is sta-f4-d.xfoss.com
lenny.peng@sta-f4-d:/opt/ibm/lsfce/conf$ lsload
HOST_NAME       status  r15s   r1m  r15m   ut    pg  ls    it   tmp   swp   mem
sta-f4-d.sensco     ok   0.2   0.7   0.7   1%   0.0   2     0  452G  3.8G 13.3G
lenny.peng@sta-f4-d:/opt/ibm/lsfce/conf$ bhosts
HOST_NAME          STATUS       JL/U    MAX  NJOBS    RUN  SSUSP  USUSP    RSV
sta-f4-d.xfoss. ok              -     14      0      0      0      0      0
```

## 提交作业

在高性能计算调度程序的世界里，睡眠作业就类似于运行一个 "hello world" 程序。因此，在第一次测试中，咱们以集群非根用户的身份，提交了一个简短的睡眠作业。咱们会提交一个 10 秒钟的睡眠作业，并将作业输出写入 `output.<JOBID>` 文件。作业完成后，我们将显示输出文件的内容。


```sh
lenny.peng@sta-f4-d:~$ bsub -o output.%J /bin/sleep 10
Job <1> is submitted to default queue <normal>.
lenny.peng@sta-f4-d:~$ bjobs
JOBID   USER    STAT  QUEUE      FROM_HOST   EXEC_HOST   JOB_NAME   SUBMIT_TIME
1       lenny.p RUN   normal     sta-f4-d.se sta-f4-d.se */sleep 10 Oct 11 14:15
lenny.peng@sta-f4-d:~$ bjobs
JOBID   USER    STAT  QUEUE      FROM_HOST   EXEC_HOST   JOB_NAME   SUBMIT_TIME
1       lenny.p RUN   normal     sta-f4-d.se sta-f4-d.se */sleep 10 Oct 11 14:15
lenny.peng@sta-f4-d:~$ bjobs
No unfinished job found
lenny.peng@sta-f4-d:~$ more output.1
Sender: LSF System <lsfadmin@sta-f4-d.xfoss.com>
Subject: Job 1: </bin/sleep 10> in cluster <hpc.xfoss.com> Done

Job </bin/sleep 10> was submitted from host <sta-f4-d.xfoss.com> by user <lenny.peng> in cluster <hpc.xfoss.com> at Wed Oct 11 14:15:
52 2023
Job was executed on host(s) <sta-f4-d.xfoss.com>, in queue <normal>, as user <lenny.peng> in cluster <hpc.xfoss.com> at Wed Oct 11 14
:15:52 2023
</home/lenny.peng> was used as the home directory.
</home/lenny.peng> was used as the working directory.
Started at Wed Oct 11 14:15:52 2023
Terminated at Wed Oct 11 14:16:03 2023
Results reported at Wed Oct 11 14:16:03 2023

Your job looked like:

------------------------------------------------------------
# LSBATCH: User input
/bin/sleep 10
------------------------------------------------------------

Successfully completed.

Resource usage summary:

    CPU time :                                   0.05 sec.
    Max Memory :                                 13 MB
    Average Memory :                             13.00 MB
    Total Requested Memory :                     -
    Delta Memory :                               -
    Max Swap :                                   -
    Max Processes :                              3
    Max Threads :                                4
    Run time :                                   16 sec.
    Turnaround time :                            11 sec.

The output (if any) follows:


```


## 另一个作业提交示例

我知道。提交睡眠作业，足以让作为读者的你昏昏欲睡。那么，让咱们提交一些更有趣的东西吧 -- 无处不在的高性能 Linpack（HPL）基准测试。因为这里运行的系统并不先进，所以这里的目的是展示 LSF 对并行工作负载的支持，而不是其 Linpack 性能。


尽管在 openSUSE Tumbleweed 上，作为一个软件包提供了 OpenMPI，但其并未被编译支持 LSF。因此，咱们将首先编译出支持 LSF 的 OpenMPI。我们将使用最新的 OpenMPI v4.1.6，并将其编译和安装到 `/opt/openmpi-4.1.6`。

```sh
lenny.peng@sta-f4-d:~$ mkdir MPI
lenny.peng@sta-f4-d:~$ cd MPI
lenny.peng@sta-f4-d:~/MPI$ wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.6.tar.gz
lenny.peng@sta-f4-d:~/MPI$ tar zxvf openmpi-4.1.6.tar.gz
lenny.peng@sta-f4-d:~/MPI$ cd openmpi-4.1.6
lenny.peng@sta-f4-d:~/MPI/openmpi-4.1.6$ ./configure --prefix=/opt/openmpi-4.1.6 --enable-orterun-prefix-by-default --disable-getpwuid --with-lsf
...
...
...
...
Open MPI configuration:
-----------------------
Version: 4.1.6
Build MPI C bindings: yes
Build MPI C++ bindings (deprecated): no
Build MPI Fortran bindings: no
MPI Build Java bindings (experimental): no
Build Open SHMEM support: false (no spml)
Debug build: no
Platform file: (none)

Miscellaneous
-----------------------
CUDA support: no
HWLOC support: internal
Libevent support: internal
Open UCC: no
PMIx support: Internal

Transports
-----------------------
Cisco usNIC: no
Cray uGNI (Gemini/Aries): no
Intel Omnipath (PSM2): no
Intel TrueScale (PSM): no
Mellanox MXM: no
Open UCX: no
OpenFabrics OFI Libfabric: no
OpenFabrics Verbs: no
Portals4: no
Shared memory/copy in+copy out: yes
Shared memory/Linux CMA: yes
Shared memory/Linux KNEM: no
Shared memory/XPMEM: no
TCP: yes

Resource Managers
-----------------------
Cray Alps: no
Grid Engine: no
LSF: yes
Moab: no
Slurm: yes
ssh/rsh: yes
Torque: no

OMPIO File Systems
-----------------------
DDN Infinite Memory Engine: no
Generic Unix FS: yes
IBM Spectrum Scale/GPFS: no
Lustre: no
PVFS2/OrangeFS: no

lenny.peng@sta-f4-d:~/MPI/openmpi-4.1.6$ time make -j8
...
...
...
...

real    1m29.744s
user    4m14.699s
sys     0m33.777s

lenny.peng@sta-f4-d:~/MPI/openmpi-4.1.6$ sudo make install
```


OpenMPI 准备就绪后，我们就可以开始编译 HPL 了。HPL 是针对 OpenMPI v4.1.6（上文中所编译的）并使用操作系统所提供的 OpenBLAS 库编译的。HPL 将编译并安装到 `/opt/HPL/hpl-2.3`。


```sh
lenny.peng@sta-f4-d:/opt$ mkdir HPL
lenny.peng@sta-f4-d:/opt$ cd HPL
lenny.peng@sta-f4-d:/opt/HPL$ wget http://netlib.org/benchmark/hpl/hpl-2.3.tar.gz
lenny.peng@sta-f4-d:/opt/HPL$ tar zxvf hpl-2.3.tar.gz
lenny.peng@sta-f4-d:/opt/HPL$ cd hpl-2.3/
lenny.peng@sta-f4-d:/opt/HPL/hpl-2.3$ cd setup/
lenny.peng@sta-f4-d:/opt/HPL/hpl-2.3/setup$ source make_generic
lenny.peng@sta-f4-d:/opt/HPL/hpl-2.3/setup$ mv Make.UNKNOWN Make.Linux_x86_64
```

修改其中的下列两处：

- `ARCH         = UNKNOWN`  -> `ARCH            = Linux_x86_64`

- `LAlib        = -lblas`   -> `LAlib           = -lopenblas`

> **注意**：需要在主机上安装好 `openblas` 软件包。

准备好 `Makefile` 后，就要构建 `xhpl` 二进制文件了。请注意，我们在此设置了 `PATH` 和 `LD_LIBRARY_PATH`，以引用 OpenMPI v4.1.6 的安装文件。


```sh
lenny.peng@sta-f4-d:/opt/HPL/hpl-2.3/setup$ export PATH=/opt/openmpi-4.1.6/bin:$PATH
lenny.peng@sta-f4-d:/opt/HPL/hpl-2.3/setup$ export LD_LIBRARY_PATH=/opt/openmpi-4.1.1/lib:$LD_LIBRARY_PATH
lenny.peng@sta-f4-d:/opt/HPL/hpl-2.3/setup$ cd ..
lenny.peng@sta-f4-d:/opt/HPL/hpl-2.3$ ln -s ./setup/Make.Linux_aarch64 ./Make.Linux_aarch64
lenny.peng@sta-f4-d:/opt/HPL/hpl-2.3$ make arch=Linux_x86_64
```

> **注意**：需要执行 `export OMPI_FC=mpif77`，否则会报出 `wrapper...` 错误。

咱们的 `xhpl` 二进制文件已经就绪，位于 `/opt/HPL/hpl-3.2/bin/Linux_aarch64`。在将 `xhpl` 提交 LSF 执行之前，我们会根据系统（内存大小、核心数量等）调整 `HPL.dat` 参数文件。最后，提交给 LSF 的 `xhpl` 请求使用 4 个内核。


```sh
```
