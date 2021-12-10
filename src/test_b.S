#include "lib/case.h"

BEGIN_TEST()

    # B forward
    li  a1, 37
    li  a2, 41
    li  x30, 0x4e73f49f
    mv  a3, x30
    ENTER_UNICORE()
    .word 0x085a800c    # add a0, a1, a2 << #0
    .word 0xbc000001    # B PC+8
    .word 0x0852800b    # add a0, a0, a1 << #0 (skipped)
    .word 0x0852c00c    # add a1, a0, a2 << #0
    EXIT_UNICORE()
    li  a2, 78
    MATCH(a0, a2)
    li  a2, 119
    MATCH(a1, a2)
    MATCH(a3, x30)

    # B.L forward
    li  a1, 17
    li  a2, 29
    ENTER_UNICORE()
    .word 0x085a800c    # add a0, a1, a2 << #0
    1: .word 0xbd000001 # B.L PC+8
    .word 0x0852800b    # add a0, a0, a1 << #0 (skipped)
    .word 0x0852c00c    # add a1, a0, a2 << #0
    EXIT_UNICORE()
    li  a2, 46
    MATCH(a0, a2)
    li  a2, 75
    MATCH(a1, a2)
    la  a2, 1b
    MATCH(a2, x30)

    # B backward
    li  a0, 117
    li  a1, 97
    j   1f
    .word 0x0852800b    # add a0, a0, a1 << #0
    .word 0x085a800a    # add a0, a1, a0 << #0 (B falls here)
    EXIT_UNICORE()
    j   2f
    1: ENTER_UNICORE()
    .word 0xbcfffffb    # B PC-16
    2: li   a1, 214
    MATCH(a0, a1)

    # B.L backward
    li  a0, 117
    li  a1, 97
    mv  a2, zero
    j   1f
    .word 0x0852800b    # add a0, a0, a1 << #0
    .word 0x085a800a    # add a0, a1, a0 << #0 (B falls here)
    .word 0x09f3004c    # add.a a2, r30, a2 >> #0
    EXIT_UNICORE()
    j   3f
    1: ENTER_UNICORE()
    2: .word 0xbdfffffa # B.L PC-20
    3: li   a1, 214
    MATCH(a0, a1)
    la  a3, 2b
    MATCH(a2, a3)

END_TEST()
