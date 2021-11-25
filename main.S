.section .text;

.global main
main:

    # ADD.A with SG=0 then Bsg ineffective

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
