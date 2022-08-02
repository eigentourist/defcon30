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
                                            ; Full explanation, courtesy of Michael Petch on Stack Overflow:
                                            ; ======================================================================
                                            ; In order to be compliant with the 64-bit Microsoft ABI you must maintain
                                            ; the 16 byte alignment of the stack pointer prior to calling a WinAPI or 
                                            ; C library function. Upon calling the main function the stack pointer (RSP) 
                                            ; was 16 byte aligned. At the point the main function starts executing 
                                            ; the stack is misaligned by 8 because the 8 byte return address was pushed 
                                            ; on the stack. 48+8=56 doesn't get you back on a 16 byte aligned stack 
                                            ; address (56 is not evenly divisible by 16) but 56+8=64 does. 64 is evenly 
                                            ; divisible by 16.
                                            ; https://stackoverflow.com/questions/63979023/repeated-call-of-writeconsole-nasm-x64-on-win64

    mov     rcx, STD_OUTPUT_HANDLE          ; First (and only) parameter is the constant for standard output
    call    GetStdHandle                    ; Get a handle to console standard input
    mov     qword [hstdout], rax            ; 
    mov     rcx, STD_INPUT_HANDLE           ; Prepare to get a handle to console standard input
    call    GetStdHandle                    ; Get the handle, which comes back stored in rax
    mov     qword [hstdin], rax             ; Store the handle in our hstdin variable, allocated below

    mov     rcx, [hstdout]                  ; Load the handle for stdout as our 1st parameter
    mov     rdx, prompt                     ; Load the address of our prompt character as our 2nd parameter
    mov     r8, 1                           ; Load the length of the string we want to sent to stdout (1 character)
    lea     r9, [rsp+8]                     ; Load the address of a spot in our local variable space to store chars written
    mov     qword [rsp], 0                  ; Store a quad word (8 bytes) with the value zero next to the above local variable
    call    WriteConsoleA                   ; Print the prompt character

    mov     rcx, [hstdin]                   ; We are going to change the mode for console input so that it does not echo characters
    mov     rdx, hconmode                   ; typed on the keyboard. So, we load the handle for stdin and the address of a variable to
    call    GetConsoleMode                  ; hold the current console mode as 1st and 2nd parameters, then get the current console mode.
                                            ; The value for the current console mode is now stored in our hconmode variable below.

    mov     rcx, [hstdin]                   ; Now that we have saved the current input console mode, we make a change that stops
    mov     rdx, 0                          ; characters typed on the keyboard from being echoed back on the console. When we exit,
    call    SetConsoleMode                  ; we will restore the input console mode based on the value we saved in hconmode.

    mov     byte [keycount], 0              ; Initialize our key press counter
    push    r12                             ; Save whatever is in r12 on the stack
    mov     r12, message                    ; Load the starting address of our "Help me" message into r12
    push    r13                             ; Save the contents of r13 on the stack
    mov     r13, 0                          ; Initialize r13 to zero

keyloop:
    mov     rcx, [hstdin]                   ; This technique uses a Windows call (WaitForSingleObject) to allow us to capture a
    mov     rdx, INFINITE                   ; keypress as soon as it happens, without waiting for the user to hit Enter. This way,
    call    WaitForSingleObject             ; we get the chance to react to every single keystroke that comes from the keyboard.

    mov     rcx, [hstdin]                   ; Once a key has been pressed, we set up a call to read that one character from standard input.
    mov     rdx, keybuf                     ; The character will be stored into a single byte variable we have declared below (keybuf).
    mov     r8, 1                           ; Here we specify how many characters we want to read from stdin (just one)
    lea     r9, [rsp+8]                     ; Now we pass the address of our local stack-based variable to hold the number of characters read
    mov     qword [rsp], 0                  ; And finally we pass in a quadword-sized zero in the final reserved parameter that we
    call    ReadConsoleA                    ; aren't allowed to use, and subsequently we call ReadConsole.
                                            ; Note that we are calling the ANSI (single-byte) version of ReadConsole, which assures
                                            ; that any character code we get will only be one byte in size -- so we only need one
                                            ; byte to store it.

    cmp     byte [keycount], 10             ; Check our key counter to see if we have read ten characters from the keyboard yet
    jl      printkey                        ; If we're still fewer than we read, don't do mischief yet- just print the character.

; gremlin:
    mov     rcx, [hstdout]                  ; We hit this code if we have reached ten characters on our counter. Now, we ignore anything
    mov     rdx, r12                        ; the user types, and on each keystroke, we echo back a character from our "Help me" message.
    mov     r8, 1                           ; Here we are setting up a WriteConsole call that will print that one character from our message.
    lea     r9, [rsp+8]                     ; As always, we load the stdout handle as our 1st param, the address of the character to print as
    mov     qword [rsp], 0                  ; our 2nd param, the number of chars to print (1) as our 3rd, the address of our local unnamed variable
    call    WriteConsoleA                   ; to hold the number of characters printed as our 4th, and a zero for the final reserved parameter.
                                            ; As usual, we place this 5th parameter (a zero quadword) at the top of the stack, according to Microsoft
                                            ; 64-bit fastcall convention for parameter passing (try the URl below for a full description.)
                                            ; https://docs.microsoft.com/en-us/cpp/build/x64-calling-convention?view=msvc-170#parameter-passing

    inc     r12                             ; Increment r12, which is being used as an index into our "help me" message buffer
    inc     r13                             ; Increment r13, which we are using as a counter of the number of buffer characters we have printed
    cmp     r13, msglen                     ; Compare the number of characters we have printed to the length of our "help me" message
    jl      keyloop                         ; If we haven't printed that many characters yet, keep on reading keypresses from the user
    jmp     cleanup                         ; Otherwise, we're done, so jump to our cleanup-and-exit code.
 
printkey:
    inc     byte [keycount]                 ; We reach this code if we've been reading keypresses but haven't read ten of them yet. So, we
    mov     rcx, [hstdout]                  ; increment our keycount variable, then set up a call to print the character of the key the user
    mov     rdx, keybuf                     ; pressed. Again, we follow MS x64 fastcall convention for parameter passing: first four params
    mov     r8, 1                           ; in rcx, rdx, r8 and r9, and any furthers pushed onto the stack, in reverse order. We push those
    lea     r9, [rsp+8]                     ; params in reverse order so that when they get read back off the stack, they come back out in
    mov     qword [rsp], 0                  ; the correct order, because the stack is LIFO (last In, First Out.)
    call    WriteConsoleA                   ; Now we print the character the user typed, and then jump back to keep reading keypresses.
    jmp     keyloop

cleanup:                                    ; If we are here, it's because we've finished printing all the characters from our "help me" message.
    mov     rcx, [hstdin]                   ; Now we restore the console mode to what it was before we changed it to non-echo mode. We do this by
    lea     rdx, [hconmode]                 ; loading the handle to stdin, and the mode value from hconmode where we saved it earlier, 
    call    SetConsoleMode                  ; and calling the SetConsoleMode function again.

    pop     r13                             ; Finally, we restore r13 and r12 to the values they had before we started using them as index and counter
    pop     r12                             ; for our message output. After that, we set the top of the stack back to what it was by restoring it from
    mov rsp, rbp                            ; rbp, where we saved it. Finally, we set eax, which holds the return value for our program (or subroutine,
    pop rbp                                 ; if this were part of a larger program) to zero, indicating no errors occurred. We could have just said
    xor eax, eax                            ; mov eax, 0 instead of xor, but xor is what all the cool kids do (and it may be a bit faster.)

    call    ExitProcess                     ; And lastly, we're outta here - we call ExitProcess to end our program.

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
