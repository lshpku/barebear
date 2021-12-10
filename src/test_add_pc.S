#include "lib/case.h"

BEGIN_TEST()

    # ADDs that read r31
    mv  a0, zero
    ENTER_UNICORE()
    1: .word 0x0852c01f # add a1, a0, r31 << #0
    2: .word 0x08fb000a # add a2, r31, a0 << #0
    3: .word 0x08fb401f # add a3, r31, r31 << #0
    4: .word 0x08fb800a # add a4, r31, a0 << #0
    5: .word 0x0853c01f # add a5, a0, r31 << #0
    EXIT_UNICORE()
    la  a0, 1b
    MATCH(a0, a1)
    la  a0, 2b
    MATCH(a0, a2)
    la  a0, 3b
    addw    a0, a0, a0
    addw    a3, a3, zero
    MATCH(a0, a3)
    la  a0, 4b
    MATCH(a0, a4)
    la  a0, 5b
    MATCH(a0, a5)

    # ADD that writes r31
    li  a0, 8
    la  a1, 1f
    li  a2, 13
    ENTER_UNICORE()
    1: .word 0x0857c00b # add r31, a0, a1 << #0
    .word 0x0853000c    # add a2, a0, a2 << #0
    .word 0x0863000a    # add a2, a2, a0 << #0
    EXIT_UNICORE()
    li  a3, 21
    MATCH(a3, a2)

    # ADD that reads & writes r31
    li  a0, 8
    li  a2, 13
    ENTER_UNICORE()
    1: .word 0x0857c01f # add r31, a0, r31 << #0
    .word 0x0853000c    # add a2, a0, a2 << #0
    .word 0x0863000a    # add a2, a2, a0 << #0
    EXIT_UNICORE()
    li  a3, 21
    MATCH(a3, a2)

END_TEST()
