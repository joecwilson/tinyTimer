BITS 64
GLOBAL main
SECTION .text
main:
    mov rax, 1        ; write(
    mov rdi, 1        ;   STDOUT_FILENO,
    mov rsi, msg      ;   message,
    mov rdx, msglen   ;   sizeof(message)
    syscall           ; );

    mov rax, 60       ; exit(
    mov rdi, 0        ;   EXIT_SUCCESS
    syscall           ; );

section .rodata
    workmsg: db "Time to work, you have "
    workmsglen: equ $ - workmsg
    breakmsg: db "Time to relax, you have "
    breakmsglen: equ $ - breakmsg
    trailmsg: db " seconds remaining.", 10
    trailmsglen: equ $ - trailmsg
    msg: db "MIT Licenced, see <Link> for details.", 10
    msglen: equ $ - msg