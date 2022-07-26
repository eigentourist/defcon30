bits 64
default rel

segment .data
    msg db "Hello, World!", 0xd, 0xa, 0

segment .text
global main
extern ExitProcess
extern _CRT_INIT

extern printf

main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    call    _CRT_INIT

    lea     rcx, [msg]
    call    printf

    xor     rax, rax
    call    ExitProcess
    