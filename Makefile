
TOOLCHAIN=riscv64-unknown-elf-

CC=$(TOOLCHAIN)gcc
CFLAGS=-march=rv64g -mabi=lp64d -mcmodel=medany -I. -O3
LDFLAGS=-nostdlib -nostartfiles -Tlink.ld -static
CDEFS=-DPRINTF_DISABLE_SUPPORT_FLOAT

LIBC=$(wildcard lib/*.c)
SRCS?=$(wildcard src/*.S)
LIBO=$(addprefix build/, $(LIBC:c=o))
SRCO=$(addprefix build/, $(SRCS:S=o))

all: build | build/main

build:
	mkdir -p build build/src build/lib

build/lib/%.o: lib/%.c
	$(CC) $(CFLAGS) $(CDEFS) -c -o $@ $<

build/src/%.S: src/%.S
	./unimacro -o $@ $<

build/src/%.o: build/src/%.S
	$(CC) $(CFLAGS) -DCASENAME=$(subst /,_,$(subst .,_,$(<:build/%=%))) -c -o $@ $<

build/%.o: build/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

build/main.c:
	./instantiate $(SRCS) -o build/main.c

build/main: build/main.o $(LIBO) $(SRCO) lib/crt.S
	$(CC) $(LDFLAGS) -o $@ $^

clean:
	rm -rf build

%.dump: %
	$(TOOLCHAIN)objdump -D $< > $@

%.elf: %
	$(TOOLCHAIN)readelf -e $< > $@
