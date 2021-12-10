#include "lib/case.h"

BEGIN_TEST()

    # ADD.A with Z=1, Beq predicted taken and taken
    li  a0, 3
    li  a1, 4
    mv  a2, zero
    ENTER_UNICORE()
    .word 0x0963004b    # add.a a2, a2, a1 >> #0
    .word 0xa0000001    # Beq PC+8
    .word 0x085a800a    # add a0, a1, a0 << #0
    .word 0x0852800b    # add a0, a0, a1 << #0
    EXIT_UNICORE()
    li  a2, 7
    MATCH(a0, a2)

    # ADD.A with Z=0, Beq predicted taken but not taken
    li  a0, 3
    li  a1, 4
    li  a2, 5
    ENTER_UNICORE()
    .word 0x0963004b    # add.a a2, a2, a1 >> #0
    .word 0xa0000001    # Beq PC+8
    .word 0x085a800a    # add a0, a1, a0 << #0
    .word 0x0852800b    # add a0, a0, a1 << #0
    EXIT_UNICORE()
    li  a2, 11
    MATCH(a0, a2)

END_TEST()
