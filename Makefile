
TOOLCHAIN=riscv64-unknown-elf-

CC=$(TOOLCHAIN)gcc
CFLAGS=-march=rv64g -mabi=lp64 -mcmodel=medany -O2
LDFLAGS=-nostdlib -nostartfiles -Tlib/link.ld -static

all: main

main: main.S lib/bblib.c lib/crt.S
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

sim: main
	$(SIM) $<

spike: main
	spike $<

dump: main
	$(TOOLCHAIN)objdump -D $<

elf: main
	$(TOOLCHAIN)readelf -e $<
