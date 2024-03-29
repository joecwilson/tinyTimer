BITS 64
GLOBAL main

SECTION .text
_start:
    .setUpStart:
        push r12                ; We want to use r12 for ourself
        sub rsp, 16

        mov word [rsp], 1
        mov word [rsp + 8], 0
    .printHeaderInfo:
        
        mov ax, 1              ; write(
        mov di, 1              ;   STDOUT_FILENO,
        mov rsi, msg            ;   message,
        mov dx, msglen         ;   sizeof(message)
        syscall                 ; );

    ; Time to begin the timer work, Do note we shouldnt get to end
    ; r12 = time left (seconds)
    .cycleStart:
    .workBegin:
        mov r12, 1500           ; 25 minutes * 60 seconds == 1500
    .workLoopStart:
        mov ax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, workmsg        ;   "Time to work, you have "
        mov dx, workmsglen     ;   sizeof(message)
        syscall
        call printR12
        mov ax, 1              ; write(
        mov di, 1              ;   STDOUT_FILENO,
        mov rsi, trailmsg        ;   " seconds remaining \n",
        mov dx, trailmsglen     ;   sizeof(message)
        syscall
        ; Now we have to sleep
        mov ax, 35             ; Nanosleep syscall number
        lea rdi, [rsp]
        lea rsi, [rsp + 8]
        syscall
        dec r12
        jge .workLoopStart
    .workEnd:
        mov ax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, beepmsg        ;   "beep",
        mov dx, beepmsglen     ;   sizeof(message)
        syscall
    .funBegin:
        mov r12, 300           ; 5 minutes * 60 seconds == 300
    .funLoopStart:
        mov ax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, breakmsg        ;   "Time to work, you have "",
        mov dx, breakmsglen     ;   sizeof(message)
        syscall
        call printR12
        mov ax, 1              ; write(
        mov di, 1              ;   STDOUT_FILENO,
        mov rsi, trailmsg        ;   " seconds remaining \n",
        mov dx, trailmsglen     ;   sizeof(message)
        syscall
        mov rax, 35             ; Nanosleep syscall number
        lea rdi, [rsp]
        lea rsi, [rsp + 8]
        syscall
        dec r12
        jge .funLoopStart
    .funEnd:
        mov ax, 1              ; write(
        mov rdi, 1              ;   STDOUT_FILENO,
        mov rsi, beepmsg        ;   "beep",
        mov dx, beepmsglen     ;   sizeof(message)
        syscall
        jmp .workBegin

printR12:
    .printR12Prolouge:
        sub rsp, 5
    .printR12Start:
    ; dx = upper bits of dividend so first bits of x
    ; ax = lower bits of dividend so last bits of x
    ; ax = result
    ; dx = remainder
        mov cx, 1000
        mov rax, r12
        mov dx, 0
        div cx
        add ax, 48
        mov [rsp], al
        mov cx, 100
        mov ax, dx
        mov dx, 0
        div cx
        add ax, 48
        mov [rsp + 1], al
        mov cx, 10
        mov ax, dx
        mov dx, 0
        div cx
        add ax, 48
        add dx, 48
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
    workmsg: db 13, "Time to work, you have "
    workmsglen: equ $ - workmsg
    breakmsg: db 13, "Time to relax, you have "
    breakmsglen: equ $ - breakmsg
    trailmsg: db " seconds remaining. "
    trailmsglen: equ $ - trailmsg
    msg: db "MIT Licenced, see https://github.com/joecwilson/tinyTimer for details.", 10
    msglen: equ $ - msg
    beepmsg: db 13 ,"Finished a cylcle, Notifing", 7
    beepmsglen: equ $ - beepmsg
