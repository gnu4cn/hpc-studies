# 运行 HPL 基准测试


## 另一个作业提交示例

我知道。提交睡眠作业，足以让作为读者的你昏昏欲睡。那么，让咱们提交一些更有趣的东西吧 -- 无处不在的高性能 Linpack（High Performance Linpack, HPL）基准测试。因为这里运行的系统并不先进，所以这里的目的是展示 LSF 对并行工作负载的支持，而不是其 Linpack 性能。


尽管在 openSUSE Tumbleweed 上，作为一个软件包提供了 OpenMPI，但其并未被编译支持 LSF。因此，咱们将首先编译出支持 LSF 的 OpenMPI。我们将使用最新的 OpenMPI v4.1.6，并将其编译和安装到 `/opt/openmpi-4.1.6`。

```sh
lenny.peng@sta-f4-d:~$ mkdir MPI
lenny.peng@sta-f4-d:~$ cd MPI
lenny.peng@sta-f4-d:~/MPI$ wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.6.tar.gz
lenny.peng@sta-f4-d:~/MPI$ tar zxvf openmpi-4.1.6.tar.gz
lenny.peng@sta-f4-d:~/MPI$ cd openmpi-4.1.6
lenny.peng@sta-f4-d:~/MPI/openmpi-4.1.6$ ./configure --prefix=/opt/openmpi-4.1.6 --with-lsf=/opt/ibm/lsfce/10.1 --with-lsf-libdir=/opt/ibm/lsfce/10.1/linux2.6-glibc2.3-x86_64/lib
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

> **注意**：请注意 `./configure` 后面的参数，不仅包括 `--with-lsf`，还包括了 `--with-lsf-libdir` 参数。
>
> *参考链接*：[./configure failed with option '--with-lsf'](https://github.com/open-mpi/ompi/issues/10943#issuecomment-1282595183)


OpenMPI 准备就绪后，我们就可以开始编译 HPL 了。HPL 是针对 OpenMPI v4.1.6（上文中所编译的）并使用操作系统所提供的 OpenBLAS 库编译的。HPL 将编译并安装到 `~/hpl-2.3`。


```sh
lenny.peng@sta-f4-d:~$ wget http://netlib.org/benchmark/hpl/hpl-2.3.tar.gz
lenny.peng@sta-f4-d:~$ tar zxvf hpl-2.3.tar.gz
lenny.peng@sta-f4-d:~$ cd hpl-2.3/
lenny.peng@sta-f4-d:~/hpl-2.3$ cd setup/
lenny.peng@sta-f4-d:~/hpl-2.3/setup$ source make_generic
lenny.peng@sta-f4-d:~/hpl-2.3/setup$ cp Make.UNKNOWN Make.linux
lenny.peng@sta-f4-d:~/hpl-2.3/setup$ cd vim Make.linux
```

修改该文件的以下内容：

```console
lenny.peng@sta-fpga-d:~/hpl-2.3/setup$ diff -u1 Make.UNKNOWN Make.linux
--- Make.UNKNOWN        2023-10-12 17:25:55.239585022 +0800
+++ Make.linux  2023-10-12 17:25:47.647322759 +0800
@@ -63,3 +63,3 @@
 #
-ARCH         = UNKNOWN
+ARCH         = linux
 #
@@ -69,3 +69,3 @@
 #
-TOPdir       = $(HOME)/hpl
+TOPdir       = $(HOME)/hpl-2.3
 INCdir       = $(TOPdir)/include
@@ -83,5 +83,5 @@
 #
-MPdir        =
-MPinc        =
-MPlib        =
+MPdir        = /opt/openmpi
+MPinc        = -I${MPdir}/include
+MPlib        = ${MPdir}/lib/libmpi.so
 #
@@ -94,5 +94,5 @@
 #
-LAdir        =
+LAdir        = /opt/openblas
 LAinc        =
-LAlib        = -lblas
+LAlib        = $(LAdir)/lib/libopenblas.a
 #
@@ -172,3 +172,3 @@
 #
-LINKER       = mpif77
+LINKER       = mpicc
 LINKFLAGS    =
