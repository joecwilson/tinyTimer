BITS 64
GLOBAL main

SECTION .text
_start:
    .setUpStart:
        sub rsp, 16

        mov qword [rsp], 1
        mov qword [rsp + 8], 0
    .printHeaderInfo:
        push r12                ; We want to use r12 for ourself
        mov rax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, msg            ;   message,
        mov rdx, msglen         ;   sizeof(message)
        syscall                 ; );

    ; Time to begin the timer work, Do note we shouldnt get to end
    ; r12 = time left (seconds)
    .cycleStart:
    .workBegin:
        mov r12, 1500           ; 25 minutes * 60 seconds == 1500
    .workLoopStart:
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
        ; Now we have to sleep
        mov rax, 35             ; Nanosleep syscall number
        lea rdi, [rsp + 8]
        lea rsi, [rsp + 16]
        syscall
        dec r12
        jge .workLoopStart
    .workEnd:
        mov rax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, beepmsg        ;   "beep",
        mov rdx, beepmsglen     ;   sizeof(message)
        syscall
    .funBegin:
        mov r12, 300           ; 5 minutes * 60 seconds == 300
    .funLoopStart:
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
        mov rax, 35             ; Nanosleep syscall number
        lea rdi, [rsp + 8]
        lea rsi, [rsp + 16]
        syscall
        dec r12
        jge .funLoopStart
    .funEnd:
        mov rax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, beepmsg        ;   "beep",
        mov rdx, beepmsglen     ;   sizeof(message)
        syscall
        jmp .workBegin
    .end:
        pop r12
        add rsp, 16
        mov rax, 60       ; exit(
        mov rdi, 0        ;   EXIT_SUCCESS
        syscall           ; );

printR12:
    .printR12Prolouge:
        sub rsp, 5
    .printR12Start:
    ; rdx = upper bits of dividend so first bits of x
    ; rax = lower bits of dividend so last bits of x
    ; rax = result
    ; rdx = remainder
        mov rcx, 1000
        mov rax, r12
        mov rdx, 0
        div rcx
        add rax, 48
        mov [rsp], al
        mov rcx, 100
        mov rax, rdx
        mov rdx, 0
        div rcx
        add rax, 48
        mov [rsp + 1], al
        mov rcx, 10
        mov rax, rdx
        mov rdx, 0
        div rcx
        add rax, 48
        add rdx, 48
        mov [rsp + 2], al
        mov [rsp + 3], dl
    .printR12ActuallyPrint:
        mov rax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, rsp            ;   "{number},
        mov rdx, 5              ;   sizeof(message)
        syscall
    .printR12Epilouge:
        add rsp, 5
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
