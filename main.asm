; NASM Uppercase String Converter
; This program takes a user input string and converts it to uppercase.
%assign ASCII_DIFF 32
%assign ASCII_END 'z'
%assign ASCII_START 'a'
%assign MAX_LENGTH 128
%assign NULL 0h
%assign STDIN 0
%assign STDOUT 1
%assign SYS_EXIT 1
%assign SYS_READ 3
%assign SYS_WRITE 4

section .data
    prompt db 'Please enter your name: ', NULL     ; message string asking user for their name
    output_msg db 'Your name in uppercase: ', NULL ; message string to output result of name converted to uppercase

section .bss
    input resb MAX_LENGTH    ; reserve a MAX_LENGTH (128) byte space in memory for user input

section .text
    global _start

_start:
    ; Print the prompt message
    mov eax, prompt     ; move address of prompt message string into EAX
    call strlen         ; call function to calculate length of the string
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
    cmp al, NULL        ; check for null terminator
    je print_result     ; if zero, end of string
    cmp al, ASCII_START ; check if lowercase
    jl skip_conversion  ; skip if less than 'a'
    cmp al, ASCII_END   ; check if greater than 'z'
    jg skip_conversion  ; skip if greater than 'z'
    sub al, ASCII_DIFF  ; convert to uppercase
    mov [ecx], al       ; store back the uppercase character
skip_conversion:
    inc ecx             ; move to the next character
    jmp convert_loop    ; repeat

print_result:
    ; Print the output message
    mov eax, output_msg ; move address of output message string into EAX
    call strlen         ; call function to calculate length of the string
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
    ret                 ; return to where the function was called

    
strlen:
    push ebx            ; push the value in EBX onto the stack
    mov ebx, eax        ; move the address in EAX into EBX (point to same segment in memory)
 
nextchar:
    cmp byte [eax], NULL; compare the byte at this address against zero
    jz  finished        ; jump to code labeled 'finished'
    inc eax             ; increment the addresd in EAX by one byte
    jmp nextchar        ; jump to code labeled 'nextchar'
 
finished:
    sub eax, ebx        ; subtract the address in EBX from the address in EAX
    pop ebx             ; pop the value on the stack back into EBX
    ret                 ; return to where the function was called
