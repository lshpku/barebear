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
    char b[256];
    int bi = 0, si = 0;
    while (*s) {
        si++;
        b[bi++] = *(s++);
        if (bi == 256) {
            si += syscall(SYSCALL_WRITE, 1, (size_t)b, 256);
            bi = 0;
        }
    }
    b[bi] = '\n';
    return si + syscall(SYSCALL_WRITE, 1, (size_t)b, bi + 1);
}

#define PUTCHAR_BUFFER_SIZE 256U

void _putchar(char character)
{
    static char b[PUTCHAR_BUFFER_SIZE];
    static int i = 0;
    b[i++] = character;
    if (character == '\n' || i == sizeof(b)) {
        syscall(SYSCALL_WRITE, 1, (size_t)b, i);
        i = 0;
    }
}
