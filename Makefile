
TOOLCHAIN=riscv64-unknown-elf-

CC=$(TOOLCHAIN)gcc
CFLAGS=-march=rv64g -mabi=lp64 -mcmodel=medany -O3
LDFLAGS=-nostdlib -nostartfiles -Tlink.ld -static

LIBC=$(wildcard lib/*.c)

EXTRA ?=

all: main

main: main.S lib/syslib.c lib/crt.S
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

%: %.c $(LIBC) lib/crt.S
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(EXTRA)

%.dump: %
	$(TOOLCHAIN)objdump -D $< > $@

%.elf: %
	$(TOOLCHAIN)readelf -e $< > $@