```

> **注意**：
>
> 1. 需要在主机上编译安装 `openblas` 软件包。
>
> 参考链接：[Build High Performance LINPACK with BLAS and MPI](https://sites.google.com/site/rangsiman1993/comp-env/test-and-benchmarks/build-hpl-with-blas-and-mpi)

准备好 `Makefile` 后，就要构建 `xhpl` 二进制文件了。请注意，我们在此设置了 `PATH` 和 `LD_LIBRARY_PATH`，以引用 OpenMPI v4.1.6 的安装文件。


```sh
lenny.peng@sta-f4-d:~/hpl-2.3/setup$ export PATH=/opt/openmpi/bin:$PATH
lenny.peng@sta-f4-d:~/hpl-2.3/setup$ export LD_LIBRARY_PATH=/opt/openmpi/lib/libmpi.so:$LD_LIBRARY_PATH
lenny.peng@sta-f4-d:~/hpl-2.3/setup$ cd ..
lenny.peng@sta-f4-d:~/hpl-2.3$ ln -s ./setup/Make.linux ./Make.linux
lenny.peng@sta-f4-d:~/hpl-2.3$ make arch=linux
```

> **注意**：
>
> 1. 需要安装 `gfortran` 软件包，并在 `/opt/openmpi/share/openmpi/mpif90-wrapper-data.txt` 文件中，设置 `compiler=gfortran`；

咱们的 `xhpl` 二进制文件已经就绪，位于 `~/hpl-2.3/bin/linux/`。在将 `xhpl` 提交 LSF 执行之前，我们会根据系统（内存大小、核心数量等）调整 `HPL.dat` 参数文件。最后，提交给 LSF 的 `xhpl` 请求使用 4 个内核。

示例 `HPL.dat`:

```dat
lenny.peng@sta-fpga-d:~/hpl-2.3/bin/linux$ cat HPL.dat
HPLinpack benchmark input file
Innovative Computing Laboratory, University of Tennessee
Modified by hpc.xfoss.com, for single LSF server, 8 cores used.
HPL.out      output file name (if any)
6            device out (6=stdout,7=stderr,file)
1            # of problems sizes (N)
10240         Ns
1            # of NBs
128          NBs
0            PMAP process mapping (0=Row-,1=Column-major)
1            # of process grids (P x Q)
2            Ps
4            Qs
16.0         threshold
1            # of panel fact
2            PFACTs (0=left, 1=Crout, 2=Right)
1            # of recursive stopping criterium
4            NBMINs (>= 1)
1            # of panels in recursion
2            NDIVs
1            # of recursive panel fact.
1            RFACTs (0=left, 1=Crout, 2=Right)
1            # of broadcast
0            BCASTs (0=1rg,1=1rM,2=2rg,3=2rM,4=Lng,5=LnM)
1            # of lookahead depth
0            DEPTHs (>=0)
2            SWAP (0=bin-exch,1=long,2=mix)
32           swapping threshold
0            L1 in (0=transposed,1=no-transposed) form
0            U  in (0=transposed,1=no-transposed) form
1            Equilibration (0=no,1=yes)
8            memory alignment in double (> 0)
```

> **注意**：这个 `HPL.dat` 文件，是 HPLinpack 基准测试的输入文件，需要针对集群 CPU、内存等资源，加以调整，否则会导致其因内存占用过高等原因，被主机系统以 `signal 9` 信号杀死，而返回非零的退出代码。
>
> 参考链接：[Does anyone know how to fix mpirun signal 9 (killed) problem?](https://www.researchgate.net/post/Does-anyone-know-how-to-fix-mpirun-signal-9-killed-problem)

```console
mpirun noticed that process rank 5 with PID 0 on node sta-fpga-d exited on signal 9 (Killed).
```

以 8 核运行该作业：

```console
lenny.peng@sta-fpga-d:~$ cd hpl-2.3/bin/linux/
lenny.peng@sta-fpga-d:~/hpl-2.3/bin/linux$ bsub -n 8 mpirun -np 8 ./xhpl
Job <11> is submitted to default queue <normal>.
```

上述 `xhpl` 作业已成功提交，并被 LSF 调度到 8 个内核上。作业运行时，我们可以使用 `bjobs` 和 `bpeek` 命令，分别查看资源利用率和输出。


执行 `bjobs -l 25` 命令的输出：


```console
lenny.peng@sta-fpga-d:~/hpl-2.3/bin/linux$ bjobs -l 25

Job <25>, User <lenny.peng>, Project <default>, Status <RUN>, Queue <normal>, C
                     ommand <mpirun -np 8 ./xhpl>, Share group charged </lenny.
                     peng>
Thu Oct 12 18:40:41: Submitted from host <sta-fpga-d.xfoss.com>, CWD <$HOME/
                     hpl-2.3/bin/linux>, Output File <output.25>, 8 Task(s);
Thu Oct 12 18:40:42: Started 8 Task(s) on Host(s) <sta-fpga-d.xfoss.com> <st
                     a-fpga-d.xfoss.com> <sta-fpga-d.xfoss.com> <sta-fpga
                     -d.xfoss.com> <sta-fpga-d.xfoss.com> <sta-fpga-d.sen
                     scomm.com> <sta-fpga-d.xfoss.com> <sta-fpga-d.xfoss.
                     com>, Allocated 8 Slot(s) on Host(s) <sta-fpga-d.xfoss.
                     com> <sta-fpga-d.xfoss.com> <sta-fpga-d.xfoss.com> <
                     sta-fpga-d.xfoss.com> <sta-fpga-d.xfoss.com> <sta-fp
                     ga-d.xfoss.com> <sta-fpga-d.xfoss.com> <sta-fpga-d.s
                     enscomm.com>, Execution Home </home/lenny.peng>, Execution
                      CWD </home/lenny.peng/hpl-2.3/bin/linux>;

 SCHEDULING PARAMETERS:
           r15s   r1m  r15m   ut      pg    io   ls    it    tmp    swp    mem
 loadSched   -     -     -     -       -     -    -     -     -      -      -
 loadStop    -     -     -     -       -     -    -     -     -      -      -

 RESOURCE REQUIREMENT DETAILS:
 Combined: select[type == local] order[r15s:pg]
 Effective: select[type == local] order[r15s:pg]

