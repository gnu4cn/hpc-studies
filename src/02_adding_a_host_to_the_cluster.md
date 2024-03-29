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

## 流程

**Procedure**

1. 安装新主机类型的二进制文件。


    使用 `lsfinstall` 命令，向集群添加新的主机类型。如果咱们已经有了要添加主机类型的分发文件，则可以跳过这些步骤。

    a. 以 `root` 身份登录任何可以访问 LSF 安装脚本目录的主机；

    b. 切换到安装脚本目录；

    ```sh
    cd /opt/ibm/lsfce/10.1/install
    ```


    c. 编辑 `install.config` 文件，为新主机类型指定所需的选项；

    请参阅 [配置安装程序](../flexing_your_arm_muscle/lsf_install.md#配置安装程序)，了解更多有关这个 `install.config` 文件，以及 `lsfinstall` 命令的信息。


    ```conf
    LSF_TOP="/opt/ibm/lsfce"
    LSF_ADMINS="lsfadmin"
    LSF_CLUSTER_NAME="xfoss.com"
    LSF_MASTER_LIST="sta-fpga-d"
    LSF_TARDIR="/home/lenny.peng/lsfsce10.2.0.12-x86_64/lsf"
    ENABLE_DYNAMIC_HOSTS="Y"
    ```


    d. 运行 `sudo ./lsfinstall -f ./install.config` 命令；

    e. 请按照由 `lsfinstall` 脚本，所生成的 `/opt/ibm/lsfce/10.1/lsf_quick_admin.html` 文件中，主机设置的步骤，设置新的主机。


2. 将主机信息，添加到 `/opt/ibm/lsfce/conf/lsf.cluster.cluster_name` 文件。

    a. 登入作为主 LSF 管理器，the primary LSF administrator，的 LSF 管理主机；

    b. 编辑 `LSF_CONFDIR/lsf.cluster.cluster_name` 文件，并在 `Host` 小节出，添加新主机的主机信息；
        - 添加主机名；
        - 添加型号或类型；
            如果咱们在模型及类型列中，输入 `!` 关键字，那么主机上运行的 `lim` 会自动检测主机模型。
            咱们可能打算现在使用该主机类型的默认值，等以后有了更多经验或更多信息后，再进行更改。
        + 在服务器列中指定 LSF 服务器或客户端：
            - `1`（一），表示 LSF 服务器主机；
            - `0`（零），表示仅限 LSF 客户端的主机。

    ```conf
    Begin   Host
    HOSTNAME  model    type        server  RESOURCES    #Keywords
    sta-fpga-d   !   !   1   (mg)
    sta-fpga-b   !   !   1   (mg)
    End     Host
    ```

    c. 保存对 `LSF_CONFDIR/lsf.cluster.cluster_name` 的修改；

    d. 重新配置 `lim`，以启用集群中的这台新主机；

    ```console
    % lsadmin reconfig
    Checking configuration files ...
    No errors found.
    Do you really want to restart LIMs on all hosts? [y/n] y
    Restart LIM on <hosta> ...... done
    Restart LIM on <hostc> ...... done
    Restart LIM on <hostd> ...... done
    ```

    `lsadmin reconfig` 命令，会进行配置错误检查。如果没有发现无法恢复的错误，系统会要求咱们加以确认，是否要在所有主机上重启 `lim`，然后重新配置 `lim`。如果发现无法恢复的错误，则重新配置会退出。

    > **注意**：需要先以 `root` 用户，启动管理主机。
    >
    ```console
    # lsadmin limstartup
    # lsadmin resstartup
    # badmin hstartup
    ```
    > 而运行 `lsadmin reconfig` 命令，需要以 `lsfadmin` 用户身份运行，否则会报错错误：

    ```console
    root@sta-fpga-d:/opt/ibm/lsfce# source conf/profile.lsf
    root@sta-fpga-d:/opt/ibm/lsfce# lsadmin reconfig

    Checking configuration files ...

    No errors found.

    Restart only the master candidate hosts? [y/n] y
    Restart LIM on <sta-fpga-d.xfoss.com> ...... ls_limcontrol: Operation permission denied by LIM
    ```

    > 而导致添加服务器主机失败。


    e. 重新配置 `mbatchd`;

    ```console
    % badmin reconfig
    Checking configuration files ...
    No errors found.
    Do you want to reconfigure? [y/n] y
    Reconfiguration initiated
    ```

    `badmin reconfig` 命令，会进行配置错误检查。如果没有发现无法恢复的错误，系统会要求咱们对重新配置进行确认。如果发现无法恢复的错误，则重新配置会退出。

    > 与 `lsadmin reconfig` 一样，`badmin reconfig` 也应以 `lsfadmin` 用户身份运行。


3. （可选的）使用 `hostsetup` 命令设置新主机。

    a. 以 `root` 用户，登录到可以访问 LSF 安装脚本目录的任何主机；

    b. 切换到安装脚本目录；

    ```console
    # cd /opt/ibm/lsfce/install
    ```

    c. 运行 `hostsetup` 命令来设置新主机；

    ```console
    # ./hostsetup --top="/opt/ibm/lsfce" --boot="y"
    ```

    d. 在新主机上启动 LSF。

    请运行以下命令：

    ```console
    # bctrld start lim
    # bctrld start res
    # bctrld start sbd
    ```

    e. 运行 `bhosts` 与 `lshosts` 命令，验证咱们的变更。

    如果有任何主机类型，或主机型号为 `UNKNOWN` 或 `DEFAULT`，请参阅在 [IBM Spectrum LSF Cluster Management and Operations](https://www.ibm.com/docs/en/SSWRJV_10.1.0/lsf_welcome/lsf_kc_cluster_ops.html) 中，[Working with hosts](https://www.ibm.com/docs/en/SSWRJV_10.1.0/lsf_admin/chap_hosts_working_with.html) 以解决问题。

## 结果

- 使用动态主机配置将主机添加到群集，而无需手动更改 LSF 配置。有关动态添加主机的更多信息，请参阅 [IBM Spectrum LSF 群集管理和操作](https://www.ibm.com/docs/en/SSWRJV_10.1.0/lsf_welcome/lsf_kc_cluster_ops.html)；

- 如果出现错误，请参阅 [LSF 问题排除](https://www.ibm.com/docs/en/SSWRJV_10.1.0/lsf_admin/chap_troubleshooting_lsf.html#v3523448)，了解一些常见的配置错误。


集群成功添加新的服务器主机后，运行 `bhosts` 命令输出如下：

```console
lenny.peng@sta-fpga-d:~$ source /opt/ibm/lsfce/conf/profile.lsf
lenny.peng@sta-fpga-d:~$ bhosts
HOST_NAME          STATUS       JL/U    MAX  NJOBS    RUN  SSUSP  USUSP    RSV
sta-fpga-b.xfoss   ok              -     14      0      0      0      0      0
sta-fpga-d.xfoss   ok              -     14      0      0      0      0      0
```

运行 `bjobs -l 3` 命令的输出：


```console
lenny.peng@sta-fpga-d:~/hpl-2.3/bin/linux$ bjobs -l 3

Job <3>, User <lenny.peng>, Project <default>, Status <RUN>, Queue <normal>, Co
                     mmand <mpirun -np 16 ./xhpl>, Share group charged </lenny.
                     peng>
Wed Oct 18 13:14:40: Submitted from host <sta-fpga-d.xfossm.com>, CWD <$HOME/
                     hpl-2.3/bin/linux>, Output File <output.3>, 16 Task(s);
Wed Oct 18 13:14:41: Started 16 Task(s) on Host(s) <14*sta-fpga-d.xfossm.com>
                     <2*sta-fpga-b.xfossm.com>, Allocated 16 Slot(s) on Host(
                     s) <14*sta-fpga-d.xfossm.com> <2*sta-fpga-b.xfossm.com
                     >, Execution Home </home/lenny.peng>, Execution CWD </home
                     /lenny.peng/hpl-2.3/bin/linux>;
Wed Oct 18 13:15:33: Resource usage collected.
                     MEM: 30 Mbytes;  SWAP: 227 Mbytes;  NTHREAD: 7


 MEMORY USAGE:
 MAX MEM: 30 Mbytes;  AVG MEM: 29 Mbytes

 SCHEDULING PARAMETERS:
           r15s   r1m  r15m   ut      pg    io   ls    it    tmp    swp    mem
 loadSched   -     -     -     -       -     -    -     -     -      -      -
 loadStop    -     -     -     -       -     -    -     -     -      -      -

 RESOURCE REQUIREMENT DETAILS:
 Combined: select[type == local] order[r15s:pg]
 Effective: select[type == local] order[r15s:pg]

```


运行作业时，运行 `bhosts` 命令的输出：


```console
lenny.peng@sta-fpga-d:~/hpl-2.3/bin/linux$ bhosts
HOST_NAME          STATUS       JL/U    MAX  NJOBS    RUN  SSUSP  USUSP    RSV
sta-fpga-b.xfoss   ok              -     14     10     10      0      0      0
sta-fpga-d.xfoss   closed          -     14     14     14      0      0      0
```
