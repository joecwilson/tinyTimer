# Introduction

This is a pomodoro timer that fits in a B64 encoded qr code

## Running the program

If given the binary as a binary simply run said binary. However if given as a qr code, you first have to decode the base64 file into a binary and can run said binary.

## Compiling the program

### Prerequisites for creating the binary

- make
- nasm
- ld

### Prerequisites for creating the qr encode

- base64
- qrencode

To compile run `make build`, while to create the qr code run `make qrcode`

## Sources

This project would not have been possible without the use of [A Whirlwind Tutorial on Creating Really Teensy ELF Executables for Linux](https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html)
