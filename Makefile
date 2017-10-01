all: fizzbuzz.asm
	nasm -f elf32 fizzbuzz.asm
	ld -m elf_i386 -o fizzbuzz fizzbuzz.o -lc -I/lib/ld-linux.so.2 -L /usr/lib32
