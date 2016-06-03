module = fn
program = main
$(program): $(program).o $(module).o
	gcc -m32 -gstabs+ -o $(program) $(program).o $(module).o
$(program).o: $(program).c
	gcc -c -m32 -gstabs+ -o $(program).o $(program).c
$(module).o: $(module).S
	as --32 -gstabs+ -o $(module).o $(module).S