.include "macros.S"  # подключение файла с макроопределениями

.data
n: 	.long 2345      # int n = 2345; число
length: .long 0         # int length =0; результат
ten: 	.long 10        # определяем константу ЯВНО 

.text # секция команд процесора 
.global _start 	# точка входа - глобальная метка

_start: 	
  nop             # пустая операция - no operation
  movl $0, %ebx   # counter = 0; счетчик делений
	movl n, %eax    # готовим деление  
nextdigit:
  movl  $0, %edx
  idivl ten
  incl %ebx

  cmpl $0, %eax    # частное < 0 ?
  jg   nextdigit   # НЕТ, продолжаем
  movl %ebx, length  # length = counter; ДА,сохраняем результат 
  Exit            # конец работы,       
.end
