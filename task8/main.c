#include <stdio.h>
extern void Read_Sym(int* result, char* first, int n);
extern int Sum(int* from, int n);

int main() 
{
	char symbols[] = "91A23B456C789";
	int buffer[10];
	Read_Sym(buffer, symbols, 8);
	printf("%d", Sum(buffer, 8));
	return 0;
}