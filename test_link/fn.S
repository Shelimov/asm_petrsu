.text
.type sum, @function
.globl sum
sum:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%esp), %eax
	movl 12(%esp), %ebx
	addl %ebx, %eax
	pop %ebp
	ret
