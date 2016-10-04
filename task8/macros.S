.macro Exit ret_val
	movl $1, %eax 		# номер сист. вызова exit
	movl \ret_val, %ebx 	# код выхода
	int $0x80 		# выполнить системный вызов
.endm

.macro Finish
	Exit $0
.endm
