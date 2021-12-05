#include "syslib.h"

#define SYSCALL_WRITE 64

#define PUT_BUFFER_SIZE 64

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

int puts(const char *s)
{
    const char *e = s;
    while (*e++)
        ;
    return syscall(SYSCALL_WRITE, 1, (size_t)s, e - s);
}

void _putchar(char character)
{
    static char b[PUT_BUFFER_SIZE];
    static int i = 0;
    b[i++] = character;
    if (character == '\n' || i == PUT_BUFFER_SIZE) {
        syscall(SYSCALL_WRITE, 1, (size_t)b, i);
        i = 0;
    }
}
