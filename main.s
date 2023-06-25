BITS 64
GLOBAL main

SECTION .bss
    digitSpace resb 5
SECTION .text
_start:
    .startofMain
        push r12                ; We want to use r12 for ourself
        mov rax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, msg            ;   message,
        mov rdx, msglen         ;   sizeof(message)
        syscall                 ; );

    ; Time to begin the timer work, Do note we shouldnt get to end
    ; r12 = time left (seconds)
    .cycleStart
        
        
    .workBegin
        mov r12, 1500           ; 25 minutes * 60 seconds == 1500
    .workLoopStart
        mov rax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, workmsg        ;   "Time to work, you have "",
        mov rdx, workmsglen     ;   sizeof(message)
        syscall
        call printR12
        mov rax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, trailmsg        ;   " seconds remaining \n",
        mov rdx, trailmsglen     ;   sizeof(message)
        syscall
        dec r12
        jge .workLoopStart
    .workEnd
        mov rax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, beepmsg        ;   "beep",
        mov rdx, beepmsglen     ;   sizeof(message)
        syscall
    .funBegin
        mov r12, 300           ; 5 minutes * 60 seconds == 300
    .funLoopStart
        mov rax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, breakmsg        ;   "Time to work, you have "",
        mov rdx, breakmsglen     ;   sizeof(message)
        syscall
        call printR12
        mov rax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, trailmsg        ;   " seconds remaining \n",
        mov rdx, trailmsglen     ;   sizeof(message)
        syscall
        dec r12
        jge .funLoopStart
    .funEnd
        mov rax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, beepmsg        ;   "beep",
        mov rdx, beepmsglen     ;   sizeof(message)
        syscall
        jmp .workBegin
    .end
        pop r12
        mov rax, 60       ; exit(
        mov rdi, 0        ;   EXIT_SUCCESS
        syscall           ; );

printR12:
    .printR12Start
    ; rdx = upper bits of dividend so first bits of x
    ; rax = lower bits of dividend so last bits of x
    ; rax = result
    ; rdx = remainder
        mov rcx, 1000
        mov rax, r12
        mov rdx, 0
        div rcx
        add rax, 48
        mov [digitSpace], al
        mov rcx, 100
        mov rax, rdx
        mov rdx, 0
        div rcx
        add rax, 48
        mov [digitSpace + 1], al
        mov rcx, 10
        mov rax, rdx
        mov rdx, 0
        div rcx
        add rax, 48
        add rdx, 48
        mov [digitSpace + 2], al
        mov [digitSpace + 3], dl
        mov byte [digitSpace + 4], 0
    .printR12ActuallyPrint
        mov rax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, digitSpace     ;   "{number},
        mov rdx, 5              ;   sizeof(message)
        syscall
        ret
    
    

section .rodata
    workmsg: db "Time to work, you have "
    workmsglen: equ $ - workmsg
    breakmsg: db "Time to relax, you have "
    breakmsglen: equ $ - breakmsg
    trailmsg: db " seconds remaining.", 10
    trailmsglen: equ $ - trailmsg
    msg: db "MIT Licenced, see https://github.com/joecwilson/tinyTimer for details.", 10
    msglen: equ $ - msg
    beepmsg: db "Finished a cylcle, Notifing", 7, 10
    beepmsglen: equ $ - beepmsg
