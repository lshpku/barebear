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

#define DEFINE_CSRR(name, csr)      \
    inline uint64_t __csrr_##name() \
    {                               \
        uint64_t result;            \
        asm volatile("csrr %0, %1"  \
                     : "=r"(result) \
                     : "i"(csr));   \
        return result;              \
    }

#define DEFINE_CSRW(name, csr)                \
    inline void __csrw_##name(uint64_t value) \
    {                                         \
        asm volatile("csrw %0, %1"            \
                     :                        \
                     : "i"(csr), "r"(value)); \
    }

#endif
