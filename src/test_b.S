#include "lib/case.h"

BEGIN_TEST()

    # B forward
    li  a1, 37
    li  a2, 41
    li  x30, 0x4e73f49f
    mv  a3, x30
    ENTER_UNICORE()
    ADD(a0, a1, a2)
    B(1)
    ADD(a0, a0, a1) # skipped
    ADD(a1, a0, a2)
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
    ADD(a0, a1, a2)
    1: B_L(1)
    ADD(a0, a0, a1) # skipped
    ADD(a1, a0, a2)
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
    ADD(a0, a0, a1)
    ADD(a0, a1, a0) # B falls here
    EXIT_UNICORE()
    j   2f
    1: ENTER_UNICORE()
    B(-5)
    2: li   a1, 214
    MATCH(a0, a1)

    # B.L backward
    li  a0, 117
    li  a1, 97
    mv  a2, zero
    j   1f
    ADD(a0, a0, a1)
    ADD(a0, a1, a0) # B falls here
    .word 0x09f3004c    # add.a a2, r30, a2 >> #0
    EXIT_UNICORE()
    j   3f
    1: ENTER_UNICORE()
    2: B_L(-6)
    3: li   a1, 214
    MATCH(a0, a1)
    la  a3, 2b
    MATCH(a2, a3)

END_TEST()
