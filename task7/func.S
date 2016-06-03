.include "macros.S" # подключение файла с макроопределениями
.data # секция данных, распределение памяти
Symbols:
        .asciz  "91A23B456C789" # массив символьных кодов
.bss    # секция общей памяти (для результата)
.lcomm  Numbers, 40             # массив 4-х байтовых значений цифр
.text # секция команд процесора


.type   Read_Sym, @function     # функция циклической обработки массива
#    Читает <Параметр1> символов из массива <Параметр2>
#    и передает их на обработку функции Trans_Sym.
#    Результат размещается в массив Numbers
#    Стандартный пролог фунции
Read_Sym:
    pushl %ebp
    movl %esp, %ebp 

    subl $4, %esp
    movl $0, %eax
    movl %eax,-4(%ebp)
    subl %ecx, %ecx   # инициализация счетчика цикла 
NextSym:
    movl 12(%ebp), %edx  # адрес второго параметра-массива в edx
    subl %ebx, %ebx             # подготовка ebx для записи символа
    movb (%edx,%ecx,1), %bl     # символ в ebx
    cmpb $'0', %bl
    jb inc_non_digit
    cmpb $'9', %bl
    ja inc_non_digit
    jmp rs_start
inc_non_digit:
    incl -4(%ebp)
    incl %ecx
    cmpl 8(%ebp), %ecx
    jne NextSym
    jmp rs_end
rs_start:
    pusha   # сохранить регистры текущей функции Read_Sym
    pushl %ebx  # Параметр функции Trans_Sym (код 
                # символа из массива) в стек
    call Trans_Sym
    addl $4, %esp      # очистить стек от параметров Trans_Sym
    movl %eax, Numbers(,%ecx,4) # записать результат Trans-Sym
    popa   # восстановть регистры Read_Sym
    incl %ecx            # наращиваем счетчик цикла
    cmpl 8(%ebp), %ecx   # счетчик равен первому параметру?
    jne NextSym          # ДА, повторяем
                         # НЕТ - выходим из цикла
rs_end:
    movl -4(%ebp), %eax
    movl %ebp, %esp # восстановить указатель стека
    popl %ebp       # восстановить ebp
    ret             # возврат в вызывающую
# конец Read_Sym
#    Функция преобразования кода символа в числовое значение
#    <Пареметр1> преобразуется в число и возвращается в eax */

.type   Trans_Sym, @function
Trans_Sym:
    pushl %ebp
    movl %esp, %ebp
    
    movl 8(%ebp), %eax  # параметр в eax
    subl $'0', %eax    # получение числового значения
    
    movl %ebp, %esp # восстановить указатель стека
    popl %ebp       # восстановить ebp
    ret

.global _start # точка входа - глобальная метка
_start:
    nop
    pusha
    pushl $Symbols
    pushl $10
    call Read_Sym
    addl $8,%esp
    popa

    Finish
.end   # последняя строка исходного текста
