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

    # ADD.A with C=0 then ADDC
    li  a1, 0x12345678
    li  a2, 0xf0123456
    li  a3, 0x789abcde
    li  a4, 0x56789012
    ENTER_UNICORE()
    .word 0x095a824c    # add.a a0, a1, a2 >> #1
    .word 0x0b6a800e    # addc.a a0, a3, a4 << #0
    EXIT_UNICORE()
    li  a1, 0xcf134cf0
    MATCH(a0, a1)

    # ADD.A with C=1 then ADDC
    li  a1, 0xf72e915b
    li  a2, 0xee240b13
    li  a3, 0xabcdef01
    li  a4, 0x23456789
    ENTER_UNICORE()
    .word 0x095a824c    # add.a a0, a1, a2 >> #1
    .word 0x0b6a800e    # addc.a a0, a3, a4 << #0
    EXIT_UNICORE()
    li  a1, 0xcf13568b
    MATCH(a0, a1)

    # ADDC.A with C=1 then ADDC
    li  a1, 0xdef01234
    li  a2, 0x56789abc
    li  a3, 0xabcdef01
    li  a4, 0x23456789
    ENTER_UNICORE()
    .word 0x0b5a800c    # addc.a a0, a1, a2 << #0
    .word 0x0b6a800e    # addc.a a0, a3, a4 << #0
    EXIT_UNICORE()
    li  a1, 0xcf13568b
    MATCH(a0, a1)

END_TEST()
