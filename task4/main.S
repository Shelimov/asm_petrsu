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
    Puts "Сумма цифр"
    PrintNumber sum
stop:
    # Puts char
    Exit $0
    
.end
