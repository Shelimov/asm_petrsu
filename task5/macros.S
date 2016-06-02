.macro Exit ret_val
	movl $1, %eax 		# номер сист. вызова exit
	movl \ret_val, %ebx 	# код выхода
	int $0x80 		# выполнить системный вызов
.endm

.macro Getchar buf_addr
	movl $3, %eax		# номер сист. вызова read
	movl $0, %ebx		# параметр 1: дескриптор стандартного ввода
	movl \buf_addr, %ecx	# параметр 2: адрес буфера (он же - фактический 
	     			# параметр макровызова)
	movl $1, %edx		# параметр 3: количество байтов для чтения
	int $0x80		# выполнить системный вызов
.endm

.macro Puts string
.data
    str\@: 	.ascii "\string\n"  # формирование фактической строки для вывода
	
    strlen\@ = 	. - str\@           # получение значения длины строки

.text
	movl $4, %eax		# номер сист. вызова write
	movl $1, %ebx		# параметр 1: дескриптор стандартного вывода	
	movl $str\@, %ecx	# параметр 2: адрес памяти с выводимыми символами
	movl $strlen\@, %edx 	# параметр 3: количество байтов для вывода
	int $0x80		# выполнить системный вызов
.endm

.macro CalcN n
.text
	mov %esi, %eax # кол-во символов в строке в eax
	mov $-1, %ebx # счетчик в ebx
	add $\n, %ebx
calcloop\n:
	cmp %ebx, %eax # сравниваем счетчик ebx и eax
	jl endcalc\n
	mov %ebx, %esi
	movb buf(%esi), %cl
	addb %cl, sum\n
	add $\n, %ebx
	jmp calcloop\n
endcalc\n:
	mov %eax, %esi
.endm

.macro PrintNumber number
.data
	symbol\@: .byte 0
.text
	pusha

	movb $0, %bl # bl counter
    movw \number, %ax
    movw $10, %cx
convert\@:    
    movw $0, %dx
    idivw %cx
    incb %bl
    push %dx
    cmpw $0, %ax
    jg convert\@ # reminder > 0
    # reminder == 0
    xor %eax, %eax
print_digit\@:
    cmpb $0, %bl
    je end\@
    pop %ax
    decb %bl
    addw $'0', %ax
    movb %al, symbol\@
    push %ebx
    movl $4, %eax		# номер сист. вызова write
	movl $1, %ebx		# параметр 1: дескриптор стандартного вывода	
	movl $symbol\@, %ecx	# параметр 2: адрес памяти с выводимыми символами
	movl $1, %edx 	# параметр 3: количество байтов для вывода
	int $0x80		# выполнить системный вызов
    pop %ebx
    jmp print_digit\@
end\@:
	popa
.endm
