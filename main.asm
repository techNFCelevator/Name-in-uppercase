; NASM Uppercase String Converter
; This program takes a user input string and converts it to uppercase.
%assign MAX_LENGTH 128
%define STDIN 0
%define STDOUT 1
%define SYS_EXIT 0
%define SYS_READ 3
%define SYS_WRITE 4

section .data
    prompt db 'Please enter your name: ', 0h
    length db MAX_LENGTH
    output_msg db 'Your name in uppercase: ', 0h

section .bss
    input resb MAX_LENGTH

section .text
    global _start

_start:
    ; Print the prompt message
    mov eax, prompt
    call strlen
    mov edx, eax        ; message length
    mov eax, SYS_WRITE  ; sys_write
    mov ebx, STDOUT     ; file descriptor (stdout)
    mov ecx, prompt     ; message to write
    int 0x80

    ; Read user input
    mov eax, SYS_READ   ; sys_read
    mov ebx, STDIN      ; file descriptor (stdin)
    mov ecx, input      ; buffer to store input
    mov edx, MAX_LENGTH ; maximum length
    int 0x80

    ; Convert to uppercase
    mov ecx, input      ; pointer to string
convert_loop:
    mov al, [ecx]       ; load a byte from the string
    cmp al, 0           ; check for null terminator
    je print_result     ; if zero, end of string
    cmp al, 'a'         ; check if lowercase
    jl skip_conversion  ; skip if less than 'a'
    cmp al, 'z'         ; check if greater than 'z'
    jg skip_conversion  ; skip if greater than 'z'
    sub al, 32          ; convert to uppercase
    mov [ecx], al       ; store back the uppercase character
skip_conversion:
    inc ecx             ; move to the next character
    jmp convert_loop    ; repeat

print_result:
    ; Print the output message
    mov eax, output_msg
    call strlen
    mov edx, eax        ; message length
    mov eax, SYS_WRITE  ; sys_write
    mov ebx, STDOUT     ; file descriptor (stdout)
    mov ecx, output_msg ; message to write
    int 0x80

    ; Print the converted string
    mov eax, SYS_WRITE  ; sys_write
    mov ebx, STDOUT     ; file descriptor (stdout)
    mov ecx, input      ; uppercase string
    mov edx, MAX_LENGTH ; max length to print
    int 0x80

    ; Exit program
    mov eax, SYS_EXIT   ; sys_exit
    xor ebx, ebx        ; return code 0
    int 0x80
    
strlen:
    push ebx
    mov ebx, eax
 
nextchar:
    cmp byte [eax], 0
    jz  finished
    inc eax
    jmp nextchar
 
finished:
    sub eax, ebx
    pop ebx
    ret
