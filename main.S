.section .text;

.global main
main:
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
