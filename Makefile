build:
	nasm -f elf64 -o main.o main.s
	ld -o tinyPomodoroTimer main.o