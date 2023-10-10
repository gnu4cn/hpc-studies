# Flexing your Arm Muscle

原文：[Flexing your Arm Muscle](https://medium.com/ibm-data-ai/flexing-your-arm-muscle-for-hpc-ce00c29f000d)


> “Flexing your Arm Muscle”，此处原文巧妙的使用了双关修辞，字面意思是 “秀出你的二头肌”，而在计算技术语境下，实为展示 Arm 电脑计算能力的意思。

从英格兰剑桥起步时的岌岌无名，Arm 现已成为处理器内核领域的全球领导者，而处理器内核正是我们数字世界的核心。但是，Arm 不再只是移动设备的代名词。如今，Arm 处理器已成为 [树莓派（Raspberry Pi）](https://www.raspberrypi.org/) 等单板计算机，以及苹果公司最新设备的动力，也是云计算（ [AWS Graviton](https://aws.amazon.com/ec2/graviton/) ）和目前世界上速度最快超级计算机 [Fugaku](https://en.wikipedia.org/wiki/Fugaku_(supercomputer)) 的动力。Arm 一直在大展拳脚，撼动了整个行业。在基于 Arm 的系统被广泛采用之前，我(原作者：Gábor Samu)就一直在使用它们。20 世纪 90 年代，Arm 系统在加拿大十分罕见，我有幸在加拿大奥利维蒂公司（Olivetti Canada），接触到了使用 Arm 技术的 Acorn Archimedes 计算机。当时我并不知道，Arm 在今天会已经如此普及。


> 富岳，Fugaku, 截至到 2022 年 5 月，已被 Frontier, 前沿超越，已不再是世界最快超级计算机（2023 年 10 月）。

在高性能计算（HPC）领域，由 Arm 驱动的系统已不再只是一个愿景。他们正在高性能计算领域掀起巨大波澜，解决包括 [COVID-19 研究](https://www.japantimes.co.jp/news/2021/03/09/national/science-health/fugaku-supercomputer-covid19-research/) 在内的复杂问题，软件生态系统也获得了显著的发展势头。


工作负载调度程序是任何高性能计算集群的重要软件组件，an essential software component of any high performance computing cluster is a workload scheduler。工作负载调度程序类似于交通警察，有助于确保集群中受调度作业，在正确的时间获得正确的资源。从表面上看，这似乎是一项简单的任务，但当集群包含了数千台服务器，用户在业务优先级的背景下争夺资源时，工作负载调度程序对于充分利用这些宝贵的计算资源，至关重要。如今有许多的工作负载调度程序，从开源到闭源专有程序都有。[IBM Spectrum LSF](https://www.ibm.com/us-en/products/hpc-workload-management) 是一套支持 x86-64、IBM Power (LE) 以及 Arm 处理器上 Linux 平台的工作负载调度程序。Spectrum LSF 在 HPC 工作负载调度方面有着悠久的历史，并提供了社区版，[IBM Spectrum LSF CE](https://epwt-www.mybluemix.net/software/support/trial/cst/programwebsite.wss?siteId=680&h=&tabId=) 可免费下载（需要注册），最多可在 10 台服务器（双插槽，dual-socket）上使用，最多可支持 1000 个活动作业。
