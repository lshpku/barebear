#include "lib/case.h"

BEGIN_TEST()

    # SWAP read pc
    li  a0, 37
    sw  a0, 0(sp)
    ENTER_UNICORE()
    1: SWAPW(a1, x31, sp)
    EXIT_UNICORE()
    MATCH(a0, a1)
    la  a0, 1b
    lwu a1, 0(sp)
    MATCH(a0, a1)

    # SWAP write pc
    li  a0, 7
    li  a1, 13
    la  a2, 2f
    sw  a2, 0(sp)
    ENTER_UNICORE()
    1: SWAPW(x31, a1, sp)
    ADD(a0, a1, a0)
    2: ADD(a0, a0, a1)
    EXIT_UNICORE()
    li  a2, 20
    MATCH(a0, a2)
    lwu a2, 0(sp)
    MATCH(a1, a2)

    # SWAP r/w pc
    li  a0, 7
    li  a1, 13
    la  a2, 2f
    sw  a2, 0(sp)
    ENTER_UNICORE()
    1: SWAPW(x31, x31, sp)
    ADD(a0, a1, a0)
    2: ADD(a0, a0, a1)
    EXIT_UNICORE()
    li  a1, 20
    MATCH(a0, a1)
    la  a1, 1b
    lwu a2, 0(sp)
    MATCH(a1, a2)

END_TEST()
