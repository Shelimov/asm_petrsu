# Программа ввода кодов цифровых символов в буфер и вывода сообщений в стандартный вывод.
 

.include "macros.S"
.bss 
    .lcomm buf, 100
.data
    sym: .byte 0
    div2: .byte 2
    div3: .byte 3
    div4: .byte 4
    div8: .byte 8
    sum2: .short 0
    sum3: .short 0
    sum4: .short 0
    sum8: .short 0

.text
.global _start

_start:
    sub %esi, %esi

kbd_input:
    cmp $99, %esi
    je print_full_msg
    Getchar $sym          # макровызов ввода символа со стандартного ввода
    cmpl $0, %eax 	# Конец файл - EOF (введено 0 символов) ? 
    je finish		# Да - на завершение программы
    
    cmpb $'\n', sym	# это символ перевода строки ?
    je finish
    cmpb $'9', sym 	# код больше кода символа '9' ?
    ja kbd_input	# ДА - на вывод сообщения об ошибке
    cmpb $'0', sym	# код меньше кода символа '0' ?
    jb kbd_input	# ДА - на вывод сообщения об ошибке

    movb sym, %al
    subb $'0', %al
    movb %al, buf(%esi)
    inc %esi
    jmp kbd_input

print_full_msg:
    Puts "Буфер чисел полный. Вывод и завершение программы."
    jmp finish

finish:
    CalcN 2
    CalcN 3
    CalcN 4
    CalcN 8
    Puts "Сумма цифр по 2кратным позициям"
    PrintNumber sum2
    Puts ""
    Puts "Сумма цифр по 3кратным позициям"
    PrintNumber sum3
    Puts ""
    Puts "Сумма цифр по 4кратным позициям"
    PrintNumber sum4
    Puts ""
    Puts "Сумма цифр по 8кратным позициям"
    PrintNumber sum8
    Puts ""
    Exit $0
stop:
    # Puts char
    Exit $0
    
.end
