#include "bblib.h"

#define SYSCALL_WRITE 64

extern volatile uint64_t tohost;
extern volatile uint64_t fromhost;

uintptr_t syscall(uintptr_t which, uint64_t arg0, uint64_t arg1, uint64_t arg2)
{
    volatile size_t magic_mem[8] __attribute__((aligned(64)));
    magic_mem[0] = which;
    magic_mem[1] = arg0;
    magic_mem[2] = arg1;
    magic_mem[3] = arg2;
    __sync_synchronize();

    tohost = (uintptr_t)magic_mem;
    while (fromhost == 0)
        ;
    fromhost = 0;

    __sync_synchronize();
    return magic_mem[0];
}

long unsigned int strlen(const char *s)
{
    int size = 0;
    while (*(s++))
        size++;
    return size;
}

int puts(const char *s)
{
    return syscall(SYSCALL_WRITE, 1, (size_t)s, strlen(s));
}

int putx(unsigned i)
{
    char b[8];
    for (int j = 0; j < 8; j++) {
        int c = (i >> (j << 2)) & 0xF;
        if (c < 10)
            c += '0';
        else
            c += 'a' - 10;
        b[7 - j] = c;
    }
    return syscall(SYSCALL_WRITE, 1, (uint64_t)b, sizeof(b));
}
