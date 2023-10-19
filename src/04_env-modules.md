# `env-modules`


**[hpc-wiki.info: hpc/Modules](https://hpc-wiki.info/hpc/Modules)**：

> `module` 系统是大多数超级计算机上都有的概念，可简化不同软件（版本）的使用，使其精确可控。
>
> 在大多数情况下，超级计算机安装的软件，都要比普通用户使用的软件多得多。每个软件包都需要对 `$PATH`、`$LD_LIBRARY_PATH`，以及其他 [环境变量](glossories.md#环境变量environment-variables) 进行不同的设置，这些设置可能会相互影响，甚至相互排斥。其次，不同的用户（群组）需要不同版本的相同软件，而这些软件一般不能在同一系统中并行安装或使用。
>
> 因此，所有这些软件包及其受支持版本的设置，都封装在由模块系统所维护的 “环境模块” 中。*这些模块与 `perl` 或 `python` 等编程语言所谓的模块毫无关系，不应混淆*。
>
> 通过模块系统，便可使用命令 `module`，列出、加载及卸载群集上当前可用的所有软件。
>



`env-modules` 项目，目前（2023/10）是由供职于 [法国原子能委员会](https://www.cea.fr/english) 的 [Xavier Delaruelle](https://fr.linkedin.com/in/xdelaruelle)，所维护的一个开源项目，项目网站 [modules.sourceforge.net](http://modules.sourceforge.net/)，源码仓库：

- [github.com: cea-hpc/modules](https://github.com/cea-hpc/modules)

- [sourceforge.net: Environment Modules Git](https://sourceforge.net/p/modules/modules/ci/main/tree/)


**经由一些 `modulefiles`，环境模块包，the Environment Modules package, 提供了动态修改用户环境的功能**。


模块包是一种简化 shell 初始化的工具，使用 `modulefiles`，用户在会话期间可以轻松修改其环境。


每个 `modulefile`，都包含了为某个应用程序，配置 shell 所需的信息。模块包初始化后，便可使用对模块文件，modulefiles 进行的 `module` 命令，按模块修改环境。通常情况下，模块文件会指示 `module` 命令，修改或设置 shell 环境变量，如 `PATH`、`MANPATH` 等。模块文件会被系统中的许多用户共享，而用户也可能拥有自己的模块文件集，以补充或替代共享的模块文件。

模块可以动态及原子方式地，atomically，加载和卸载，干净利落。支持所有常用的 shell，包括 `bash`、`ksh`、`zsh`、`sh`、`csh`、`tcsh`、`fish`、`cmd` 等，以及一些脚本语言，如 `tcl`、`perl`、`python`、`ruby`、`cmake` 及 `r` 等。


模块在管理不同版本的应用程序时非常有用。模块还可以捆绑成元模块，meta-modules，用于加载整套不同的应用程序。
