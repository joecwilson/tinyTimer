build:
	nasm -f elf64 -o main.o main.s
	ld -s -o tinyPomodoroTimer main.o