global get_words
global compare_func
global sort

extern strtok
extern strcpy
extern strlen
extern strcmp
extern qsort

section .data
    delims db ' ,.', 10, 0

section .text

;; Function used by qsort
; int cmp(const void*,const void*)
cmp_custom:
    enter 0, 0

    mov ebx, dword[ebp + 8]     ; pointer to the first string
    mov edx, dword[ebp + 12]    ; pointer to the second string

    mov ebx, dword[ebx]         ; first string
    mov edx, dword[edx]         ; second strings

    ;; Firstly, check if the words have the same length
    push edx
    push ebx
    call strlen
    pop ebx
    pop edx

    mov ecx, eax                ; the length of the first word

    push ecx                    ; save the ecx value, to not
                                ; be modified by strlen() call
    push ebx
    push edx
    call strlen
    pop edx
    pop ebx
    pop ecx

    ;; ecx has the length of the first string, eax has the second length
    cmp ecx, eax
    jg longer
    jl smaller


equal:
;; Use strcmp to sort the words lexicographically
    push edx
    push ebx
    call strcmp
    add esp, 8
    jmp out

longer:
    mov eax, 1
    jmp out
smaller:
    mov eax, -1
    jmp out

out:
    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0

    push cmp_custom
    push dword[ebp + 16]
    push dword[ebp + 12]
    push dword[ebp + 8]
    call qsort
    add esp, 16

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

    mov ebx, dword[ebp + 8]                 ; original string
    mov edx, dword[ebp + 12]                ; the words string, which will be completed
    mov ecx, dword[ebp + 16]                ; number of words that has to be extracted

;; Put the tokens in the given array, in reverse ordere than it appears in the text
extract_all_words:
    ;; use strtok to get all the words
    push ebx
    push ecx
    push edx                                ; these registers will be used immediately after strtok() call,
                                            ; to store the value returned in memory
    
    ; eax will be NULL / pointer to the start of the original string
    cmp ecx, dword[ebp + 16]
    jne make_it_null
    mov eax, ebx
    jmp continue

make_it_null:
    mov eax, 0

continue:
    push delims
    push eax
    call strtok
    add esp, 8

    pop edx
    pop ecx

    ;; because there is already enough space allocated to store the token,
    ;; I call strcpy to put into memory (other possibility would've been to store directly the pointer
    ;; in the tokens array, without copying it (shallow copy))
    pusha
    push eax                                    ; source
    push dword[edx + (ecx - 1) * 4]             ; destination
    call strcpy
    add esp, 8
    popa

    pop ebx
    loop extract_all_words

    leave
    ret
