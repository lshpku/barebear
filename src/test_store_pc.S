#include "lib/case.h"

BEGIN_TEST()

    # STORE pc
    mv  a0, sp
    mv  a1, zero
    ENTER_UNICORE()
    1: STW(x31, a0, a1)
    EXIT_UNICORE()
    la  a2, 1b
    lwu a3, 0(a0)
    MATCH(a2, a3)

    # STORE to [pc]
    mv  a0, sp
    la  a1, 1f
    sub a1, a0, a1
    ENTER_UNICORE()
    1: STW(a0, x31, a1)
    2: STW(x31, a1, x31)
    EXIT_UNICORE()
    lwu a1, 0(a0)
    MATCH(a0, a1)
    lwu a1, 4(a0)
    la  a2, 2b
    MATCH(a1, a2)

END_TEST()
