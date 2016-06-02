.include "macros.S"
.data
	vector: .long 0, 0, 0, 0, 0, 0
	matrix: .long 11, 12, 13, 14, 15, 16
			.long 21, 22, 23, 24, 25, 26
			.long 31, 32, 33, 34, 35, 36
			.long 41, 42, 43, 44, 45, 46
			.long 51, 52, 53, 54, 55, 56
			.long 61, 62, 63, 64, 65, 66
	k: .byte -1
	l: .byte -1
	sym: .byte 0
	_out: .short 0
.text
.global _start

_start:
    sub %esi, %esi
    Puts "Введите значения K и L в диапозоне от 1 до 6"
kbd_input:
    Getchar $sym          # макровызов ввода символа со стандартного ввода
    cmpl $0, %eax 	# Конец файл - EOF (введено 0 символов) ? 
    je finish		# Да - на завершение программы
    
    cmpb $'\n', sym	# это символ перевода строки ?
    je kbd_input
    cmpb $'9', sym 	# код больше кода символа '9' ?
    ja kbd_input
    cmpb $'0', sym	# код меньше кода символа '0' ?
    jb kbd_input	# ДА - на вывод сообщения об ошибке

    movb sym, %al
    subb $'0', %al
    cmpb $6, %al
	ja print_error_msg
	cmpb $1, %al
	jb print_error_msg
   	cmpb $-1, k
   	je set_k
	jmp set_l   	

set_k:
	movb %al, k
	jmp kbd_input

set_l:
	movb %al, l
	jmp fill_vector

print_error_msg:
    Puts "Значения не попадают в диапозон от 1 до 6"
    Puts "Повторите ввод"
    movb $-1, k
    movb $-1, l
    jmp kbd_input

fill_vector:
	decb k # y, i
	decb l # i, x
	sub %esi, %esi

	movb $0, %al # i = 0
	movl $6, %esi
	push %eax
	sub %eax, %eax
	movb k, %al
	imul %eax, %esi # 6 * k
	pop %eax
	movl $0, %edx
	movb l, %dl
	
fv_loop:
	cmpb $6, %al
	je print_vector
	movl matrix(, %esi ,4), %ebx # ebx = matrix + (6 * k + i => esi)*4
	movl matrix(, %edx ,4), %ecx
	addl %ecx, %ebx
	subl %ecx, %ecx
	movb %al, %cl
	movl %ebx, vector(, %ecx, 4)

	incl %esi
	addb $6, %dl
	incb %al
	jmp fv_loop

print_vector:
	movl $0, %eax
pv_loop:
	mov vector(, %eax, 4), %ebx
	mov %bx, _out
	PrintNumber _out
	Puts ""
	inc %eax
	cmpl $6, %eax
	jne pv_loop
finish:
    Exit $0
    
.end
