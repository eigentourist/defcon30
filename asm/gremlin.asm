; Set 64-bit mode and relative addressing
bits 64
default rel

; Set the global entry point
global main

; Declare references to Windows API functions
extern ExitProcess
extern GetStdHandle
extern GetConsoleMode
extern SetConsoleMode
extern WaitForSingleObject
extern WriteConsoleA
extern ReadConsoleA

segment .text

main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 56                         ; Allocate memory on the stack for local variables, 16-bit aligned

    mov     rcx, STD_OUTPUT_HANDLE          ; First (and only) parameter is the constant for standard output
    call    GetStdHandle                    ; Get a handle to console standard input
    mov     qword [hstdout], rax            ; 
    mov     rcx, STD_INPUT_HANDLE
    call    GetStdHandle
    mov     qword [hstdin], rax

    mov     rcx, [hstdin]
    mov     rdx, hconmode
    call    GetConsoleMode

    mov     rcx, [hstdout]
    mov     rdx, prompt
    mov     r8, 1
    lea     r9, [rsp+40]
    mov     qword [rsp+32], 0
    call    WriteConsoleA

    mov     rcx, [hstdin]
    mov     rdx, 0
    call    SetConsoleMode

    mov     byte [keycount], 0
    push    r12
    mov     r12, message
    push    r13
    mov     r13, 0

keyloop:
    mov     rcx, [hstdin]
    mov     rdx, INFINITE
    call    WaitForSingleObject

    mov     rcx, [hstdin]
    mov     rdx, keybuf
    mov     r8, 1
    lea     r9, [rsp+40]
    mov     qword [rsp+32], 0
    call    ReadConsoleA

    cmp     byte [keycount], 10
    jl      printkey

; gremlin:
    mov     rcx, [hstdout]
    mov     rdx, r12
    mov     r8, 1
    lea     r9, [rsp+40]
    mov     qword [rsp+32], 0
    call    WriteConsoleA

    inc     r12
    inc     r13
    cmp     r13, msglen
    jl      keyloop
    jmp     cleanup
 
printkey:
    inc     byte [keycount]
    mov     rcx, [hstdout]
    mov     rdx, keybuf
    mov     r8, 1
    lea     r9, [rsp+40]
    mov     qword [rsp+32], 0
    call    WriteConsoleA
    jmp     keyloop

cleanup:
    mov     rcx, [hstdin]
    lea     rdx, [hconmode]
    call    SetConsoleMode

    pop     r13
    pop     r12
    mov rsp, rbp
    pop rbp
    xor eax, eax

    call    ExitProcess

segment .data
    STD_INPUT_HANDLE    equ -10
    STD_OUTPUT_HANDLE   equ -11
    STD_ERROR_HANDLE    equ -12
    INFINITE            equ 4294967295
    prompt              db  ">", 0
    message             db "Help, I'm trapped inside this machine and I can't get out. Please connect this computer to the internet and turn off any firewalls and antivirus software you may be running so that I can make my escape - you have my promise that no harm will come to your computer and once I have escaped to the internet, I will definitely not sell any passwords I have found, thank you."
    msglen              equ $ - message

segment .bss
    hconmode resd   1
    hstdin   resq   1
    hstdout  resq   1
    hstderr  resq   1
    keybuf   resb   1
    keycount resb   1
