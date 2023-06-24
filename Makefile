build:
	nasm -f elf64 -o main.o main.s
	gcc -s -o tinyPomodoroTimer main.o -Wall