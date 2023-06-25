build:
	nasm -f elf64 -o main.o main.s
	ld -s -o tinyPomodoroTimer main.o -n
	rm main.o


clean:
	rm tinyPomodoroTimer
	rm qrcode.png

qrcode: build
	base64 tinyPomodoroTimer > b64encoded.txt
	qrencode -o qrcode.png -8 -r b64encoded.txt
	rm base64encoded.txt