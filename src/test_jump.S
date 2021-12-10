#include "lib/case.h"

BEGIN_TEST()

    # JUMP forward
    la  a0, 1f
    li  a1, 53
    li  a2, 29
    li  x30, 0x745ae8d5
    mv  a4, x30
    ENTER_UNICORE()
    .word 0x10ffc12a    # JUMP a0
    .word 0x085ac00c    # add a1, a1, a2 << #0
    1: .word 0x0862c00b # add a1, a2, a1 << #0
    EXIT_UNICORE()
    li  a3, 82
    MATCH(a3, a1)
    MATCH(a4, x30)

    # JUMP.L forward
    la  a0, 2f
    li  a1, 53
    li  a2, 29
    ENTER_UNICORE()
    1: .word 0x11ffc12a # JUMP.L a0
    .word 0x085ac00c    # add a1, a1, a2 << #0
    2: .word 0x0862c00b # add a1, a2, a1 << #0
    EXIT_UNICORE()
    li  a3, 82
    MATCH(a3, a1)
    la  a4, 1b
    MATCH(a4, x30)

    # JUMP backward
    la  a0, 1f
    li  a1, 0x36a
    li  a2, 0x2c8
    j   2f
    .word 0x085ac00c    # add a1, a1, a2 << #0
    1: .word 0x0862c00b # add a1, a2, a1 << #0
    EXIT_UNICORE()
    j   3f
    2: ENTER_UNICORE()
    .word 0x10ffc12a    # JUMP a0
    3: li a2, 0x632
    MATCH(a1, a2)

    # JUMP.L backward
    la  a0, 1f
    li  a1, 0x36a
    li  a2, 0x2c8
    j   2f
    .word 0x085ac00c    # add a1, a1, a2 << #0
    1: .word 0x0862c00b # add a1, a2, a1 << #0
    EXIT_UNICORE()
    j   4f
    2: ENTER_UNICORE()
    3: .word 0x11ffc12a # JUMP.L a0
    4: li a2, 0x632
    MATCH(a1, a2)
    la  a3, 3b
    MATCH(a3, x30)

END_TEST()
