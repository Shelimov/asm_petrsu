program = func
$(program): $(program).o
	ld -m elf_i386 $(program).o -o $(program)
$(program).o: $(program).S macros.S
	as --32 -gstabs+ -o $(program).o $(program).S