#include <stdint.h>
#include <stddef.h>

uintptr_t syscall(uintptr_t which, uint64_t arg0, uint64_t arg1, uint64_t arg2);

long unsigned int strlen(const char *s);
int puts(const char *s);
int putx(unsigned i);

void exit(int);
