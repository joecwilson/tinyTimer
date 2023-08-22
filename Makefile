build:
	nasm -f elf64 -o main.o main.s
	ld -s -o tinyPomodoroTimer main.o -n
	rm main.o


debug:
	nasm -f elf64 -o main.o -g main.s
	ld  -o debug_timer main.o -n
	rm main.o
	# gdb ./debug_timer


clean:
	rm tinyPomodoroTimer
	rm qrcode.png

qrcode: build
	base64 tinyPomodoroTimer > b64encoded.txt
	qrencode -o qrcode.png -8 -r b64encoded.txt
	rm b64encoded.txt