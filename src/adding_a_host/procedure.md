# 流程

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


    d. 运行 `sudo ./lsfinstall -f ./install.config` 命令；

    e. 请按照由 `lsfinstall` 脚本，所生成的 `/opt/ibm/lsfce/10.1/lsf_quick_admin.html` 文件中，主机设置的步骤，设置新的主机。


2. 将主机信息，添加到 `lsf.cluster.cluster_name` 文件。
