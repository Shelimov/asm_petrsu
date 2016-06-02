# Программа ввода кодов цифровых символов в буфер и вывода сообщений в стандартный вывод.
 

.include "macros.S"
.data
    sum: .word 0
    sym: .byte 0
.text
.global _start

_start:
    nop
show_prompt:
    Puts "Вводите цифры для суммирования до символа конца строки!" 	# макровызов вывода строки на стандартный

kbd_input:
    push %eax
    Getchar $sym          # макровызов ввода символа со стандартного ввода
    cmpl $0, %eax 	# Конец файл - EOF (введено 0 символов) ? 
    pop %eax
    je print_sum		# Да - на завершение программы
    
    cmpb $'\n', sym	# это символ перевода строки ?
    je parse_char
    cmpb $'9', sym 	# код больше кода символа '9' ?
    ja print_err_msg	# ДА - на вывод сообщения об ошибке
    cmpb $'0', sym	# код меньше кода символа '0' ?
    jb print_err_msg	# ДА - на вывод сообщения об ошибке

    movl $0, %eax
    movb sym, %al
    subb $'0', %al
parse_char:
    addw %ax, sum
    movl $0, %eax
    jc print_full_msg
    jmp kbd_input

print_full_msg:
    Puts "Буфер суммы переполнен. Завершение программы."
    jmp stop

print_err_msg:
    Puts "Не цифровая клавиша. Повторите ввод"	# вывод сообщения об ошибке
    jmp show_prompt 	# на ввод следующего символа

print_sum:
    movb $0, %bl # bl counter
    movw sum, %ax
    movw $10, %cx
convert:    
    movw $0, %dx
    idivw %cx
    incb %bl
    push %dx
    cmpw $0, %ax
    jg convert # reminder > 0
    # reminder == 0
    xor %eax, %eax
print_digit:
    cmpb $0, %bl
    je stop
    pop %ax
    decb %bl
    addw $'0', %ax
    movb %al, sym
    push %ebx
    Putdigit $sym
    pop %ebx
    jmp print_digit
stop:
    # Puts char
    Exit $0
    
.end
