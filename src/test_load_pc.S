#include "lib/case.h"

BEGIN_TEST()

    # LOAD [pc]
    mv  a0, zero
    ENTER_UNICORE()
    1: LDW(a1, x31, a0)
    2: LDW(a2, a0, x31)
    EXIT_UNICORE()
    la  a0, 1b
    lwu a0, 0(a0)
    MATCH(a1, a0)
    la  a0, 2b
    lwu a0, 0(a0)
    MATCH(a2, a0)

    # LOAD to pc
    mv  a2, sp
    la  a3, 1f
    sw  a3, 0(a2)
    mv  a0, zero
    li  a1, 7
    ENTER_UNICORE()
    LDW(x31, a2, a0)
    ADD(a0, a1, a0)
    1: ADD(a0, a0, a1)
    EXIT_UNICORE()
    MATCH(a0, a1)

END_TEST()
