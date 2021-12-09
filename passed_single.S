.section .text;

.global main
main:
    # ADD
    li  a1, 23
    li  a2, 17
    add x0, x0, x1
    .word 0x085a800c    # add a0, a1, a2 << #0
    add x0, x0, x2
    li  a1, 40
    bne a0, a1, fail

    # ADD.A
    li  a1, 0x88ddef05
    li  a2, 0xe5e1c02f
    add x0, x0, x1
    .word 0x095a864c    # add.a a0, a1, a2 >> #3
    add x0, x0, x2
    li  a1, 0xa59a270a
    bne a0, a1, fail

    # ADD.A with C=0 then ADDC
    li  a1, 0x12345678
    li  a2, 0xf0123456
    li  a3, 0x789abcde
    li  a4, 0x56789012
    add x0, x0, x1
    .word 0x095a824c    # add.a a0, a1, a2 >> #1
    .word 0x0b6a800e    # addc.a a0, a3, a4 << #0
    add x0, x0, x2
    li  a1, 0xcf134cf0
    bne a0, a1, fail

    # ADD.A with C=1 then ADDC
    li  a1, 0xf72e915b
    li  a2, 0xee240b13
    li  a3, 0xabcdef01
    li  a4, 0x23456789
    add x0, x0, x1
    .word 0x095a824c    # add.a a0, a1, a2 >> #1
    .word 0x0b6a800e    # addc.a a0, a3, a4 << #0
    add x0, x0, x2
    li  a1, 0xcf13568b
    bne a0, a1, fail

    # ADDC.A with C=1 then ADDC
    li  a1, 0xdef01234
    li  a2, 0x56789abc
    li  a3, 0xabcdef01
    li  a4, 0x23456789
    add x0, x0, x1
    .word 0x0b5a800c    # addc.a a0, a1, a2 << #0
    .word 0x0b6a800e    # addc.a a0, a3, a4 << #0
    add x0, x0, x2
    li  a1, 0xcf13568b
    bne a0, a1, fail

    # B forward
    li  a1, 37
    li  a2, 41
    li  x30, 0x4e73f49f
    mv  a3, x30
    add x0, x0, x1
    .word 0x085a800c    # add a0, a1, a2 << #0
    .word 0xbc000001    # B PC+8
    .word 0x0852800b    # add a0, a0, a1 << #0 (skipped)
    .word 0x0852c00c    # add a1, a0, a2 << #0
    add x0, x0, x2
    li  a2, 78
    bne a0, a2, fail
    li  a2, 119
    bne a1, a2, fail
    bne a3, x30, fail

    # B.L forward
    li  a1, 17
    li  a2, 29
    add x0, x0, x1
    .word 0x085a800c    # add a0, a1, a2 << #0
    1: .word 0xbd000001 # B.L PC+8
    .word 0x0852800b    # add a0, a0, a1 << #0 (skipped)
    .word 0x0852c00c    # add a1, a0, a2 << #0
    add x0, x0, x2
    li  a2, 46
    bne a0, a2, fail
    li  a2, 75
    bne a1, a2, fail
    la  a2, 1b
    bne a2, x30, fail

    # B backward
    li  a0, 117
    li  a1, 97
    j   1f
    .word 0x0852800b    # add a0, a0, a1 << #0
    .word 0x085a800a    # add a0, a1, a0 << #0 (B falls here)
    add x0, x0, x2
    j   2f
    1: add x0, x0, x1
    .word 0xbcfffffb    # B PC-16
    2: li   a1, 214
    bne a0, a1, fail

    # B.L backward
    li  a0, 117
    li  a1, 97
    mv  a2, zero
    j   1f
    .word 0x0852800b    # add a0, a0, a1 << #0
    .word 0x085a800a    # add a0, a1, a0 << #0 (B falls here)
    .word 0x09f3004c    # add.a a2, r30, a2 >> #0
    add x0, x0, x2
    j   3f
    1: add x0, x0, x1
    2: .word 0xbdfffffa # B.L PC-20
    3: li   a1, 214
    bne a0, a1, fail
    la  a3, 2b
    bne  a2, a3, fail

    # JUMP forward
    la  a0, 1f
    li  a1, 53
    li  a2, 29
    li  x30, 0x745ae8d5
    mv  a4, x30
    add x0, x0, x1
    .word 0x10ffc12a    # JUMP a0
    .word 0x085ac00c    # add a1, a1, a2 << #0
    1: .word 0x0862c00b # add a1, a2, a1 << #0
    add x0, x0, x2
    li  a3, 82
    bne a3, a1, fail
    bne a4, x30, fail

    # JUMP.L forward
    la  a0, 2f
    li  a1, 53
    li  a2, 29
    add x0, x0, x1
    1: .word 0x11ffc12a # JUMP.L a0
    .word 0x085ac00c    # add a1, a1, a2 << #0
    2: .word 0x0862c00b # add a1, a2, a1 << #0
    add x0, x0, x2
    li  a3, 82
    bne a3, a1, fail
    la  a4, 1b
    bne a4, x30, fail

    # JUMP backward
    la  a0, 1f
    li  a1, 0x36a
    li  a2, 0x2c8
    j   2f
    .word 0x085ac00c    # add a1, a1, a2 << #0
    1: .word 0x0862c00b # add a1, a2, a1 << #0
    add x0, x0, x2
    j   3f
    2: add x0, x0, x1
    .word 0x10ffc12a    # JUMP a0
    3: li a2, 0x632
    bne a1, a2, fail

    # JUMP.L backward
    la  a0, 1f
    li  a1, 0x36a
    li  a2, 0x2c8
    j   2f
    .word 0x085ac00c    # add a1, a1, a2 << #0
    1: .word 0x0862c00b # add a1, a2, a1 << #0
    add x0, x0, x2
    j   4f
    2: add x0, x0, x1
    3: .word 0x11ffc12a # JUMP.L a0
    4: li a2, 0x632
    bne a1, a2, fail
    la  a3, 3b
    bne a3, x30, fail

    # ADD.A with Z=1, Beq predicted taken and taken
    li  a0, 3
    li  a1, 4
    mv  a2, zero
    add x0, x0, x1
    .word 0x0963004b    # add.a a2, a2, a1 >> #0
    .word 0xa0000001    # Beq PC+8
    .word 0x085a800a    # add a0, a1, a0 << #0
    .word 0x0852800b    # add a0, a0, a1 << #0
    add x0, x0, x2
    li  a2, 7
    bne a0, a2, fail

    # ADD.A with Z=0, Beq predicted taken but not taken
    li  a0, 3
    li  a1, 4
    li  a2, 5
    add x0, x0, x1
    .word 0x0963004b    # add.a a2, a2, a1 >> #0
    .word 0xa0000001    # Beq PC+8
    .word 0x085a800a    # add a0, a1, a0 << #0
    .word 0x0852800b    # add a0, a0, a1 << #0
    add x0, x0, x2
    li  a2, 11
    bne a0, a2, fail

    # ADDs that read r31
    mv  a0, zero
    add x0, x0, x1
    1: .word 0x0852c01f # add a1, a0, r31 << #0
    2: .word 0x08fb000a # add a2, r31, a0 << #0
    3: .word 0x08fb401f # add a3, r31, r31 << #0
    4: .word 0x08fb800a # add a4, r31, a0 << #0
    5: .word 0x0853c01f # add a5, a0, r31 << #0
    add x0, x0, x2
    la  a0, 1b
    bne a0, a1, fail
    la  a0, 2b
    bne a0, a2, fail
    la  a0, 3b
    addw    a0, a0, a0
    addw    a3, a3, zero
    bne a0, a3, fail
    la  a0, 4b
    bne a0, a4, fail
    la  a0, 5b
    bne a0, a5, fail

    # ADD that writes r31
    li  a0, 8
    la  a1, 1f
    li  a2, 13
    add x0, x0, x1
    1: .word 0x0857c00b # add r31, a0, a1 << #0
    .word 0x0853000c    # add a2, a0, a2 << #0
    .word 0x0863000a    # add a2, a2, a0 << #0
    add x0, x0, x2
    li  a3, 21
    bne a3, a2, fail

    # ADD that reads & writes r31
    li  a0, 8
    li  a2, 13
    add x0, x0, x1
    1: .word 0x0857c01f # add r31, a0, r31 << #0
    .word 0x0853000c    # add a2, a0, a2 << #0
    .word 0x0863000a    # add a2, a2, a0 << #0
    add x0, x0, x2
    li  a3, 21
    bne a3, a2, fail

    # STORE pc
    la  a0, temp_heap
    mv  a1, zero
    add x0, x0, x1
    1: STW(x31, a0, a1)
    add x0, x0, x2
    la  a2, 1b
    lwu a3, 0(a0)
    bne a2, a3, fail

    # STORE to [pc]
    la  a0, temp_heap
    la  a1, 1f
    sub a1, a0, a1
    add x0, x0, x1
    1: STW(a0, x31, a1)
    2: STW(x31, a1, x31)
    add x0, x0, x2
    lwu a1, 0(a0)
    bne a0, a1, fail
    lwu a1, 4(a0)
    la  a2, 2b
    bne a1, a2, fail

    # LOAD [pc]
    mv  a0, zero
    add x0, x0, x1
    1: LDW(a1, x31, a0)
    2: LDW(a2, a0, x31)
    add x0, x0, x2
    la  a0, 1b
    lwu a0, 0(a0)
    bne a1, a0, fail
    la  a0, 2b
    lwu a0, 0(a0)
    bne a2, a0, fail

    # LOAD to pc
    la  a2, temp_heap
    la  a3, 1f
    sw  a3, 0(a2)
    mv  a0, zero
    li  a1, 7
    add x0, x0, x1
    LDW(x31, a2, a0)
    ADD(a0, a1, a0)
    1: ADD(a0, a0, a1)
    add x0, x0, x2
    bne a0, a1, fail

pass:
    la  a0, pass_info
    jal ra, puts
    li  a0, 0
    j   exit

fail:
    la  a0, fail_info
    jal ra, puts
    li  a0, 1
    j   exit

.section .data;
pass_info: .string "passed\n"
fail_info: .string "failed\n"

.section .bss;
.align 8
temp_heap: .word 0, 0, 0, 0