```

执行 `bpeek 24` 命令的输出：

```console
lenny.peng@sta-fpga-d:~/hpl-2.3/bin/linux$ bpeek 24
<< output from stdout >>
================================================================================
HPLinpack 2.3  --  High-Performance Linpack benchmark  --   December 2, 2018
Written by A. Petitet and R. Clint Whaley,  Innovative Computing Laboratory, UTK
Modified by Piotr Luszczek, Innovative Computing Laboratory, UTK
Modified by Julien Langou, University of Colorado Denver
================================================================================

An explanation of the input/output parameters follows:
T/V    : Wall time / encoded variant.
N      : The order of the coefficient matrix A.
NB     : The partitioning blocking factor.
P      : The number of process rows.
Q      : The number of process columns.
Time   : Time in seconds to solve the linear system.
Gflops : Rate of execution for solving the linear system.

The following parameter values will be used:

N      :   10240
NB     :     128
PMAP   : Row-major process mapping
P      :       2
Q      :       4
PFACT  :   Right
NBMIN  :       4
NDIV   :       2
RFACT  :   Crout
BCAST  :   1ring
DEPTH  :       0
SWAP   : Mix (threshold = 32)
L1     : transposed form
U      : transposed form
EQUIL  : yes
ALIGN  : 8 double precision words

--------------------------------------------------------------------------------

- The matrix A is randomly generated for each test.
- The following scaled residual check will be computed:
      ||Ax-b||_oo / ( eps * ( || x ||_oo * || A ||_oo + || b ||_oo ) * N )
- The relative machine precision (eps) is taken to be               1.110223e-16
- Computational tests pass if scaled residuals are less than                16.0
```

运算结果：

```text
Sender: LSF System <lsfadmin@sta-fpga-d.xfoss.com>
Subject: Job 24: <mpirun -np 8 ./xhpl> in cluster <demo-cluster> Done

Job <mpirun -np 8 ./xhpl> was submitted from host <sta-fpga-d.xfoss.com> by user <lenny.peng> in cluster <demo-cluster> at Thu Oct 12 18:37:10 2023
Job was executed on host(s) <8*sta-fpga-d.xfoss.com>, in queue <normal>, as user <lenny.peng> in cluster <demo-cluster> at Thu Oct 12 18:37:10 2023
</home/lenny.peng> was used as the home directory.
</home/lenny.peng/hpl-2.3/bin/linux> was used as the working directory.
Started at Thu Oct 12 18:37:10 2023
Terminated at Thu Oct 12 18:38:04 2023
Results reported at Thu Oct 12 18:38:04 2023

Your job looked like:

------------------------------------------------------------
# LSBATCH: User input
mpirun -np 8 ./xhpl
------------------------------------------------------------

Successfully completed.

Resource usage summary:

    CPU time :                                   969.34 sec.
    Max Memory :                                 980 MB
    Average Memory :                             882.00 MB
    Total Requested Memory :                     -
    Delta Memory :                               -
    Max Swap :                                   -
    Max Processes :                              11
    Max Threads :                                183
    Run time :                                   58 sec.
    Turnaround time :                            54 sec.

The output (if any) follows:

================================================================================
HPLinpack 2.3  --  High-Performance Linpack benchmark  --   December 2, 2018
Written by A. Petitet and R. Clint Whaley,  Innovative Computing Laboratory, UTK
Modified by Piotr Luszczek, Innovative Computing Laboratory, UTK
Modified by Julien Langou, University of Colorado Denver
================================================================================

An explanation of the input/output parameters follows:
T/V    : Wall time / encoded variant.
P      :       2
Q      :       4
PFACT  :   Right
NBMIN  :       4
NDIV   :       2
RFACT  :   Crout
BCAST  :   1ring
DEPTH  :       0
SWAP   : Mix (threshold = 32)
L1     : transposed form
U      : transposed form
EQUIL  : yes
ALIGN  : 8 double precision words

--------------------------------------------------------------------------------

- The matrix A is randomly generated for each test.
- The following scaled residual check will be computed:
      ||Ax-b||_oo / ( eps * ( || x ||_oo * || A ||_oo + || b ||_oo ) * N )
- The relative machine precision (eps) is taken to be               1.110223e-16
- Computational tests pass if scaled residuals are less than                16.0

================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR00C2R4       10240   128     2     4              48.50             1.4762e+01
HPL_pdgesv() start time Thu Oct 12 18:37:13 2023

HPL_pdgesv() end time   Thu Oct 12 18:38:01 2023

--------------------------------------------------------------------------------
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=   2.11204902e-03 ...... PASSED
================================================================================

Finished      1 tests with the following results:
              1 tests completed and passed residual checks,
              0 tests completed and failed residual checks,
              0 tests skipped because of illegal input values.
--------------------------------------------------------------------------------

End of Tests.
================================================================================
```
