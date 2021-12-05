#ifndef __SYSLIB_H__
#define __SYSLIB_H__

#include <stdint.h>
#include <stddef.h>

uintptr_t syscall(uintptr_t which, uint64_t arg0, uint64_t arg1, uint64_t arg2);

void _putchar(char character);

void exit(int);

#endif
