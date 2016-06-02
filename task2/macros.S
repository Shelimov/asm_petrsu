.macro Exit
  movl $1, %eax
  movl $0, %ebx
  int $0x80
.endm

.macro Write str, len
  movl $4, %eax
  movl $1, %ebx
  movl \str, %ecx
  movl \len, %edx
  int $0x80
.endm

.macro Read buffer, len
  movl $3, %eax
  movl $0, %ebx
  movl \buffer, %ecx
  movl \len, %edx
  int $0x80
.endm
