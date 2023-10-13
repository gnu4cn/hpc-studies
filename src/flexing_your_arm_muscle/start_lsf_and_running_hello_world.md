# 启动 IBM LSF CE 并运行 HPC 版的 `Hello World`

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

{{#include ./start_lsf_and_running_hello_world.md:13:15}}

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


