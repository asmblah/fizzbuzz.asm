;
; FizzBuzz in NASM x86 assembly for OSX
;
; Copyright (c) Dan Phillimore (dan@ovms.co)
; https://github.com/asmblah/fizzbuzz.asm
;
; Released under the MIT license
; https://github.com/asmblah/fizzbuzz.asm/raw/master/MIT-LICENSE.txt
;

section    .text

global start  ; Program entry point

start:
    ; Print start message
    push dword startMessageLength
    push dword startMessage
    push dword 1      ; File descriptor (stdout)
    mov eax, 4        ; System call number (sys_write)
    sub esp, 4        ; OS X system calls need extra space on the stack
    int 0x80          ; Call kernel

    mov [counter], byte 1
next_number:
    mov al, [counter]
    xor ah, ah
    mov bl, 3
    div bl
    cmp ah, 0         ; Check remainder (modulo 3)
    jne not_fizz

    ; Handle "FizzBuzz"
    mov al, [counter]
    xor ah, ah
    mov bl, 5
    div bl
    cmp ah, 0         ; Check remainder (modulo 5)
    jne not_fizzbuzz
    ; Print "FizzBuzz"
    push dword 9
    push dword fizzBuzzMessage
    push dword 1      ; File descriptor (stdout)
    mov eax, 4        ; System call number (sys_write)
    sub esp, 4        ; OS X system calls need extra space on the stack
    int 0x80          ; Call kernel
    jmp finished_this_number
not_fizzbuzz:

    ; Print "Fizz"
    push dword 5
    push dword fizzMessage
    push dword 1      ; File descriptor (stdout)
    mov eax, 4        ; System call number (sys_write)
    sub esp, 4        ; OS X system calls need extra space on the stack
    int 0x80          ; Call kernel
    jmp finished_this_number
not_fizz:
    mov al, [counter]
    xor ah, ah
    mov bl, 5
    div bl
    cmp ah, 0         ; Check remainder (modulo 5)
    jne not_fizz_or_buzz
    ; Print "Buzz"
    push dword 5
    push dword buzzMessage
    push dword 1      ; File descriptor (stdout)
    mov eax, 4        ; System call number (sys_write)
    sub esp, 4        ; OS X system calls need extra space on the stack
    int 0x80          ; Call kernel
    jmp finished_this_number
not_fizz_or_buzz:
    ; Build second & third chars of number string
    mov al, [counter]
    xor ah, ah
    mov bl, 10
    div bl
    cmp al, 0         ; Check remainder (modulo 10) to see whether we have a 2-digit decimal number
    je skip_padding
    add al, 48        ; Add ASCII index of char "0" to byte
    mov [counterMessage], al
skip_padding:
    add ah, 48        ; Add ASCII index of char "0" to byte
    mov [counterMessage+1], ah

    ; Print number string
    push dword 3      ; Use a string of 3 bytes to allow up to 98 + newline char
    push dword counterMessage
    push dword 1      ; File descriptor (stdout)
    mov eax, 4        ; System call number (sys_write)
    sub esp, 4        ; OS X system calls need extra space on the stack
    int 0x80          ; Call kernel

finished_this_number:
    add [counter], byte 1
    cmp [counter], byte 100
    jle next_number

    ; Print end message
    push dword endMessageLength
    push dword endMessage
    push dword 1      ; File descriptor (stdout)
    mov eax, 4        ; System call number (sys_write)
    sub esp, 4        ; OS X system calls need extra space on the stack
    int 0x80          ; Call kernel

quit:
    mov eax, 1        ; System call number (sys_exit)
    sub esp, 4        ; OS X system calls need extra space on the stack
    int 0x80          ; Call kernel

section    .data

counter db 0

; NB: 0xa char at the end of each string terminates it with a newline

; 3 bytes - 2 spaces to be populated with number + 1 for the newline
counterMessage db '  ', 0xa

startMessage db 'FizzBuzz test', 0xa
startMessageLength equ $ - startMessage

fizzMessage db 'Fizz', 0xa
buzzMessage db 'Buzz', 0xa
fizzBuzzMessage db 'FizzBuzz', 0xa

endMessage db 'Done!', 0xa
endMessageLength equ $ - endMessage
