# Bare Bear

A Baremetal Test Framework for RISC-V

## Uni-ld
将C代码直接编译为UniCore32二进制并链接到RISC-V程序中

### 使用方法

#### 准备测试样例
* 目前Uni-ld只支持无外部链接（包括库函数、运行时）和系统调用的C代码，故不能使用`printf`，也不能包含不可强度消减的`/`、`%`运算
* 你可以在代码中写多个函数，但需要指定一个入口函数，Uni-ld将从入口函数开始执行，并返回入口函数的结果
* 入口函数的示例如下，必须无参数，并且返回类型为`int`；入口函数名称不能为`main`
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
  # *** FAILED *** (code = 1, seed 1646491743) after 997647 cycles
  ```
  * 注：结果为`code = 1`，和前面的`code = 4`不一样，因为目前`cmpsub.a`指令的`V`位计算有问题
