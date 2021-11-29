
TOOLCHAIN=riscv64-unknown-elf-

CC=$(TOOLCHAIN)gcc
CFLAGS=-march=rv64g -mabi=lp64 -mcmodel=medany -O3
LDFLAGS=-nostdlib -nostartfiles -Tlink.ld -static

LIBC=$(wildcard lib/*.c)
LIBS=lib/crt.S

all: main

main: main.S $(LIBC) $(LIBS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

%: %.c $(LIBC) $(LIBS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

%.dump: %
	$(TOOLCHAIN)objdump -D $< > $@

%.elf: %
	$(TOOLCHAIN)readelf -e $<
