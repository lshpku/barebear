#include "lib/case.h"

BEGIN_TEST()

    # ADD
    li  a1, 23
    li  a2, 17
    ENTER_UNICORE()
    ADD(a0, a1, a2)
    EXIT_UNICORE()
    li  a1, 40
    MATCH(a0, a1)

    # ADD.A
    li  a1, 0x88ddef05
    li  a2, 0xe5e1c02f
    ENTER_UNICORE()
    .word 0x095a864c    # add.a a0, a1, a2 >> #3
    EXIT_UNICORE()
    li  a1, 0xa59a270a
    MATCH(a0, a1)

END_TEST()
