#ifndef __BBLIB_H__
#define __BBLIB_H__

#include <stdint.h>
#include <stddef.h>
#include "printf.h"
#include "riscv-csr.h"

uintptr_t syscall(uintptr_t which, uint64_t arg0, uint64_t arg1, uint64_t arg2);

long unsigned int strlen(const char *s);
int puts(const char *str);
void _putchar(char character);

void exit(int);

#endif
