
#define WRAP(t) __##t
#define X_WRAP(t) WRAP(t)

#ifndef CASENAME
#error "CASENAME not define" 
#endif

#define BEGIN_TEST()          \
    .section .text;           \
    .global X_WRAP(CASENAME); \
    X_WRAP(CASENAME):         \
        addi    sp, sp, -32;

#define END_TEST()          \
    __pass:                 \
        li  a0, 0;          \
        j   __end;          \
    __fail:                 \
        li  a0, 1;          \
    __end:                  \
        addi    sp, sp, 32; \
        ret;

#define ENTER_UNICORE() \
    add x0, x0, x1;

#define EXIT_UNICORE() \
    add x0, x0, x2;

#define MATCH(rs1, rs2) \
    bne rs1, rs2, __fail;
