program = main
macros_file = macros.S
$(program): $(program).o
	ld -m elf_i386 $(program).o -o $(program)
$(program).o: $(program).S $(macros_file)
	as --32 -gstabs+ -ahlsm=$(program).list -o $(program).o $(program).S