# Bare Bear

A Baremetal Test Framework for RISC-V

## Uni-ld
将C代码直接编译为UniCore32二进制并链接到RISC-V程序中

### 使用方法

#### 准备测试样例
* 目前Uni-ld只支持无外部链接（包括库函数、运行时）和系统调用的C代码，故不能使用`printf`，也不能包含不可强度消减的`/`、`%`运算
* 你可以在代码中写多个函数，但需要指定一个入口函数，Uni-ld将从入口函数开始执行，并返回入口函数的结果
* 入口函数的示例如下，必须无参数，并且返回类型为`int`
  ```c
  int my_entry() {
    ...
    return res;
  }
  ```
* 建议将全局数据和非入口函数都标为`static`，避免和RISC-V主程序冲突
* `bench/`中已经提供了数个样例程序供参考，下面的教程将基于`bench/bubble.c`

#### 编译UniCore程序
* 用unicore工具链生成可重定向文件
  ```bash
  $ unicore32-linux-gcc -std=c99 -O1 -c bench/bubble.c -o bubble.o
  ```
* 确认无库函数和运行时调用
  ```bash
  $ unicore32-linux-objdump -D bubble.o  # 检查反汇编代码
  $ unicore32-linux-readelf -r bubble.o  # 检查重定位表
  ```

#### 链接RISC-V程序
* 用`unild`生成RISC-V可执行文件
  ```bash
  $ ./unild bubble.o -e do_bubble -o bubble
  ```
  * `-e`：指定入口函数，因为`bubble.c`中有两个函数，必须显式指定入口函数；若只有一个函数则无需指定
  * 注：`unild`需要调用`riscv64-unknown-elf-gcc`，你可以在`chipyard-slim`容器中运行
  * 注：`unild`依赖于`barebear`的库，故必须在`barebear`目录下执行

#### 运行
* 在本机架构下运行，得到参考结果
  ```bash
  $ gcc bench/bubble.c -DWITH_MAIN -o bubble_ref && ./bubble_ref
  # code = 4
  ```
* 在BOOM中运行（请正确设置运行目录）
  ```bash
  $ <boom_split>/build/simulator-MediumUniCoreConfig <barebear>/bubble
  # This emulator compiled with JTAG Remote Bitbang client. To enable, use +jtag_rbb_enable=1.
  # Listening on port 41121
  # [UART] UART0 is here (stdin/stdout).
  # *** FAILED *** (code = 4, seed 1646491743) after 997647 cycles
  ```
  * 注：结果为`code = 4`，和上面相同，说明运行正确

### 进阶使用

#### 使用Uni-ld进行性能评测
* Uni-ld支持通过返回值获取RISC-V CSR性能计数器的值，且支持设置预热轮数，例如
  ```bash
  $ ./unild kmp.o -e do_kmp -o kmp --warmup 3 --hpm-counter mcycle
  ```
  * `--warmup`：先预热运行`warmup`次`do_kmp`，再正式运行1次`do_kmp`；预热运行与正式运行实际上并无差别
  * `--hpm-counter`：统计并返回正式运行时该计数器的值（增量）；RISC-V默认提供`mcycle`和`minstret`两个计数器，如有需要可在`mhpmcounter{3-31}`上扩展
  * 注：请确保你的程序每次执行的内容都是相同的；例如，如果你的程序是排序，请确保每次排序的数组都是相同的，否则可能得到错误的结果
* 使用上述方法链接的程序执行方法与普通程序无异，除了返回值变为性能计数器的值，例如
  ```bash
  $ <boom_split>/build/simulator-MediumUniCoreConfig <barebear>/kmp
  # This emulator compiled with JTAG Remote Bitbang client. To enable, use +jtag_rbb_enable=1.
  # Listening on port 38671
  # [UART] UART0 is here (stdin/stdout).
  # *** FAILED *** (code = 30796, seed 1645908901) after 1201529 cycles
  ```
  * 容易知道，性能计数器的值为30796
  * 注：由于开启`--hpm-counter`选项后无法得知程序本身的返回值，建议先只开`--warmup`确认返回值无误后再开`--hpm-counter`

#### 开启调试输出
* 开启`-v`选项获取关于重定位的详细信息，例如
  ```bash
  $ ./unild matmul.o -e do_matmul -o matmul -v
  # debug: Accept section '.text'
  # debug: Accept section '.data'
  # debug: Accept section '.bss'
  # debug: Relocate ABS32 0x00003164 (.text+0x124) to 0x80004000 (.data+0x1000)
  # debug: Relocate ABS32 0x00003168 (.text+0x128) to 0x80005010 (.bss+0x0)
  # debug: Relocate ABS32 0x0000316c (.text+0x12c) to 0x80003000 (.data+0x0)
  ```
* Uni-ld不保证支持所有的重定位方式，你可以从这里发现问题，完善和扩展Uni-ld
