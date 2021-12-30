struc   point
    .x: resd 1
    .y: resd 1
    .z: resd 1
endstruc

section .data
    format db 'number: %d', 10, 0
    pointArray:    times point_size * 100    db 0

; point_mine:
;     istruc point
;         at x, dw        69
;         at y, dw        420
;     iend



section .text
    global main
    extern printf

main:
    enter 0, 0

    mov ecx, 100

    ; mov word [point_mine + x], 100
    ; ; push dword[point_mine + point.y]
    ; ; push format
    ; ; call printf
    ; ; add esp, 8

loop_array:
    push ecx
    lea eax, [pointArray + (ecx - 1) * point_size]
    mov dword[eax + point.x], 13232
    mov dword[eax + point.y], 112

    ; push dword[pointArray + (ecx - 1) * point_size]
    push eax
    push format
    call printf
    add esp, 8
    pop ecx

    loop loop_array

    ; push eax
    ; push format
    ; call printf
    ; add esp, 8

    leave
    ret