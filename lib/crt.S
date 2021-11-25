#define STACK_SIZE 4096

.section .text.init;
.global _start;
_start:
	la  sp, stack_top
	jal main
	j   exit

.global exit;
exit:
	mv	a1, a0	# retval should be placed in a1, not a0
	li	a0, 93
	jal	syscall
	unimp

.section ".tohost", "aw", @progbits
.align 6
.globl tohost
tohost: .dword 0
.align 6
.globl fromhost
fromhost: .dword 0

.section .bss;
.skip STACK_SIZE
.align 8
stack_top: .dword 0
