int main() {
	// пусть a ~ %eax, b ~ %ebx
	int a, b = 1;

	for (a = 5; a != 0; a--) {
		b *= a;
	}

	return 0;
}