# Bare Bear

A Baremetal Test Framework for RISC-V

## Uni-ld
将C代码直接编译为UniCore32的二进制并链接到RISC-V程序中

### 使用方法

#### 编译UniCore程序
* 用unicore工具链生成可重定向文件
  ```bash
  $ unicore32-linux-gcc -std=c99 -O1 -c bench/bubble.c -o bubble.o
  ```
* 检查是否有`ldm`或`stm`指令，若有则无法执行，请修改代码或编译选项
（通常编译器会在`-O0`，或函数比较大，或有连续地址的访存时生成`ldm`和`stm`）
  ```bash
  $ unicore32-linux-objdump -D bubble.o | grep -E 'ldm|stm'
  ```

#### 链接RISC-V程序
* 用`unild`生成RISC-V可执行文件
  ```bash
  $ ./unild bubble.o -e do_bubble -o bubble
  ```
  * `-e`：指定入口函数，因为`bubble.c`中有两个函数，必须显式指定入口函数
  * 注：当前环境中必须有`riscv64-unknown-elf-gcc`！


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
