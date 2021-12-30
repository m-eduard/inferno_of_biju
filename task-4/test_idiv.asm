section .data
    format db 'Result is: %d', 10, 0

section .text
    global main
    extern printf

main:
    push ebp
    mov ebp, esp

    mov eax, -100
    mov edx, 0

    mov ecx, 2
    ; cdq
    push ecx
    imul dword[esp]
    add esp, 4

    push eax

    push dword[esp + 4]
    push format
    call printf
    add esp, 8

    pop eax

    mov esp, ebp
    pop ebp
    ret