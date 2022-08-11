default rel
bits 64


segment .text

global main
global factorial

extern _CRT_INIT
extern ExitProcess
extern printf


factorial:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32
    
    test    ecx, ecx
    jz     .zero
    
    mov    ebx, 1       ; counter c
    mov    eax, 1       ; result

    inc    ecx

.for_loop:
    cmp    ebx, ecx
    je     .end_loop

    mul    ebx          ; multiply ebx * eax and store in eax

    inc    ebx          ; ++c
    jmp    .for_loop

.zero:
    mov    eax, 1

.end_loop:
    leave
    ret

main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    mov     rcx, [num]
    call    factorial

    lea     rcx, [fmt]
    mov     rdx, [num]
    mov     r8, rax
    call    printf

    xor     rax, rax
    call    ExitProcess

segment .data
    num dd 5
    fmt db "Factorial of %d is: %llu", 0xd, 0xa, 0
