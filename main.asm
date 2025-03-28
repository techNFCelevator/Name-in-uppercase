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
    mov edx, eax        ; the prompt message length
    mov eax, SYS_WRITE  ; sys_write, system call for writing output
    mov ebx, STDOUT     ; file descriptor 1 (standard ouput), write to the screen 
    mov ecx, prompt     ; the address of the prompt message to write
    int 0x80            ; make the system call to print the message

    ; Read user input
    mov eax, SYS_READ   ; sys_read, system call for reading input
    mov ebx, STDIN      ; file descriptor 0 (standard input), read from the keyboard
    mov ecx, input      ; buffer to store input
    mov edx, MAX_LENGTH ; number of bytes to read, maximum length (128)
    int 0x80            ; make the system call to read input

    ; Convert to uppercase
    mov ecx, input      ; pointer to string (ecx points to the beginning of the input string)

convert_loop:
    mov al, [ecx]       ; load a byte at the current position of the string
    cmp al, NULL        ; check for null terminator (end of string)
    je print_result     ; jump if equal to zero (end of string), jump to code labeled 'print_result'
    
    ; check if character is a lowercase letter (between 'a' and 'z')
    cmp al, ASCII_START ; check if less than 'a'
    jl skip_conversion  ; skip conversion, jump if less than 'a'. Jump to code labeled 'skip_conversion'
    cmp al, ASCII_END   ; check if greater than 'z'
    jg skip_conversion  ; skip conversion. jump if greater than 'z'. Jump to code labeled 'skip_conversion'
    
    ; convert the character to uppercase
    sub al, ASCII_DIFF  ; convert to uppercase (lowercase ASCII value - 32)
    mov [ecx], al       ; store back the uppercase character

skip_conversion:
    inc ecx             ; move to the next character in the string (increment by 1)
    jmp convert_loop    ; repeat the conversion loop for the next character, jump to code labeled 'convert_loop'

print_result:
    ; Print the output message
    mov eax, output_msg ; move address of output message string into EAX
    call strlen         ; call function to calculate length of the string
    mov edx, eax        ; the output message length
    mov eax, SYS_WRITE  ; sys_write, system call for writing output
    mov ebx, STDOUT     ; file descriptor 1 (standard ouput), write to the screen
    mov ecx, output_msg ; the address of the output message to write
    int 0x80            ; make the system call to print the message

    ; Print the converted string
    mov eax, SYS_WRITE  ; sys_write, system call for writing output
    mov ebx, STDOUT     ; file descriptor 1 (standard ouput), write to the screen
    mov ecx, input      ; the address of the uppercase string to write
    mov edx, MAX_LENGTH ; max length to print
    int 0x80            ; make the system call to print the converted string

    ; Exit program
    mov eax, SYS_EXIT   ; sys_exit
    xor ebx, ebx        ; return code 0
    int 0x80            ; make the system call to exit the program
    
strlen:
    push ebx            ; push the value in EBX onto the stack
    mov ebx, eax        ; move the address in EAX into EBX (point to same segment in memory)
 
nextchar:
    cmp byte [eax], NULL; compare the byte at this address against zero
    jz  finished        ; jump to code labeled 'finished'
    inc eax             ; increment the address in EAX by one byte
    jmp nextchar        ; jump to code labeled 'nextchar'
 
finished:
    sub eax, ebx        ; subtract the address in EBX from the address in EAX
    pop ebx             ; pop the value on the stack back into EBX
    ret                 ; return to where the function was called
